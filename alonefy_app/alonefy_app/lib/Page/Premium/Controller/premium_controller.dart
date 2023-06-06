import 'dart:async';

import 'package:get/get.dart';
//import for GooglePlayProductDetails
//import for SkuDetailsWrapper
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:ifeelefine/Model/ApiRest/PremiumApi.dart';
import 'package:ifeelefine/Page/Premium/Service/premiumService.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import '../../../Controllers/mainController.dart';

class PremiumController extends GetxController {
  StreamSubscription? _purchaseUpdatedSubscription;
  StreamSubscription? _purchaseErrorSubscription;
  StreamSubscription? _conectionSubscription;

  static const String subscriptionId = 'subscription_test';
  static const String subscriptionFreeTrialId = 'subscription_test_free_trial';

  final _prefs = PreferenceUser();

  Function? _response = null;

  List<String> _productLists = [subscriptionId, subscriptionFreeTrialId];
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];

  //void _loadProducts() async {
  //  final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(_kProducts);
  //  if (response.notFoundIDs.isNotEmpty) {
  //    // Handle the error.
  //  }
  //  List<ProductDetails> products = response.productDetails;
//
  //  if (products[0] is GooglePlayProductDetails) {
  //    SkuDetailsWrapper skuDetails = (products[0] as GooglePlayProductDetails).skuDetails;
  //    print(skuDetails.introductoryPricePeriod);
  //  }
//
  //  await InAppPurchase.instance.purchaseStream;
//
  //  if (purchaseDetails is GooglePlayPurchaseDetails) {
  //    PurchaseWrapper billingClientPurchase = (purchaseDetails as GooglePlayPurchaseDetails).billingClientPurchase;
  //    print(billingClientPurchase.originalJson);
  //  }
  //}

  Future<void> initPlatformState() async {
    // prepare
    var result = await FlutterInappPurchase.instance.initialize();
    print('result: $result');

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) async {
      if (await isSubscribed()) {
        _prefs.setUserPremium = true;
      } else {
        _prefs.setUserPremium = false;
      }

      _updatePremiumAPI();

      _getProducts();
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      if (_response != null) {
        _response!(true);
        _prefs.setUserPremium = true;
        _updatePremiumAPI();
        print('purchase-updated: $productItem');
      }
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      if (_response != null) _response!(false);
      print('purchase-error: $purchaseError');
    });
  }

  void requestPurchase(IAPItem item) {
    FlutterInappPurchase.instance.requestPurchase(item.productId!);
  }

  void requestPurchaseByProductId(String productId, Function response) {
    _response = response;
    FlutterInappPurchase.instance.requestPurchase(productId);
  }

  Future _getProducts() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(_productLists);
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);

      if (item.productId == subscriptionId ||
          item.productId == subscriptionFreeTrialId) {
        _prefs.setPremiumPrice = '${item.localizedPrice!}/mes';
      }
    }
  }

  Future<bool> isSubscribed() async {
    var purchases = await _getPurchases();

    if (purchases != null && _purchases.isNotEmpty) {
      for (var item in purchases) {
        if (item.productId == subscriptionId ||
            item.productId == subscriptionFreeTrialId) {
          return true;
        }
      }
    }

    return false;
  }

  Future<List<PurchasedItem>?> _getPurchases() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getAvailablePurchases();
    for (var item in items!) {
      print("Available purchases: " + item.productId!);
    }

    return items;
  }

  void dispose() {
    if (_conectionSubscription != null) {
      _conectionSubscription!.cancel();
      _conectionSubscription = null;
    }
  }

  void _updatePremiumAPI() async {
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();
    PremiumApi premiumApi = PremiumApi();
    premiumApi.phoneNumber = user.telephone;
    premiumApi.premium = _prefs.getUserPremium;
    PremiumService().saveData(premiumApi);
  }
}

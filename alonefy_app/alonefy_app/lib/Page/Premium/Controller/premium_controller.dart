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
  StreamSubscription? _connectionSubscription;

  static const String subscriptionId = 'subscription';
  static const String subscriptionFreeTrialId = 'subscription_free_trial';

  final _prefs = PreferenceUser();

  Function? _response = null;

  List<String> _productLists = [subscriptionId, subscriptionFreeTrialId];
  List<IAPItem> _items = [];

  Future<void> initPlatformState() async {
    // prepare
    var result = await FlutterInappPurchase.instance.initialize();
    print('result: $result');

    _connectionSubscription =
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

    _getProducts();
    if (await isSubscribed()) {
      _prefs.setUserPremium = true;
    } else {
      _prefs.setUserPremium = false;
    }
  }

  void requestPurchase(IAPItem item) {
    FlutterInappPurchase.instance.requestSubscription(item.productId!);
  }

  void requestPurchaseByProductId(String productId, Function response) {
    _response = response;
    //FlutterInappPurchase.instance.requestPurchase(productId);
    try {
      FlutterInappPurchase.instance.requestSubscription(productId);
    } catch (e) {
      print(e);
    }
  }

  Future _getProducts() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getSubscriptions(_productLists);
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

    if (purchases != null && purchases.isNotEmpty) {
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

  @override
  void dispose() {
    super.dispose();
    if (_connectionSubscription != null) {
      _connectionSubscription!.cancel();
      _purchaseErrorSubscription?.cancel();
      _purchaseUpdatedSubscription?.cancel();
      FlutterInappPurchase.instance.finalize();
    }
  }

  void _updatePremiumAPI() async {
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();
    PremiumApi premiumApi = PremiumApi(
        phoneNumber: user.telephone.contains('+34')
            ? user.telephone.replaceAll("+34", "")
            : user.telephone,
        premium: _prefs.getUserPremium);
    PremiumService().saveData(premiumApi);
  }
}

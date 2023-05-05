import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/useMobilbd.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/UseMobil/Service/useMobilService.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Provider/user_provider.dart';
//import 'package:pay/pay.dart';

final _prefs = PreferenceUser();

class UseMobilController extends GetxController {
  final UseMobilService useMobilServ = Get.put(UseMobilService());

  Future<bool> saveTimeUseMobil(
      BuildContext context, String time, UserBD userbd) async {
    _prefs.setUseMobil = time;
    final List<String> tempNoSelectListDay = <String>[
      "L",
      "M",
      "X",
      "J",
      "V",
      "S",
      "D",
    ];
    final List<UseMobilBD> selectedDays = [];
    for (var element in tempNoSelectListDay) {
      UseMobilBD useDay =
          UseMobilBD(day: element, time: time, selection: 0, isSelect: true);

      selectedDays.add(useDay);
    }
    Map<String, dynamic> resp =
        await useMobilServ.saveUseMobil(selectedDays, userbd);
    if (resp["id"] != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveHabitsMobil(BuildContext context, String time) async {
    _prefs.setUseMobil = time;

    showAlert(context, "Se guardo correctamente");
  }

  Future<String> getTimeUseMobil() async {
    return _prefs.getUseMobil;
  }

  Future payAlgo() async {
    // List<PaymentItem> items = [];
    // items = [
    //   const PaymentItem(
    //     label: 'Total',
    //     amount: '1.99',
    //     status: PaymentItemStatus.final_price,
    //   )
    // ];

    // FlutterPay flutterPay = FlutterPay();

    // bool isAvailable = await flutterPay.canMakePayments();

    // flutterPay.setEnvironment(environment: PaymentEnvironment.Test);

    // String token = await flutterPay.requestPayment(
    //   googleParameters: GoogleParameters(
    //     gatewayName: "example",
    //     gatewayMerchantId: "example_id",
    //     merchantId: "example_merchant_id",
    //     merchantName: "exampleMerchantName",
    //   ),
    //   appleParameters:
    //       AppleParameters(merchantIdentifier: "merchant.flutterpay.example"),
    //   currencyCode: "USD",
    //   countryCode: "US",
    //   paymentItems: items,
    // );

    // print(token);
  }
}

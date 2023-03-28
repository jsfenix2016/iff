import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Provider/user_provider.dart';
import 'package:pay/pay.dart';

final _prefs = PreferenceUser();

class UseMobilController extends GetxController {
  late var validateEmail = false.obs;
  late var validateSms = false.obs;

  Future<void> saveTimeUseMobil(BuildContext context, String time) async {
    _prefs.setUseMobil = time;
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

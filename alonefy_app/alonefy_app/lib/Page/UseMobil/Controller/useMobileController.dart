import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/useMobilbd.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/UseMobil/Service/useMobilService.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Provider/user_provider.dart';

import '../../../Data/hive_data.dart';
import '../../../Model/ApiRest/UseMobilApi.dart';
//import 'package:pay/pay.dart';

final _prefs = PreferenceUser();

class UseMobilController extends GetxController {
  final UseMobilService useMobilServ = Get.put(UseMobilService());

  Future<UserBD> getUserData() async {
    try {
      return await const HiveData().getuserbd;
    } catch (error) {
      return initUserBD();
    }
  }

  Future<void> saveTimeUseMobil(
      BuildContext context, String time, UserBD userbd) async {
    //_prefs.setHabitsTime = time;
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
    for (var element in Constant.tempListShortDay) {
      UseMobilBD useDay =
          UseMobilBD(day: element, time: time, selection: 0, isSelect: true);

      selectedDays.add(useDay);
    }
    await const HiveData().saveListTimeUseMobil(selectedDays);

    List<UseMobilApi> listMobilApi = _convertToApi(selectedDays, userbd);

    useMobilServ.saveUseMobil(listMobilApi);
  }

  List<UseMobilApi> _convertToApi(List<UseMobilBD> listMobilBD, UserBD userBD) {
    List<UseMobilApi> listMobilApi = [];

    for (var useMobil in listMobilBD) {
      var useMobilApi = UseMobilApi(
          phoneNumber: userBD.telephone,
          dayOfWeek: useMobil.day,
          time: _convertTimeToInt(useMobil.time),
          index: useMobil.selection,
          isSelect: useMobil.isSelect);

      listMobilApi.add(useMobilApi);
    }

    return listMobilApi;
  }

  int _convertTimeToInt(String strTime) {
    var strTimeTemp = strTime;
    strTimeTemp = strTimeTemp.replaceAll(" min", "");
    strTimeTemp = strTimeTemp.replaceAll(" hora", "");

    int minutes = int.parse(strTimeTemp);
    if (strTime.contains("hora")) {
      minutes = hourToInt(strTimeTemp) * 60;
    }

    return minutes;
  }

  //Future<void> saveHabitsMobil(BuildContext context, String time) async {
  //  _prefs.setHabitsTime = time;
//
  //  showAlert(context, "Se guardo correctamente");
  //}

  //Future<String> getTimeUseMobil() async {
  //  return _prefs.getUseMobil;
  //}

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

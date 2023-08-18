import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/useMobilbd.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/UseMobil/Service/useMobilService.dart';

import '../../../Model/ApiRest/UseMobilApi.dart';
//import 'package:pay/pay.dart';

class UseMobilController extends GetxController {
  final UseMobilService useMobilServ = Get.put(UseMobilService());

  Future<UserBD> getUserData() async {
    try {
      return await const HiveData().getuserbd;
    } catch (error) {
      return initUserBD();
    }
  }

  Future<bool> saveTimeUseMobil(
      BuildContext context, String time, UserBD userbd) async {
    final List<UseMobilBD> selectedDays = [];
    for (var element in Constant.tempListShortDay) {
      UseMobilBD useDay =
          UseMobilBD(day: element, time: time, selection: 0, isSelect: true);

      selectedDays.add(useDay);
    }
    await const HiveData().saveListTimeUseMobil(selectedDays);

    List<UseMobilApi> listMobilApi = _convertToApi(selectedDays, userbd);

    return await useMobilServ.saveUseMobil(listMobilApi);
  }

  List<UseMobilApi> _convertToApi(List<UseMobilBD> listMobilBD, UserBD userBD) {
    List<UseMobilApi> listMobilApi = [];
    for (var useMobil in listMobilBD) {
      var useMobilApi = UseMobilApi(
          phoneNumber: userBD.telephone.contains('+34')
              ? userBD.telephone.replaceAll("+34", "")
              : userBD.telephone,
          dayOfWeek: Constant.tempMapDayApi[useMobil.day]!,
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
}

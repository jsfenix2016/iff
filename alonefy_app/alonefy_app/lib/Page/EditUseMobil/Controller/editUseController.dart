import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/useMobilbd.dart';
import 'package:ifeelefine/Page/EditUseMobil/Service/editUseMobilService.dart';

import '../../../Controllers/mainController.dart';

import '../../../Model/ApiRest/UseMobilApi.dart';

class EditUseMobilController extends GetxController {
  final EditUseMobilService editUseMobilServ = Get.put(EditUseMobilService());

  Future<Map<String, List<UseMobilBD>>> getTimeUseMobil() async {
    var user = await const HiveData().getuserbd;
    return editUseMobilServ.getUseMobil(user);
  }

  Future<List<UseMobilBD>> getTimeUseMobilBD() async {
    var listUse = await const HiveData().listUseMobilBd;
    return listUse;
  }

  Future<bool> saveTimeUseMobil(List<UseMobilBD> selecDicActivity) async {
    var user = await const HiveData().saveListTimeUseMobil(selecDicActivity);

    saveTimeUseMobilApi(selecDicActivity);

    if (user != -1) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveTimeUseMobilApi(List<UseMobilBD> listMobilBD) async {
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    var listUseMobilApi = _convertToApi(listMobilBD, user.telephone);

    EditUseMobilService().saveUseMobil(listUseMobilApi);
  }

  List<UseMobilApi> _convertToApi(
      List<UseMobilBD> listMobilBD, String phoneNumber) {
    List<UseMobilApi> listMobilApi = [];

    for (var useMobil in listMobilBD) {
      var useMobilApi = UseMobilApi(
          phoneNumber: phoneNumber.contains("+34")
              ? phoneNumber.replaceAll("+34", "")
              : phoneNumber,
          dayOfWeek: Constant.tempMapDayApi[useMobil.day]!,
          time: stringTimeToInt(useMobil.time),
          index: useMobil.selection,
          isSelect: useMobil.isSelect);

      listMobilApi.add(useMobilApi);
    }

    return listMobilApi;
  }

  Future<void> saveUseMobilFromApi(List<UseMobilApi> useMobilApiList) async {
    var list = _convertFromApi(useMobilApiList);
    await const HiveData().saveListTimeUseMobil(list);
  }

  List<UseMobilBD> _convertFromApi(List<UseMobilApi> useMobilApiList) {
    List<UseMobilBD> list = [];

    for (var useMobilApi in useMobilApiList) {
      var useMobil = UseMobilBD(
          day: Constant.tempMapDayReverseApi[useMobilApi.dayOfWeek]!,
          time: minutesToString(useMobilApi.time),
          selection: useMobilApi.index,
          isSelect: useMobilApi.isSelect);

      list.add(useMobil);
    }

    return list;
  }

  int _convertTimeToInt(String strTime) {
    var strTimeTemp = strTime;
    strTimeTemp = strTimeTemp.replaceAll(" min", "");
    strTimeTemp = strTimeTemp.replaceAll(" hora", "");

    int minutes = 0;
    if (strTime.contains("hora")) {
      minutes = hourToInt(strTimeTemp) * 60;
    }

    return minutes;
  }

  Future<void> saveTimeUseMobileFromHabits(
      BuildContext context, String time) async {
    var useMobileList = await const HiveData().listUseMobilBd;

    List<UseMobilBD> useMobileUpdate = [];

    for (var useMobileDay in useMobileList) {
      useMobileDay.time = time;
      useMobileUpdate.add(useMobileDay);
    }

    saveTimeUseMobil(useMobileList);
  }

  Map<String, String> getMapWithHabitsTime(String habits) {
    if (habits != null && habits.isNotEmpty) {
      var timeDic = Constant.timeDic;
      var habitsOnlyNumber = int.parse(habits.replaceAll(" min", ""));

      Map<String, String> timeWithHabits = <String, String>{};

      var count = 0;
      var habitsIsIncluded = false;
      for (var time in timeDic.values) {
        if (time.contains("min")) {
          if (habitsOnlyNumber < minToInt(time) && !habitsIsIncluded) {
            timeWithHabits["$count"] = habits;
            var c = count + 1;
            timeWithHabits["$c"] = time;
            habitsIsIncluded = true;
          } else {
            if (habitsIsIncluded) {
              var c = count + 1;
              timeWithHabits["$c"] = time;
            } else {
              timeWithHabits["$count"] = time;
            }
          }
        } else if (time.contains("hora")) {
          var minutes = hourToInt(time) * 60;
          if (habitsOnlyNumber < minutes && !habitsIsIncluded) {
            timeWithHabits["$count"] = habits;
            var c = count + 1;
            timeWithHabits["$c"] = time;
            habitsIsIncluded = true;
          } else {
            if (habitsIsIncluded) {
              var c = count + 1;
              timeWithHabits["$c"] = time;
            } else {
              timeWithHabits["$count"] = time;
            }
          }
        }
        count++;
      }

      if (timeDic.length == timeWithHabits.length) {
        timeWithHabits["$count"] = habits;
      }

      return timeWithHabits;
    } else {
      return Constant.timeDic;
    }
  }
}

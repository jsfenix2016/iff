import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/restday.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/UserRest/Service/userRestService.dart';
import 'package:jiffy/jiffy.dart';

import '../../../Common/Constant.dart';
import '../../../Model/ApiRest/UserRestApi.dart';

class UserRestController extends GetxController {
  final UserRestService userRestServ = Get.put(UserRestService());

  late var validateEmail = false.obs;
  late var validateSms = false.obs;
  Box? box;

  Future<int> saveRestTime(BuildContext context, RestDayBD restDay) async {
    try {
      return const HiveData().saveTimeRest(restDay);
    } catch (error) {
      return -1;
    }
  }

  Future<int> saveUserListRestTime(
      BuildContext context, List<RestDayBD> listRest) async {
    try {
      var user = await const HiveData().getuserbd;
      var listApi = await _convertRestBDToRestDayApi(listRest, user);
      var resp = await userRestServ.saveData(listApi);
      if (resp) {
        return const HiveData().saveListTimeRest(listRest);
      } else {
        return -1;
      }
    } catch (error) {
      return -1;
    }
  }

  Future<List<UserRestApi>> _convertRestBDToRestDayApi(List<RestDayBD> listRest, UserBD user) async {
    Jiffy.locale('es');

    List<UserRestApi> listRestApi = [];

    for (var restDayBD in listRest) {
      var wakeUpHour = parseDurationRow(restDayBD.timeWakeup);
      var retireHour = parseDurationRow(restDayBD.timeSleep);

      listRestApi.add(UserRestApi(
          phoneNumber: user.telephone.replaceAll("+34", ""),
          dayOfWeek: Constant.tempMapDayApi[restDayBD.day]!,
          wakeUpHour: wakeUpHour,
          retireHour: retireHour,
          index: restDayBD.selection,
          isSelect: restDayBD.isSelect)
      );
    }

    return listRestApi;
  }

  Future<int> deleteUserRestDay(BuildContext context, RestDayBD restDay) async {
    try {
      await const HiveData().deleteTimeRest(restDay);
      return 0;
    } catch (error) {
      return -1;
    }
  }

  Future<bool> updateUserRestTime(BuildContext context, RestDayBD user) async {
    return const HiveData().updateUserRestTime(user);
  }

  Future<List<RestDay>> getRestDays() async {
    var userRestDays = await getUserRest();

     return convertRestDayBDToRestDay(userRestDays);
  }

  Future<List<RestDay>> convertRestDayBDToRestDay(List<RestDayBD> userRestDays) async {
    List<RestDay> restDays = [];

    for (var userRestDay in userRestDays) {
      RestDay restDay = RestDay();
      restDay.day = userRestDay.day;
      restDay.timeWakeup = userRestDay.timeWakeup;
      restDay.timeSleep = userRestDay.timeSleep;
      restDay.selection = userRestDay.selection;

      restDays.add(restDay);
    }

    return restDays;
  }

  Future<void> saveFromApi(List<UserRestApi> userRestApiList) async {
    var list = await _convertFromApi(userRestApiList);
    await const HiveData().saveListTimeRest(list);
  }

  Future<List<RestDayBD>> _convertFromApi(List<UserRestApi> userRestApiList) async {
    List<RestDayBD> list = [];

    for (var userRestApi in userRestApiList) {
      var restDay = RestDayBD(
          day: Constant.tempMapDayReverseApi[userRestApi.dayOfWeek]!,
          timeWakeup: await _convertDateTimeToStringTime(userRestApi.wakeUpHour),
          timeSleep: await _convertDateTimeToStringTime(userRestApi.retireHour),
          selection: userRestApi.index,
          isSelect: userRestApi.isSelect
      );

      list.add(restDay);
    }

    return list;
  }

  Future<String> _convertDateTimeToStringTime(DateTime dateTime) async {
    if (dateTime.hour == 0 && dateTime.minute == 0) {
      return await convertDateTimeToStringTime(dateTime);
    } else {
      return dateTime.toIso8601String();
    }
  }

  Future<List<RestDayBD>> getUserRest() async {
    List<RestDayBD> box = await const HiveData().listUserRestDaybd;

    if (box.isNotEmpty) {
      return box.toList();
    } else {
      return [];
    }
  }
}

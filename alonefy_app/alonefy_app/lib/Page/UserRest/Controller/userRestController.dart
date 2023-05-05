import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/restday.dart';
import 'package:ifeelefine/Model/restdaybd.dart';

class UserRestController extends GetxController {
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
      BuildContext context, List<RestDayBD> activities) async {
    try {
      return const HiveData().saveListTimeRest(activities);
    } catch (error) {
      return -1;
    }
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

  Future<List<RestDayBD>> getUserRest() async {
    List<RestDayBD> box = await const HiveData().listUserRestDaybd;

    if (box.isNotEmpty) {
      return box.toList();
    } else {
      return [];
    }
  }
}

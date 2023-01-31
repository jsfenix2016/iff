import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/restdaybd.dart';

class UserRestController extends GetxController {
  late var validateEmail = false.obs;
  late var validateSms = false.obs;
  Box? box;

  Future<int> saveUserRestTime(
      BuildContext context, List<RestDayBD> activities) async {
    try {
      return const HiveData().saveTimeRest(activities);
    } catch (error) {
      return -1;
    }
  }

  Future<bool> updateUserDate(BuildContext context, RestDayBD user) async {
    try {
      Box<RestDayBD> box = await Hive.openBox<RestDayBD>('listRestDayBD');

      box.put(user.day, user);

      validateSms = true.obs;
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<RestDayBD>> getUserRest() async {
    // RestDayBD person = RestDayBD(day: '', timeSleep: '', timeWakeup: '');

    final box = await Hive.openBox<RestDayBD>('listRestDayBD');

    if (box.isEmpty == false) {
      // person = box.getAt(0)!;
      return box.values.toList();
    } else {
      return [];
    }
  }
}

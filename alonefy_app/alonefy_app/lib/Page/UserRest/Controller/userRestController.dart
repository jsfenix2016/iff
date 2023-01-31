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

  Future<bool> updateUserRestTime(BuildContext context, RestDayBD user) async {
    return const HiveData().updateUserRestTime(user);
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

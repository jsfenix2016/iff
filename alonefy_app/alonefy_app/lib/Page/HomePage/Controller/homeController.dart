import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';

import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class HomeController extends GetxController {
  final UserConfigCOntroller userVC = Get.put(UserConfigCOntroller());

  Future<List<LogAlertsBD>> getAllMov() async {
    late final List<LogAlertsBD> allMov = [];
    List<LogAlertsBD> temp = [];
    List<LogAlertsBD> box = await const HiveData().getAlerts();

    box.sort((a, b) {
      //sorting in descending order
      return b.time.compareTo(a.time);
    });

    for (var element in box) {
      allMov.add(element);
    }

    temp = removeDuplicates(allMov);

    return temp;
  }

  List<LogAlertsBD> removeDuplicates(List<LogAlertsBD> originalList) {
    return originalList.toSet().toList();
  }

  Future<bool> changeImage(BuildContext context, File foto, User user) async {
    try {
      Uint8List? bytes;
      String img64 = "";

      if (foto.path != "") {
        bytes = foto.readAsBytesSync();
        img64 = base64Encode(bytes);
        user.pathImage = img64;
      }

      if (user.idUser != '-1') {
        final userbd = UserBD(
            idUser: user.idUser.toString(),
            name: user.name,
            lastname: user.lastname,
            email: user.email,
            telephone: user.telephone,
            gender: user.gender,
            maritalStatus: user.maritalStatus,
            styleLife: user.styleLife,
            pathImage: user.pathImage,
            age: user.age,
            country: user.country,
            city: user.city);
        await userVC.updateUserDate(context, userbd);
      } else {
        await userVC.saveUserData(context, user, const Uuid().v1());
      }

      return true;
    } catch (error) {
      return false;
    }
  }
}

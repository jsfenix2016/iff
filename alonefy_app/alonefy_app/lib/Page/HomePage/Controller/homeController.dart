import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get/get.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';

import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/UserConfig2/Controller/userConfig2Controller.dart';
import 'package:ifeelefine/Page/UserEdit/Controller/editController.dart';
import 'package:ifeelefine/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

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
      if (!element.type.contains("Cita")) {
        allMov.add(element);
      }
    }

    temp = removeDuplicates(allMov);

    return temp;
  }

  List<LogAlertsBD> removeDuplicates(List<LogAlertsBD> originalList) {
    return originalList.toSet().toList();
  }

  Future<bool> changeImage(File foto, User user) async {
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
        await UserConfig2COntroller().updateUserDate(userbd);
        await EditConfigController().updateUserImage(userbd, bytes);
      } else {
        await userVC.saveUserData(user, const Uuid().v1());
      }

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<void> getpermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    await Permission.notification.isDenied.then((value) {
      print(value);
      if (value) {
        Permission.notification.request();
      } else {
        print(value);
      }
    });
    final bool? areNotificationsEnabled = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();

    if (areNotificationsEnabled ?? false) {
      print('Las notificaciones están habilitadas.');
    } else {
      print('Las notificaciones están deshabilitadas.');
    }

    if (androidInfo.version.sdkInt >= 33) {}
  }
}

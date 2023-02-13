import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:uuid/uuid.dart';

class HomeController extends GetxController {
  final UserConfigCOntroller userVC = Get.put(UserConfigCOntroller());

  Future<bool> changeImage(BuildContext context, File foto, User user) async {
    try {
      Uint8List? bytes;
      String img64 = "";

      if (foto.path != "") {
        bytes = foto.readAsBytesSync();
        img64 = base64Encode(bytes);
      }
      UserBD userbd = UserBD(
          idUser: user.idUser.toString(),
          name: user.name,
          lastname: user.lastname,
          email: user.email,
          telephone: user.telephone,
          gender: user.gender,
          maritalStatus: user.maritalStatus,
          styleLife: user.styleLife,
          pathImage: img64,
          age: user.age,
          country: user.country,
          city: user.city);

      if (user.idUser != -1) {
        await userVC.updateUserDate(context, userbd);
      } else {
        userbd.idUser = "0";
        await userVC.saveUserData(context, userbd, const Uuid().v1());
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}

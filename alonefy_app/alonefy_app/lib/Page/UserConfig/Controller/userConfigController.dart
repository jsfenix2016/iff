import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/UserConfig/Service/userService.dart';
import 'package:ifeelefine/Page/UserConfig2/Service/userConfig2Service.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Provider/user_provider.dart';

class UserConfigCOntroller extends GetxController {
  late var validateEmail = false.obs;
  late var validateSms = false.obs;

  final usuarioProvider = UsuarioProvider();
  final UserService userVC = Get.put(UserService());
  PreferenceUser prefs = PreferenceUser();

  Future<void> requestCode(BuildContext context, User user) async {
    if (user.telephone.isEmpty) {
      return;
    }
    var resq = await userVC.verificateSMS(int.parse(user.telephone));
    // var resq = await userVC.validateEmailWithMessageBird(user.email);
    if (resq["ok"]) {
      prefs.setHrefSMS = (resq["href"]);

      // Utiliza la variable local dentro del espacio asyncronizado
      await Future.delayed(const Duration(milliseconds: 10), () {
        showSaveAlert(context, Constant.info, "Se a enviado el codigo");
      });
    } else {
      // Utiliza la variable local dentro del espacio asyncronizado
      await Future.delayed(const Duration(milliseconds: 10), () {
        showSaveAlert(context, Constant.info, Constant.errorGenericConextion);
      });
    }
  }

  Future<bool> validateCodeSMS(BuildContext context, String code) async {
    var res = await userVC.validateCodeSMS(prefs.getHrefSMS, code);

    if (res["ok"]) {
      prefs.setHrefSMS = (res["href"]);

      // Utiliza la variable local dentro del espacio asyncronizado
      await Future.delayed(const Duration(milliseconds: 10), () {
        showSaveAlert(context, Constant.info, Constant.codeValid);
      });
      return true;
    } else {
      await Future.delayed(const Duration(milliseconds: 10), () {
        showSaveAlert(context, Constant.info, Constant.codeInvalid);
      });
      return false;
    }
  }

  Future<bool> validateCodeEmail(BuildContext context, String code) async {
    var res = await userVC.validateCodeEmail(prefs.geIdTokenEmail, code);

    if (res["ok"]) {
      // Utiliza la variable local dentro del espacio asyncronizado
      await Future.delayed(const Duration(milliseconds: 10), () {
        showSaveAlert(context, Constant.info, "Codigo valido");
      });
      return true;
    } else {
      await Future.delayed(const Duration(milliseconds: 10), () {
        showSaveAlert(context, Constant.info, "Codigo invalido");
      });
      return false;
    }
  }

  Future<UserBD> saveUserData(
      BuildContext context, User user, String uuid) async {
    try {
      user.idUser = (uuid);
      var person = UserBD(
          idUser: user.idUser,
          name: user.name,
          lastname: user.lastname,
          email: user.email,
          telephone: user.telephone,
          gender: user.gender,
          maritalStatus: user.maritalStatus,
          styleLife: user.styleLife,
          pathImage: "",
          age: user.age,
          country: user.country,
          city: user.city);
      var resp = await UserService().saveData(person);
      if (resp) {
        UserBD usertemp = await const HiveData().saveUser(user);
        return usertemp;
      } else {
        UserBD person = initUserBD();
        return person;
      }
    } catch (error) {
      UserBD person = initUserBD();
      return person;
    }
  }

  Future<bool> updateUserDate(BuildContext context, UserBD user) async {
    try {
      // Map info

      await const HiveData().updateUser(user);

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<User> getUserDate() async {
    UserBD box = await const HiveData().getuserbd;
    if (box.idUser != "-1") {
      User user = User(
          idUser: (box.idUser),
          name: box.name,
          lastname: box.lastname,
          email: box.email,
          telephone: box.telephone,
          gender: box.gender,
          maritalStatus: box.maritalStatus,
          styleLife: box.styleLife,
          pathImage: box.pathImage,
          age: box.age,
          country: box.country,
          city: box.city);
      return user;
    } else {
      User person = initUser();
      return person;
    }
  }
}

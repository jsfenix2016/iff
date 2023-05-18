import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/UserConfig/Service/userService.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Provider/user_provider.dart';

class UserConfigCOntroller extends GetxController {
  late var validateEmail = false.obs;
  late var validateSms = false.obs;

  final usuarioProvider = UsuarioProvider();
  final UserService userVC = Get.put(UserService());
  PreferenceUser prefs = PreferenceUser();

  Future<void> requestCode(BuildContext context, User user) async {
    final localContext = context;

    var resq = await userVC.validateEmailWithMessageBird(user.email);
    if (resq["ok"]) {
      prefs.setIdTokenEmail = (resq["id"]);

      // Utiliza la variable local dentro del espacio asyncronizado
      Future.delayed(const Duration(milliseconds: 10), () {
        showAlert(localContext, "Revise su correo electronico");
      });
    } else {
      // Utiliza la variable local dentro del espacio asyncronizado
      Future.delayed(const Duration(milliseconds: 10), () {
        showAlert(localContext, "Algo salio mal, revise su conexión");
      });
    }
  }

  Future<bool> validateCodeSMS(BuildContext context, String code) async {
    final localContext = context;
    var res = await userVC.validateCodeSMS(prefs.getIdTokenSMS, code);

    if (res["ok"]) {
      prefs.setIdTokenSMS = (res["id"]);

      // Utiliza la variable local dentro del espacio asyncronizado
      Future.delayed(const Duration(milliseconds: 10), () {
        showAlert(localContext, "Codigo valido");
      });
      return true;
    } else {
      Future.delayed(const Duration(milliseconds: 10), () {
        showAlert(localContext, "Codigo invalido");
      });
      return false;
    }
  }

  Future<bool> validateCodeEmail(BuildContext context, String code) async {
    final localContext = context;
    var res = await userVC.validateCodeEmail(prefs.geIdTokenEmail, code);

    if (res["ok"]) {
      // Utiliza la variable local dentro del espacio asyncronizado
      Future.delayed(const Duration(milliseconds: 10), () {
        showAlert(localContext, "Codigo valido");
      });
      return true;
    } else {
      Future.delayed(const Duration(milliseconds: 10), () {
        showAlert(localContext, "Codigo invalido");
      });
      return false;
    }
  }

  Future<UserBD> saveUserData(
      BuildContext context, User user, String uuid) async {
    try {
      user.idUser = (uuid);
      UserBD usertemp = await const HiveData().saveUser(user);

      return usertemp;
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

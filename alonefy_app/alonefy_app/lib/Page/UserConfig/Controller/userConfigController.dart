import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Provider/user_provider.dart';

class UserConfigCOntroller extends GetxController {
  late var validateEmail = false.obs;
  late var validateSms = false.obs;
  Box? box;
  final usuarioProvider = UsuarioProvider();

  Future<bool> validateEmailUser(BuildContext context) async {
    try {
      // Map info
      await Future.delayed(const Duration(seconds: 5));
      validateEmail = true.obs;

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> validateSmsUser(
      BuildContext context, int num, String name) async {
    try {
      var res = await usuarioProvider.verificateSMS(num, name);
      validateSms = true.obs;
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<UserBD> saveUserData(
      BuildContext context, User user, String uuid) async {
    try {
      user.idUser = (uuid);
      return await const HiveData().saveUser(user);
    } catch (error) {
      UserBD person = UserBD(
          idUser: '-1',
          name: '',
          lastname: '',
          email: '',
          telephone: '',
          gender: '',
          maritalStatus: '',
          styleLife: '',
          pathImage: '',
          age: '18',
          country: '',
          city: '');
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

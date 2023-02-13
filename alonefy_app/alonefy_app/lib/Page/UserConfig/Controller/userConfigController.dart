import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
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
      var a = await usuarioProvider.verificateSMS(num, name);
      validateSms = true.obs;
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<int> saveUserData(
      BuildContext context, UserBD user, String uuid) async {
    try {
      return const HiveData().saveUser(user);
    } catch (error) {
      return -1;
    }
  }

  Future<bool> updateUserDate(BuildContext context, UserBD user) async {
    try {
      // Map info

      Box<UserBD> box = await Hive.openBox<UserBD>('userBD');

      await box.putAt(int.parse(user.idUser), user);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<UserBD> getUserDate() async {
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

    Box<UserBD> box = await Hive.openBox<UserBD>('userBD');
    if (box.isEmpty == false) {
      person = box.getAt(0)!;

      return person;
    } else {
      return person;
    }
  }
}

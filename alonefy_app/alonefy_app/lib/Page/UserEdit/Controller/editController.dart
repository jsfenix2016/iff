import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Provider/user_provider.dart';

class UserConfigCOntroller extends GetxController {
  final usuarioProvider = UsuarioProvider();

  Future<bool> updateUserDate(BuildContext context, UserBD user) async {
    try {
      // Map info

      Box<UserBD> box = await Hive.openBox<UserBD>('userBD');

      box.putAt(0, user);
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/UserConfig2/Service/userConfig2Service.dart';

class UserConfig2COntroller extends GetxController {
  final UserConfig2Service config2Serv = Get.put(UserConfig2Service());

  Future<UserBD> saveUserDataServer(
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
      var resp = await config2Serv.saveData(user);
      if (resp['errors'] != null) {
        // return false;
      }
      return true;
    } catch (error) {
      return false;
    }
  }
}

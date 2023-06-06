import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/UserConfig2/Service/userConfig2Service.dart';
import 'package:ifeelefine/Page/UserEdit/Service/editUserService.dart';

class UserConfig2COntroller extends GetxController {
  final UserConfig2Service config2Serv = Get.put(UserConfig2Service());

  Future<UserBD> getUserData() async {
    try {
      return await const HiveData().getuserbd;
    } catch (error) {
      return initUserBD();
    }
  }

  Future<bool> updateUserDate(BuildContext context, UserBD user) async {
    try {
      // Map info

      await const HiveData().updateUser(user);
      var resp = await EditUserService().updateUser(user);
      if (resp['errors'] != null) {
        // return false;
      }
      return true;
    } catch (error) {
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/useMobilbd.dart';
import 'package:ifeelefine/Page/EditUseMobil/Service/editUseMobilService.dart';

class EditUseMobilController extends GetxController {
  final EditUseMobilService editUseMobilServ = Get.put(EditUseMobilService());

  Future<Map<String, List<UseMobilBD>>> getTimeUseMobil() async {
    var user = await const HiveData().getuserbd;
    return editUseMobilServ.getUseMobil(user);
  }

  Future<List<UseMobilBD>> getTimeUseMobilBD() async {
    var listUse = await const HiveData().listUseMobilBd;
    return listUse;
  }

  Future<bool> saveTimeUseMobil(
      BuildContext context, List<UseMobilBD> selecDicActivity) async {
    var user = await const HiveData().saveListTimeUseMobil(selecDicActivity);
    if (user != -1) {
      return true;
    } else {
      return false;
    }
  }
}

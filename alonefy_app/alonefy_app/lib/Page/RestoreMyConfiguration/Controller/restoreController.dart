import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/RestoreMyConfiguration/Service/restoreService.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

final _prefs = PreferenceUser();

class RestoreController extends GetxController {
  final RestoreService restServ = Get.put(RestoreService());

  Future<void> sendData(
      BuildContext context, String number, String email) async {
    final resp = await restServ.restoreData(number, email);
    if (resp) {
      showAlert(context, "Se restauro correctamente");
    } else {
      showAlert(context,
          "Se produjo un error, verifique su conexion a internet e intente de nuevo.");
    }
  }
}

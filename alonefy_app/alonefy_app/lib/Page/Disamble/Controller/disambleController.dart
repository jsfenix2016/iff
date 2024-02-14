import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/Disamble/Service/deactivate_service.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/main.dart';

import 'package:jiffy/jiffy.dart';
import 'package:uuid/uuid.dart';

import '../../../Controllers/mainController.dart';

PreferenceUser prefs = PreferenceUser();

class DisambleController extends GetxController {
  Future<bool> saveDisamble(BuildContext context, String deactivateTime) async {
    await Jiffy.locale('es');
    var datetime = Jiffy(DateTime.now()).format(getDefaultPattern());

    await prefs.initPrefs();
    prefs.setStartDateTimeDisambleIFF = datetime;

    final MainController mainController = Get.put(MainController());
    user = await mainController.getUserData();

    var response = await DeactivateService().saveData(
        user!.telephone.contains('+34')
            ? user!.telephone.replaceAll("+34", "").replaceAll(" ", "")
            : user!.telephone.replaceAll(" ", ""),
        deactivateTimeToMinutes(deactivateTime));

    if (response) {
      if (deactivateTimeToMinutes(deactivateTime) != 0) {
        prefs.setEnableIFF = false;
        prefs.setDisambleIFF = deactivateTime;
        var time = deactivateTimeToMinutes(deactivateTime);

        prefs.setDisambleTimeIFF =
            DateTime.now().add(Duration(minutes: time)).toString();
      } else {
        prefs.setEnableIFF = true;
        var aid = Uuid().v4().toString();
        mainController.saveActivityLog(
            DateTime.now(), "Movimiento normal", aid);
        prefs.setDisambleIFF = "0 hora";
        prefs.setDisambleTimeIFF = "";
      }

      Future.sync(() => {
            showSaveAlert(context, "Tiempo guardado",
                "El tiempo en el que queda desactivado la aplicación se ha guardado correctamente")
          });
    } else {
      Future.sync(() => {
            showSaveAlert(
                context, Constant.info, Constant.disambleProtectedError)
          });
    }
    return true;
  }
}

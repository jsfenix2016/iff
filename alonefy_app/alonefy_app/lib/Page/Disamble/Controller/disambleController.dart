import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/Disamble/Service/deactivate_service.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:jiffy/jiffy.dart';

import '../../../Controllers/mainController.dart';

final _prefs = PreferenceUser();

class DisambleController extends GetxController {
  
  Future<void> saveDisamble(BuildContext context, String deactivateTime) async {
    _prefs.setDisambleIFF = deactivateTime;
    _prefs.setEnableIFF = false;

    await Jiffy.locale('es');
    var datetime = Jiffy(DateTime.now()).format(getDefaultPattern());
    _prefs.setStartDateTimeDisambleIFF = datetime;

    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();
    
    DeactivateService().saveData(user.telephone, deactivateTimeToMinutes(deactivateTime));
    
    showAlert(context, "Se a deshabilitado la protección");
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/FallDetected/Service/fallService.dart';
import 'package:ifeelefine/Page/TermsAndConditions/PageView/conditionGeneral_page.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Views/contact_page.dart';

import '../../../Controllers/mainController.dart';

final _prefs = PreferenceUser();

class FallDetectedController extends GetxController {
  Future<void> saveDetectedFall(BuildContext context, bool detectedfall) async {
    _prefs.setDetectedFall = detectedfall;

    showSaveAlert(context, Constant.info, Constant.saveCorrectly);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ContactList(
          isMenu: false,
        ),
      ),
    );
  }

  Future<void> setDetectedFall(bool detectedfall) async {
    _prefs.setDetectedFall = detectedfall;

    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    FallService().activateFall(user.telephone, detectedfall);
  }

  Future<void> setFallTime(String strFallTime) async {
    _prefs.setFallTime = strFallTime;

    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    var fallTime = stringTimeToInt(strFallTime);
    FallService().updateFallTime(user.telephone, fallTime);
  }
}

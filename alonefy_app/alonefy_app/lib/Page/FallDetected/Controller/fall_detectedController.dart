import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/TermsAndConditions/PageView/conditionGeneral_page.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

final _prefs = PreferenceUser();

class FallDetectedController extends GetxController {
  Future<void> saveDetectedFall(BuildContext context, bool detectedfall) async {
    _prefs.setDetectedFall = detectedfall;

    mostrarAlerta(context, "Se guardo correctamente");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConditionGeneralPage()),
    );
  }
}

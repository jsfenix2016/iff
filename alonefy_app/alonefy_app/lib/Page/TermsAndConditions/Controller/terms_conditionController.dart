import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Page/FinishConfig/Pageview/finishConfig_page.dart';

final _prefs = PreferenceUser();

class TermsAndConditionsController extends GetxController {
  late var validateEmail = false.obs;
  late var validateSms = false.obs;

  Future<void> saveConditions(
      BuildContext context, bool terms, bool sendSms) async {
    _prefs.setAceptedTerms = terms;
    _prefs.setAceptedSendSMS = sendSms;

    showAlert(context, "Se guardo correctamente");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FinishConfigPage()),
    );
  }
}

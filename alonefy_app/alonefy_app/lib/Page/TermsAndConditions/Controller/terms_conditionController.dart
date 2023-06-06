import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/ApiRest/TermsAndConditionsApi.dart';
import 'package:ifeelefine/Page/TermsAndConditions/Service/termsAndConditionsService.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Page/FinishConfig/Pageview/finishConfig_page.dart';

import '../../../Controllers/mainController.dart';

final _prefs = PreferenceUser();

class TermsAndConditionsController extends GetxController {
  late var validateEmail = false.obs;
  late var validateSms = false.obs;

  Future<void> saveConditions(
      BuildContext context, bool terms, bool sendSms) async {
    _prefs.setAceptedTerms = terms;
    _prefs.setAceptedSendSMS = sendSms;

    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();
    var termsAndConditionsApi = TermsAndConditionsApi(
      phoneNumber: user.telephone,
      smsCallAccepted: true
    );

    TermsAndConditionsService().saveData(termsAndConditionsApi);

    showAlert(context, "Se guardo correctamente");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FinishConfigPage()),
    );
  }
}

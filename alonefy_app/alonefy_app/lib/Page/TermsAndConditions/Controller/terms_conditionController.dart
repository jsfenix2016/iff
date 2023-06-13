import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
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
  late BuildContext contextTemp;
  Future<void> saveConditions(
      BuildContext context, bool terms, bool sendSms) async {
    contextTemp = context;
    _prefs.setAceptedTerms = terms;
    _prefs.setAceptedSendSMS = sendSms;

    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();
    var termsAndConditionsApi = TermsAndConditionsApi(
        phoneNumber: user.telephone.replaceAll("+34", ""), smsCallAccepted: true);

    var resp =
        await TermsAndConditionsService().saveData(termsAndConditionsApi);
    if (resp) {
      showAlertTemp(context, Constant.saveCorrectly);
      goTO();
    } else {
      showAlertTemp(context, Constant.errorGeneric);
    }
  }

  void goTO() {
    Navigator.push(
      contextTemp,
      MaterialPageRoute(builder: (context) => const FinishConfigPage()),
    );
  }

  void showAlertTemp(BuildContext context, String text) {
    showSaveAlert(context, Constant.info, Constant.deletectGeneric);
  }
}

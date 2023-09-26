import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

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
        phoneNumber: user.telephone.contains('+34')
            ? user.telephone.replaceAll("+34", "")
            : user.telephone,
        smsCallAccepted: true);

    var resp =
        await TermsAndConditionsService().saveData(termsAndConditionsApi);
    if (resp) {
      Future.sync(() => showAlertTemp(context, Constant.saveCorrectly));

      goTO();
    } else {
      Future.sync(() => showAlertTemp(context, Constant.errorGeneric));
    }
  }

  void goTO() {
    Get.offAll(() => const FinishConfigPage());
  }

  void showAlertTemp(BuildContext context, String text) {
    showSaveAlert(context, Constant.info, text);
  }
}

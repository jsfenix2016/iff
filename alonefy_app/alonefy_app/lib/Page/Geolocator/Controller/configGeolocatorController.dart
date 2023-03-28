import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Page/FinishConfig/Pageview/finishConfig_page.dart';

final _prefs = PreferenceUser();

class ConfigGeolocatorController extends GetxController {
  Future<void> saveSendLocation(BuildContext context, bool senLocation) async {
    _prefs.setAceptedSendLocation = senLocation;

    showAlert(context, "Se guardo correctamente");
  }
}

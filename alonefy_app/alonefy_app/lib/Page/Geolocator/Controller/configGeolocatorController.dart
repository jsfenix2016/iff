import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/Geolocator/Service/locationService.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Page/FinishConfig/Pageview/finishConfig_page.dart';

import '../../../Controllers/mainController.dart';

final _prefs = PreferenceUser();

class ConfigGeolocatorController extends GetxController {
  Future<void> activateLocation(
      PreferencePermission preferencePermission) async {
    _prefs.setAcceptedSendLocation = preferencePermission;

    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    LocationService().activateLocation(
        user.telephone.contains('+34')
            ? user.telephone.replaceAll("+34", "")
            : user.telephone,
        _prefs.getAcceptedSendLocation == PreferencePermission.allow);

    //showAlert(context, "Se guardó correctamente");
  }

  Future<void> sendLocation(String latitude, String longitude) async {
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    if (user.telephone != "") {
      LocationService().sendLocation(
          user.telephone.contains('+34')
              ? user.telephone.replaceAll("+34", "")
              : user.telephone,
          latitude,
          longitude);
    }
  }
}

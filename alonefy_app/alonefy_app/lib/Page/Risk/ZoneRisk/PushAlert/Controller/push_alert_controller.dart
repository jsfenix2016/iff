import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/ApiRest/ZoneRiskApi.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/Service/zone_risk_service.dart';

import '../../../../../Controllers/mainController.dart';

class PushAlertController extends GetxController {
  Future<List<String>> updateVideo(
      ContactZoneRiskBD contact, String path, String pathFront) async {
    if (path.isNotEmpty) {
      await GallerySaver.saveVideo(path);
      contact.video = await convertImageData(path);
    }
    if (pathFront.isNotEmpty) {
      await GallerySaver.saveVideo(pathFront);
      // contact.video = await convertImageData(pathFront);
    }
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    var taskIds = await ZoneRiskService()
        .createZoneRiskAlert(ZoneRiskApi.fromZoneRisk(contact, user.telephone));

    if (contact.save) {
      await const HiveDataRisk().updateContactZoneRisk(contact);

      var url = await ZoneRiskService().getVideoUrl(
          user.telephone.contains('+34')
              ? user.telephone.replaceAll("+34", "")
              : user.telephone,
          contact.id);

      if (url != null && url.isNotEmpty) {
        ZoneRiskService().updateVideo(url, contact.video);
      }
    }

    return taskIds;
  }

  Future<Uint8List> convertImageData(String pathv) async {
    Uint8List? bytes;

    var path = File(pathv);

    bytes = path.readAsBytesSync();

    return bytes;
  }
}

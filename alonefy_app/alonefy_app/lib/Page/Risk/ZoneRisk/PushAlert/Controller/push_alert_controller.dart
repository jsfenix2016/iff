import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/Service/zone_risk_service.dart';

import '../../../../../Controllers/mainController.dart';

class PushAlertController extends GetxController {
  Future<void> updateVideo(ContactZoneRiskBD contact, String path) async {
    await GallerySaver.saveVideo(path);
    contact.video = await convertImageData(path);

    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    var url = await ZoneRiskService().getVideoUrl(user.telephone, contact.id);

    if (url != null && url.isNotEmpty) {
      ZoneRiskService().updateVideo(url, contact.video);
    }

    await const HiveDataRisk().updateContactZoneRisk(contact);
  }

  Future<Uint8List> convertImageData(String pathv) async {
    Uint8List? bytes;

    var path = File(pathv);

    bytes = path.readAsBytesSync();

    return bytes;
  }
}

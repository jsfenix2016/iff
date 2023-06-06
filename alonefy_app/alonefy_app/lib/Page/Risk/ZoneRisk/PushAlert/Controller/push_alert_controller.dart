import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';

class PushAlertController extends GetxController {
  Future<void> updateVideo(ContactZoneRiskBD contact, String path) async {
    await GallerySaver.saveVideo(path);
    contact.video = await convertImageData(path);
    await const HiveDataRisk().updateContactZoneRisk(contact);
  }

  Future<Uint8List> convertImageData(String pathv) async {
    Uint8List? bytes;

    var path = File(pathv);

    bytes = path.readAsBytesSync();

    return bytes;
  }
}

import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Model/videopresignedbd.dart';
import 'package:ifeelefine/Page/Disamble/Controller/disambleController.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/Service/zone_risk_service.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/main.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../../Controllers/mainController.dart';
import '../../../../../Model/ApiRest/ZoneRiskApi.dart';

class EditZoneController extends GetxController {
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

  Future<bool> saveContactZoneRisk(
      BuildContext context, ContactZoneRiskBD contact) async {
    try {
      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      var con = ZoneRiskApi.fromZoneRisk(contact, user.telephone);
      var contactZoneRiskApi =
          await ZoneRiskService().createContactZoneRisk(con);
      if (contact.photo != null &&
          contactZoneRiskApi != null &&
          contactZoneRiskApi.awsUploadCustomContactPresignedUrl.isNotEmpty) {
        await ZoneRiskService().updateImage(
            contactZoneRiskApi.awsUploadCustomContactPresignedUrl,
            contact.photo);
      }
      if (contactZoneRiskApi != null) {
        contact.id = contactZoneRiskApi.id;
        await const HiveDataRisk().saveContactZoneRisk(contact);

        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> updateContactZoneRisk(
      BuildContext context, ContactZoneRiskBD contact) async {
    try {
      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      var con = ZoneRiskApi.fromZoneRisk(contact, user.telephone);

      con.createDate = contact.createDate;

      var zoneRiskApiResponse =
          await ZoneRiskService().updateZoneRisk(con, contact.id);

      if (contact.photo != null &&
          zoneRiskApiResponse != null &&
          zoneRiskApiResponse.awsUploadCustomContactPresignedUrl.isNotEmpty) {
        await ZoneRiskService().updateImage(
            zoneRiskApiResponse.awsUploadCustomContactPresignedUrl,
            contact.photo);
      }

      var save = await const HiveDataRisk().updateContactZoneRisk(contact);

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<void> saveFromApi(List<ZoneRiskApi> contactsZoneRiskApi) async {
    await inicializeHiveBD();
    for (var contactZoneRiskApi in contactsZoneRiskApi) {
      var bytes;

      List<VideoPresignedBD> listvideobd = [];
      if (contactZoneRiskApi.awsDownloadCustomContactPresignedUrl != null &&
          contactZoneRiskApi.awsDownloadCustomContactPresignedUrl.isNotEmpty) {
        bytes = await ZoneRiskService().getZoneRiskImage(
            contactZoneRiskApi.awsDownloadCustomContactPresignedUrl);
        print(bytes);
      }
      Uint8List? videoBytes;
      ContactZoneRiskBD contact = ContactZoneRiskBD(
          id: contactZoneRiskApi.id,
          photo: bytes,
          name: contactZoneRiskApi.name,
          phones: contactZoneRiskApi.customContactPhoneNumber,
          sendLocation: contactZoneRiskApi.sendlocation,
          sendWhatsapp: contactZoneRiskApi.notifyPredefinedContacts,
          code: "",
          isActived: true,
          sendWhatsappContact:
              contactZoneRiskApi.customContactWhatsappNotification,
          callme: contactZoneRiskApi.customContactVoiceNotification,
          save: true,
          createDate: contactZoneRiskApi.createDate,
          video: videoBytes,
          listVideosPresigned: listvideobd);
      await inicializeHiveBD();
      await const HiveDataRisk().saveContactZoneRisk(contact);

      if (contactZoneRiskApi.awsDownloadVideoPresignedUrls != null &&
          contactZoneRiskApi.awsDownloadVideoPresignedUrls.isNotEmpty) {
        final receivePort = ReceivePort();
        try {
          await Isolate.spawn(
            _backgroundTask,
            {
              'port': receivePort.sendPort,
              'ZoneRiskApi': contactZoneRiskApi,
            },
          );
        } on Object {
          receivePort.close();
          rethrow;
        }

        final jsonData = (await receivePort.first) as List<VideoPresignedBD>;

        if (jsonData.isNotEmpty) {
          print(jsonData);
          inicializeHiveBD();
          contact.listVideosPresigned = jsonData;
          await const HiveDataRisk().updateContactZoneRisk(contact);
          mainController.refreshHome();
        }
      }
    }
  }

  void _backgroundTask(dynamic message) async {
    final SendPort sendPort = message['port'];
    final ZoneRiskApi videoPresigned = message['ZoneRiskApi'];
    List<VideoPresignedBD> list = [];
    VideoPresignedBD tempPre =
        VideoPresignedBD(modified: '', url: '', videoDown: null);
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    try {
      for (var element in videoPresigned.awsDownloadVideoPresignedUrls) {
        tempPre = VideoPresignedBD(
            modified: element.modified,
            url: element.url,
            videoDown: await ZoneRiskService().getZoneRiskImage(element.url));
        list.add(tempPre);
      }

      Isolate.exit(sendPort, list);
    } catch (e) {
      sendPort.send('Error al guardar el video: $e');
    }
  }
}

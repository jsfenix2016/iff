import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_data.dart';

import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Page/Disamble/Controller/disambleController.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/Service/zone_risk_service.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import 'package:uuid/uuid.dart';

import '../../../../../Controllers/mainController.dart';
import '../../../../../Model/ApiRest/ZoneRiskApi.dart';

class EditZoneController extends GetxController {
  Future<void> saveActivityLog(ContactZoneRiskBD contact) async {
    var uuid = Uuid().v4();
    LogAlertsBD mov = LogAlertsBD(
        id: 0,
        type: "Zona de riesgo",
        time: DateTime.now(),
        video: contact.video,
        groupBy: uuid);
    MainController().saveUserRiskLog(mov);
    prefs.setIdZoneGroup = uuid;
    await const HiveData().saveUserPositionBD(mov);
  }

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
    for (var contactZoneRiskApi in contactsZoneRiskApi) {
      var bytes;
      if (contactZoneRiskApi.awsDownloadCustomContactPresignedUrl != null &&
          contactZoneRiskApi.awsDownloadCustomContactPresignedUrl.isNotEmpty) {
        bytes = await ZoneRiskService().getZoneRiskImage(
            contactZoneRiskApi.awsDownloadCustomContactPresignedUrl);
        print(bytes);
      }
      var videoBytes;
      if (contactZoneRiskApi.awsDownloadVideoPresignedUrls != null &&
          contactZoneRiskApi.awsDownloadVideoPresignedUrls.isNotEmpty) {
        videoBytes = await ZoneRiskService().getZoneRiskImage(
            contactZoneRiskApi.awsDownloadVideoPresignedUrls.first);
        print(videoBytes);
      }
      var contact = ContactZoneRiskBD(
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
          save: false,
          createDate: DateTime.now(),
          video: videoBytes);
      const HiveDataRisk().saveContactZoneRisk(contact);
    }
  }
}

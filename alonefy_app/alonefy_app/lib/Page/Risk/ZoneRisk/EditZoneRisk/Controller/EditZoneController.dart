import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/Service/zone_risk_service.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:notification_center/notification_center.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../Controllers/mainController.dart';
import '../../../../../Model/ApiRest/ZoneRiskApi.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

class EditZoneController extends GetxController {
  Future<List<Contact>> getContacts(BuildContext context) async {
    PermissionStatus permission = await Permission.contacts.request();

    if (permission.isPermanentlyDenied) {
      // ignore: use_build_context_synchronously
      showPermissionDialog(context, "Permitir acceder a los contactos");
      return [];
    } else if (permission.isDenied) {
      return [];
    } else {
      // Retrieve the list of contacts from the device
      var contacts = await FlutterContacts.getContacts();
      // Set the list of contacts in the state
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);

      return contacts;
    }
  }

  Future<void> saveActivityLog(ContactZoneRiskBD contact) async {
    LogAlertsBD mov = LogAlertsBD(
        id: 0,
        type: "Zona de riesgo",
        time: DateTime.now(),
        video: contact.photo);
    MainController().saveUserRiskLog(mov);
    //await const HiveData().saveUserPositionBD(mov);
  }

  Future<bool> saveContactZoneRisk(
      BuildContext context, ContactZoneRiskBD contact) async {
    try {
      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      var contactZoneRiskApi = await ZoneRiskService().createContactZoneRisk(
          ZoneRiskApi.fromZoneRisk(contact, user.telephone));
      if (contact.photo != null && contactZoneRiskApi != null
          && contactZoneRiskApi.awsUploadCustomContactPresignedUrl.isNotEmpty) {
        await ZoneRiskService().updateImage(contactZoneRiskApi.awsUploadCustomContactPresignedUrl, contact.photo);
      }
      if (contactZoneRiskApi != null) {
        contact.id = contactZoneRiskApi.id;
        await const HiveDataRisk().saveContactZoneRisk(contact);
        NotificationCenter().notify('getContactZoneRisk');

        showSaveAlert(context, Constant.info, Constant.saveCorrectly);
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
      var zoneRiskApiResponse = await ZoneRiskService().updateZoneRisk(ZoneRiskApi.fromZoneRisk(contact, user.telephone), contact.id);

      if (contact.photo != null && zoneRiskApiResponse != null
          && zoneRiskApiResponse.awsUploadCustomContactPresignedUrl.isNotEmpty) {
        await ZoneRiskService().updateImage(zoneRiskApiResponse.awsUploadCustomContactPresignedUrl, contact.photo);
      }

      var save = const HiveDataRisk().updateContactZoneRisk(contact);
      NotificationCenter().notify('getContactZoneRisk');

      showSaveAlert(context, Constant.info, Constant.changeGeneric);
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
      }
      var videoBytes;
      if (contactZoneRiskApi.awsDownloadVideoPresignedUrl != null &&
          contactZoneRiskApi.awsDownloadVideoPresignedUrl.isNotEmpty) {
        videoBytes = await ZoneRiskService().getZoneRiskImage(
            contactZoneRiskApi.awsDownloadVideoPresignedUrl);
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
          sendWhatsappContact: contactZoneRiskApi.customContactWhatsappNotification,
          callme: contactZoneRiskApi.customContactVoiceNotification,
          save: false,
          createDate: DateTime.now(),
          video: videoBytes);
        const HiveDataRisk().saveContactZoneRisk(contact);
    }
  }
}

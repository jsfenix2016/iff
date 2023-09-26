import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Service/contactRiskService.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:notification_center/notification_center.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../Common/utils.dart';
import '../../../../Controllers/mainController.dart';
import '../../../../Model/ApiRest/ContactRiskApi.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

class EditRiskController extends GetxController {
  Future<void> saveActivityLog(ContactRiskBD contact) async {
    LogAlertsBD mov = LogAlertsBD(
        id: 0,
        type: "Cita de riesgo",
        time: DateTime.now(),
        photoDate: contact.photoDate);
    await const HiveData().saveUserPositionBD(mov);
  }

  Future<bool> saveContactRisk(
      BuildContext context, ContactRiskBD contact) async {
    try {
      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      var contactRiskApi = ContactRiskApi.fromContact(
          contact,
          user.telephone.contains("+34")
              ? user.telephone.replaceAll("+34", "")
              : user.telephone,
          contact.photoDate.length);
      var contactRiskApiResponse =
          await ContactRiskService().createContactRisk(contactRiskApi);
      if (contact.photo != null &&
          contactRiskApiResponse != null &&
          contactRiskApiResponse
              .awsUploadCustomContactPresignedUrl.isNotEmpty) {
        await ContactRiskService().updateImage(
            contactRiskApiResponse.awsUploadCustomContactPresignedUrl,
            contact.photo);
      }
      if (contact.photoDate.isNotEmpty &&
          contactRiskApiResponse != null &&
          contactRiskApiResponse.awsUploadPresignedUrls != null &&
          contactRiskApiResponse.awsUploadPresignedUrls!.isNotEmpty) {
        var index = 0;
        for (var url in contactRiskApiResponse.awsUploadPresignedUrls!) {
          await ContactRiskService().updateImage(url, contact.photoDate[index]);
          index++;
        }
      }
      if (contactRiskApiResponse != null) {
        contact.id = contactRiskApiResponse.id;
        final save = await const HiveDataRisk().saveContactRisk(contact);
        if (save) {
          saveActivityLog(contact);
          // NotificationCenter().notify('getContactRisk');
          RiskController riskVC = Get.find<RiskController>();
          riskVC.update();

          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateContactRisk(
      BuildContext context, ContactRiskBD contact) async {
    try {
      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      var contactRiskApi = await ContactRiskService().updateContactRisk(
          ContactRiskApi.fromContact(
              contact,
              user.telephone.contains('+34')
                  ? user.telephone.replaceAll("+34", "")
                  : user.telephone,
              contact.photoDate.length),
          contact.id);

      if (contact.photoDate.isNotEmpty &&
          contactRiskApi != null &&
          contactRiskApi.awsUploadPresignedUrls != null &&
          contactRiskApi.awsUploadPresignedUrls!.isNotEmpty) {
        var index = 0;
        for (var url in contactRiskApi.awsUploadPresignedUrls!) {
          await ContactRiskService().updateImage(url, contact.photoDate[index]);
          index++;
        }
      }

      var update = await const HiveDataRisk().updateContactRisk(contact);
      if (update) {
        // NotificationCenter().notify('getContactRisk');

        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<void> updateContactRiskWhenDateStarted(int id) async {
    await inicializeHiveBD();
    var contactRisk = await const HiveDataRisk().getContactRiskBD(id);

    if (contactRisk != null) {
      contactRisk.isActived = true;
      contactRisk.isprogrammed = false;

      await const HiveDataRisk().updateContactRisk(contactRisk);

      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      ContactRiskService().updateContactRisk(
          ContactRiskApi.fromContact(
              contactRisk,
              user.telephone.contains('+34')
                  ? user.telephone.replaceAll("+34", "")
                  : user.telephone,
              contactRisk.photoDate.length),
          contactRisk.id);

      NotificationCenter().notify('getContactRisk');
    }
  }

  Future<void> updateContactRiskWhenDateFinished(
      int id, Map<String, dynamic> data) async {
    var contactRisk = await const HiveDataRisk().getContactRiskBD(id);

    if (contactRisk != null) {
      contactRisk.isActived = true;
      contactRisk.isprogrammed = false;
      contactRisk.isFinishTime = true;
      contactRisk.taskIds = getTaskIdList(data['task_ids'].toString());
      await const HiveDataRisk().updateContactRisk(contactRisk);

      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      ContactRiskService().updateContactRisk(
          ContactRiskApi.fromContact(
              contactRisk,
              user.telephone.contains('+34')
                  ? user.telephone.replaceAll("+34", "")
                  : user.telephone,
              contactRisk.photoDate.length),
          contactRisk.id);

      NotificationCenter().notify('getContactRisk');
    }
  }

  Future<void> saveFromApi(List<ContactRiskApi> contactsRiskApi) async {
    for (var contactRiskApi in contactsRiskApi) {
      var bytes;
      if (contactRiskApi.awsDownloadCustomContactPresignedUrl != null &&
          contactRiskApi.awsDownloadCustomContactPresignedUrl.isNotEmpty) {
        bytes = await ContactRiskService().getContactImage(
            contactRiskApi.awsDownloadCustomContactPresignedUrl);
      }
      List<Uint8List> photoDate = [];
      if (contactRiskApi.awsDownloadPresignedUrls != null &&
          contactRiskApi.awsDownloadPresignedUrls!.isNotEmpty) {
        for (var photo in contactRiskApi.awsDownloadPresignedUrls!) {
          var photoBytes = await ContactRiskService().getContactImage(photo);
          if (photoBytes != null) photoDate.add(photoBytes);
        }
      }
      var contact = ContactRiskBD(
          id: contactRiskApi.id,
          photo: bytes,
          name: contactRiskApi.name,
          timeinit: contactRiskApi.startDateTime.toString().replaceAll("Z", ""),
          timefinish: contactRiskApi.endDateTime.toString().replaceAll("Z", ""),
          phones: contactRiskApi.customContactPhoneNumber,
          titleMessage: contactRiskApi.titleAlertMessage,
          messages: contactRiskApi.alertMessage,
          sendLocation: contactRiskApi.sendLocation,
          sendWhatsapp: contactRiskApi.notifyPredefinedContacts,
          isInitTime: false,
          isFinishTime: false,
          code: "",
          isActived: false,
          isprogrammed: false,
          photoDate: photoDate,
          saveContact: true,
          createDate: DateTime.now(),
          taskIds: []);
      await const HiveDataRisk().saveContactRisk(contact);
    }
  }

  Future<bool> updateNewContactRisk(
      BuildContext context, ContactRiskBD contact) async {
    try {
      // Map info
      await const HiveDataRisk().deleteDate(contact);
      Future.sync(() => ContactRiskService().deleteContactsRisk(contact.id));

      saveContactRisk(context, contact);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteContactRisk(
      BuildContext context, ContactRiskBD contact) async {
    try {
      // Map info
      await const HiveDataRisk().deleteDate(contact);
      await ContactRiskService().deleteContactsRisk(contact.id);
      return true;
    } catch (error) {
      return false;
    }
  }
}

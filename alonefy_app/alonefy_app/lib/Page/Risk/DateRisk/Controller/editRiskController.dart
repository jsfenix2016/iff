import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Service/contactRiskService.dart';
import 'package:ifeelefine/Model/logActivityBd.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:notification_center/notification_center.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../Controllers/mainController.dart';
import '../../../../Model/ApiRest/ContactRiskApi.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

class EditRiskController extends GetxController {
  Future<List<Contact>> getContacts(BuildContext context) async {
    PermissionStatus permission = await Permission.contacts.request();

    if (permission.isPermanentlyDenied) {
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
      // var contactRiskApi = await ContactRiskService().createContactRisk(
      //     ContactRiskApi.fromContact(contact, user.telephone));
      // if (contact.photo != null) {
      //   await ContactRiskService()
      //       .updateImage(user.telephone, contact.id, contact.photo!);
      // }
      // if (contactRiskApi != null) {
      // contact.id = contactRiskApi.id;
      final save = await const HiveDataRisk().saveContactRisk(contact);
      if (save == 0) {
        saveActivityLog(contact);
        NotificationCenter().notify('getContactRisk');

        showSaveAlert(context, Constant.info, Constant.saveCorrectly.tr);
        return true;
      } else {
        return false;
      }
      // } else {
      //   return false;
      // }
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateContactRisk(
      BuildContext context, ContactRiskBD contact) async {
    try {
      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      ContactRiskService().updateContactRisk(
          ContactRiskApi.fromContact(contact, user.telephone), contact.id);
      var update = await const HiveDataRisk().updateContactRisk(contact);
      if (update) {
        NotificationCenter().notify('getContactRisk');

        showSaveAlert(context, Constant.info, Constant.changeGeneric.tr);
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<void> updateContactRiskWhenDateStarted(String phones) async {
    var contactRisk = await const HiveDataRisk().getContactRiskBD(phones);

    if (contactRisk != null) {
      contactRisk.isActived = true;
      contactRisk.isprogrammed = false;
      await const HiveDataRisk().updateContactRisk(contactRisk);

      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      ContactRiskService().updateContactRisk(
          ContactRiskApi.fromContact(contactRisk, user.telephone),
          contactRisk.id);

      NotificationCenter().notify('getContactRisk');
    }
  }

  Future<void> updateContactRiskWhenDateFinished(String phones) async {
    var contactRisk = await const HiveDataRisk().getContactRiskBD(phones);

    if (contactRisk != null) {
      contactRisk.isActived = true;
      contactRisk.isprogrammed = false;
      contactRisk.isFinishTime = true;
      await const HiveDataRisk().updateContactRisk(contactRisk);

      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      ContactRiskService().updateContactRisk(
          ContactRiskApi.fromContact(contactRisk, user.telephone),
          contactRisk.id);

      NotificationCenter().notify('getContactRisk');
    }
  }

  Future<void> saveFromApi(List<ContactRiskApi> contactsRiskApi) async {
    for (var contactRiskApi in contactsRiskApi) {
      if (contactRiskApi.photo != null && contactRiskApi.photo.isNotEmpty) {
        var bytes =
            await ContactRiskService().getContactImage(contactRiskApi.photo);
        var contact = ContactRiskBD(
            id: contactRiskApi.id,
            photo: bytes,
            name: contactRiskApi.name,
            timeinit: contactRiskApi.timeinit.toString(),
            timefinish: contactRiskApi.timefinish.toString(),
            phones: contactRiskApi.phones,
            titleMessage: contactRiskApi.titlemessage,
            messages: contactRiskApi.messages,
            sendLocation: contactRiskApi.sendlocation,
            sendWhatsapp: contactRiskApi.sendwhatsapp,
            isInitTime: contactRiskApi.isinittime,
            isFinishTime: contactRiskApi.isfinishtime,
            code: contactRiskApi.code,
            isActived: contactRiskApi.isactived,
            isprogrammed: contactRiskApi.isprogrammed,
            photoDate: [],
            saveContact: contactRiskApi.savecontact,
            createDate: DateTime.now());
        const HiveDataRisk().saveContactRisk(contact);
      }
    }
  }
}

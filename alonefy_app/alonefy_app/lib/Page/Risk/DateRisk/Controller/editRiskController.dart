import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/logActivityBd.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:notification_center/notification_center.dart';
import 'package:permission_handler/permission_handler.dart';

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
        type: "Cita de riesgo",
        time: DateTime.now(),
        photoDate: contact.photoDate);
    await const HiveData().saveUserPositionBD(mov);
  }

  Future<bool> saveContactRisk(
      BuildContext context, ContactRiskBD contact) async {
    try {
      final save = await const HiveDataRisk().saveContactRisk(contact);
      if (save == 0) {
        saveActivityLog(contact);
        NotificationCenter().notify('getContactRisk');
        showAlert(context, "Contacto guardado correctamente".tr);
        return true;
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
      var update = await const HiveDataRisk().updateContactRisk(contact);
      if (update) {
        NotificationCenter().notify('getContactRisk');
        showAlert(context, "Contacto actualizado correctamente".tr);
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }
}

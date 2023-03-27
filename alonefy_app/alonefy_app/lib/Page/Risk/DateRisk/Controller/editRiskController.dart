import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:notification_center/notification_center.dart';
import 'package:permission_handler/permission_handler.dart';

class EditRiskController extends GetxController {
  Future<List<Contact>> getContacts(BuildContext context) async {
    PermissionStatus permission = await Permission.contacts.request();

    if (permission.isPermanentlyDenied) {
      showPermissionDialog(context);
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

  Future<bool> saveContactRisk(
      BuildContext context, ContactRiskBD contact) async {
    try {
      var save = const HiveDataRisk().saveContactRisk(contact);
      NotificationCenter().notify('getContactRisk');
      mostrarAlerta(context, "Contacto guardado correctamente".tr);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateContactRisk(
      BuildContext context, ContactRiskBD contact) async {
    try {
      var update = const HiveDataRisk().updateContactRisk(contact);
      NotificationCenter().notify('getContactRisk');
      mostrarAlerta(context, "Contacto actualizado correctamente".tr);
      return true;
    } catch (error) {
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:notification_center/notification_center.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<bool> saveContactZoneRisk(
      BuildContext context, ContactZoneRiskBD contact) async {
    try {
      // Map info
      var save = const HiveDataRisk().saveContactZoneRisk(contact);
      NotificationCenter().notify('getContactZoneRisk');
      showAlert(context, "Contacto guardado correctamente".tr);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> updateContactZoneRisk(
      BuildContext context, ContactZoneRiskBD contact) async {
    try {
      // Map info
      var save = const HiveDataRisk().updateContactZoneRisk(contact);
      NotificationCenter().notify('getContactZoneRisk');
      showAlert(context, "Contacto actualizado correctamente".tr);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}

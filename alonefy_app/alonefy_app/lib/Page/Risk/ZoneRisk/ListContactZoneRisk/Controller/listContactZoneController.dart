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

class ListContactZoneController extends GetxController {
  Future<List<ContactZoneRiskBD>> getContactsZoneRisk() async {
    try {
      var resp = await const HiveDataRisk().getcontactZoneRiskbd;

      return resp;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<bool> deleteContactRisk(
      BuildContext context, ContactZoneRiskBD contact) async {
    try {
      // Map info
      var delete = await const HiveDataRisk().deleteContactZone(contact);
      showAlert(context, "Contacto eliminado correctamente".tr);
      NotificationCenter().notify('getContactZoneRisk');
      return true;
    } catch (error) {
      return false;
    }
  }
}

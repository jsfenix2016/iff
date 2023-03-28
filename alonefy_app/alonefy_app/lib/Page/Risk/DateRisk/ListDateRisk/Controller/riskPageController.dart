import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';

class RiskController extends GetxController {
  Future<List<ContactRiskBD>> getContactsRisk() async {
    try {
      var save = await const HiveDataRisk().getcontactRiskbd;

      return save;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<bool> deleteContactRisk(
      BuildContext context, ContactRiskBD contact) async {
    try {
      // Map info
      var delete = await const HiveDataRisk().deleteDate(contact);
      showAlert(context, "Contacto guardado correctamente".tr);
      return true;
    } catch (error) {
      return false;
    }
  }
}

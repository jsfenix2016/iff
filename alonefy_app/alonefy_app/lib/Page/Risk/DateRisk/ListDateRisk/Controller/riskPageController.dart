import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Service/contactRiskService.dart';

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
      await ContactRiskService().deleteContactsRisk(contact.id);
      // showAlert(context, "Contacto guardado correctamente".tr);
      showSaveAlert(context, Constant.info, Constant.saveCorrectly.tr);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<Uint8List?> getContactRiskImage(String url) async {
    return await ContactRiskService().getContactImage(url);
  }
}

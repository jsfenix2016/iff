import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Service/contactRiskService.dart';

class RiskController extends GetxController {
  RxList<ContactRiskBD> contactList = <ContactRiskBD>[].obs;
  Future<RxList<ContactRiskBD>> getContactsRisk() async {
    try {
      contactList.value = await const HiveDataRisk().getcontactRiskbd;

      return contactList;
    } catch (error) {
      return contactList;
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

  Future<Uint8List?> getContactRiskImage(String url) async {
    return await ContactRiskService().getContactImage(url);
  }
}

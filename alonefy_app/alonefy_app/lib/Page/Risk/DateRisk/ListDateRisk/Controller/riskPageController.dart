import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Service/contactRiskService.dart';

class RiskController extends GetxController {
  RxList<ContactRiskBD> contactList = <ContactRiskBD>[].obs;
  Future<RxList<ContactRiskBD>> getContactsRisk() async {
    try {
      contactList.value = await const HiveDataRisk().getcontactRiskbd;

      contactList.sort((a, b) {
        if (a.createDate.hour != b.createDate.hour) {
          return b.createDate.hour.compareTo(a.createDate.hour);
        } else {
          return b.createDate.minute.compareTo(a.createDate.minute);
        }
      });

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

  void uptadeStatusDate() async {
    var list = await const HiveDataRisk().getcontactRiskbd;

    int indexSelect = list.indexWhere((item) =>
        item.isActived == true &&
        parseContactRiskDate(item.timefinish).isBefore(DateTime.now()));
    print(list);
    if (indexSelect != -1) {
      var temp = list[indexSelect];
      print(temp.isFinishTime);
      var c = await const HiveDataRisk().getContactRiskBD(temp.id);
      c!.isFinishTime = true;
      c.isprogrammed = false;
      c.isActived = false;
      var ct = await const HiveDataRisk().updateContactRisk(c);
    }

    int indexActive = list.indexWhere((item) =>
        item.isprogrammed == true &&
        parseContactRiskDate(item.timeinit).isBefore(DateTime.now()));

    if (indexActive != -1) {
      var temp = list[indexActive];
      print(temp.isFinishTime);
      var c = await const HiveDataRisk().getContactRiskBD(temp.id);
      c!.isFinishTime = false;
      c.isActived = true;
      c.isprogrammed = false;
      var ct = await const HiveDataRisk().updateContactRisk(c);
    }
  }
}

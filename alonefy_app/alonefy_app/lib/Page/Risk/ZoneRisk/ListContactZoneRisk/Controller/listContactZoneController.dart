import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/Service/zone_risk_service.dart';
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
      await ZoneRiskService().deleteZoneRisk(contact.id);

      showSaveAlert(context, Constant.info, Constant.deletectGeneric);
      NotificationCenter().notify('getContactZoneRisk');
      return true;
    } catch (error) {
      return false;
    }
  }
}

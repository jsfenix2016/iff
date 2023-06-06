import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/Service/zone_risk_service.dart';
import 'package:notification_center/notification_center.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../Controllers/mainController.dart';
import '../../../../../Model/ApiRest/ZoneRiskApi.dart';

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
      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      var contactZoneRiskApi = await ZoneRiskService().createContactZoneRisk(ZoneRiskApi.fromZoneRisk(contact, user.telephone));
      if (contact.photo != null) {
        await ZoneRiskService().updateImage(user.telephone, contact.id, contact.photo!);
      }
      if (contactZoneRiskApi != null) {
        contact.id = contactZoneRiskApi.id;
        var save = const HiveDataRisk().saveContactZoneRisk(contact);
        NotificationCenter().notify('getContactZoneRisk');
        showAlert(context, "Contacto guardado correctamente".tr);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> updateContactZoneRisk(
      BuildContext context, ContactZoneRiskBD contact) async {
    try {
      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      ZoneRiskService().updateZoneRisk(ZoneRiskApi.fromZoneRisk(contact, user.telephone), contact.id);
      var save = const HiveDataRisk().updateContactZoneRisk(contact);
      NotificationCenter().notify('getContactZoneRisk');
      showAlert(context, "Contacto actualizado correctamente".tr);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<void> saveFromApi(List<ZoneRiskApi> contactsZoneRiskApi) async {
    for (var contactZoneRiskApi in contactsZoneRiskApi) {
      if (contactZoneRiskApi.photo != null && contactZoneRiskApi.photo.isNotEmpty) {
        var bytes = await ZoneRiskService().getZoneRiskImage(contactZoneRiskApi.photo);
        var contact = ContactZoneRiskBD(
            id: contactZoneRiskApi.id,
            photo: bytes,
            name: contactZoneRiskApi.name,
            phones: contactZoneRiskApi.phones,
            sendLocation: contactZoneRiskApi.sendlocation,
            sendWhatsapp: contactZoneRiskApi.sendwhatsapp,
            code: contactZoneRiskApi.code,
            isActived: contactZoneRiskApi.isactived,
            sendWhatsappContact: contactZoneRiskApi.sendwhatsappcontact,
            callme: contactZoneRiskApi.callme,
            save: contactZoneRiskApi.save
        );
        const HiveDataRisk().saveContactZoneRisk(contact);
      }
    }
  }
}

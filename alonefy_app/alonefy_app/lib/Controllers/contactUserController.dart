import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Page/Contact/Service/contactService.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactUserController extends GetxController {
  final ContactService contactServ = Get.put(ContactService());

  Future<bool> authoritationContact(BuildContext context) async {
    try {
      // Map info
      await Future.delayed(const Duration(seconds: 5));
      showAlert(context, "Ususario o password incorrecto".tr);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> saveListContact(BuildContext context, List<Contact> listContact,
      String timeSendSMS, String timeCall) async {
    try {
      var contactBD = ContactBD(0, "", null, "", "", "", '', "pendiente");
      for (var element in listContact) {
        contactBD.displayName = element.displayName;
        contactBD.phones = element.phones.first.number;
        contactBD.photo = element.photo;
        contactBD.timeSendSMS = timeSendSMS;
        contactBD.timeCall = timeCall;

        var save = const HiveData().saveUserContact(contactBD);
        contactServ.saveContact(contactBD);
      }
      // Map info

      showAlert(context, "Contacto guardado correctamente".tr);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}

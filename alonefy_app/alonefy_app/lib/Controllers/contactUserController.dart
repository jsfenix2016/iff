import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';

class ContactUserController extends GetxController {
  Future<bool> authoritationContact(BuildContext context) async {
    try {
      // Map info
      await Future.delayed(const Duration(seconds: 5));
      mostrarAlerta(context, "Ususario o password incorrecto".tr);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> saveListContact(BuildContext context, List<Contact> listContact,
      String timeSendSMS, String timeCall) async {
    try {
      var contactBD = ContactBD(0, "", null, null, "", "", "", '');
      for (var i = 0; i <= listContact.length; i++) {
        var name = listContact[i].displayName;
        contactBD.displayName = listContact[i].displayName;
        contactBD.phones = listContact[i].phones.first.number;
        contactBD.photo = listContact[i].thumbnail;
        contactBD.timeSendSMS = timeSendSMS;
        contactBD.timeCall = timeCall;
        var save = const HiveData().saveUserContact(contactBD);
      }
      // Map info
      await Future.delayed(const Duration(seconds: 5));
      mostrarAlerta(context, "Ususario o password incorrecto".tr);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}

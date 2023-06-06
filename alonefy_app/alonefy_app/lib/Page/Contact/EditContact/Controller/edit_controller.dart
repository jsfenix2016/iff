import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Controllers/mainController.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/ApiRest/ContactApi.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Page/Contact/Service/contactService.dart';

class EditContactController extends GetxController {
  final ContactService contactServ = Get.put(ContactService());
  late BuildContext contextTemp;
  Future<bool> authoritationContact(BuildContext context) async {
    try {
      // Map info
      contextTemp = context;
      await Future.delayed(const Duration(seconds: 2));
      showAlertController("Se ha realizado la solicitud correctamente");
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> saveContact(BuildContext context, ContactBD contact,
      String timeSendSMS, String timeCall, String timeWhatsapp) async {
    contextTemp = context;
    try {
      var save = await const HiveData().saveUserContact(contact);
      if (save == 1) {
        final MainController mainController = Get.put(MainController());
        var user = await mainController.getUserData();
        contactServ.saveContact(convertToApi(contact, user.telephone));

        showAlertController(
            "Contacto guardado correctamente, se ha realizado la solicitud de autorización correctamente");
        return true;
      } else {
        showAlertController(Constant.conexionFail);

        return false;
      }
    } catch (error) {
      showAlertController(Constant.conexionFail);
      return false;
    }
  }

  void showAlertController(String text) {
    showAlert(contextTemp, text.tr);
  }

  Future<void> updateContacts(
      List<ContactBD> contacts, emailTime, phoneTime, smsTime) async {
    for (var contact in contacts) {
      contact.timeSendSMS = emailTime;
      contact.timeCall = phoneTime;
      contact.timeWhatsapp = smsTime;

      const HiveData().updateContact(contact);

      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      ContactApi contactApi = convertToApi(contact, user.telephone);

      contactServ.updateContact(contactApi);
    }
  }

  ContactApi convertToApi(ContactBD contactBD, String phoneNumber) {
    //var contactAPI = ContactApi(
    //    userPhoneNumber: phoneNumber,
    //    phoneNumber: contactBD.phones,
    //    name: contactBD.name,
    //    displayName: contactBD.displayName,
    //    timeSendSms: stringTimeToInt(contactBD.timeSendSMS),
    //    timeCall: stringTimeToInt(contactBD.timeCall),
    //    timeWhatsapp: stringTimeToInt(contactBD.timeWhatsapp)
    //);

    var contactApi = ContactApi.fromContact(contactBD, phoneNumber);

    return contactApi;
  }
}

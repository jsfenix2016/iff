import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/ApiRest/ContactApi.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Page/Contact/Service/contactService.dart';
import 'mainController.dart';

class ContactUserController extends GetxController {
  final ContactService contactServ = Get.put(ContactService());
  late BuildContext contextTemp;
  Future<bool> authoritationContact(BuildContext context) async {
    contextTemp = context;
    try {
      // Map info
      await Future.delayed(const Duration(seconds: 2));

      showAlertTemp("Se ha realizado la solicitud correctamente");

      return true;
    } catch (error) {
      showAlertTemp(Constant.conexionFail);
      return false;
    }
  }

  Future<bool> saveListContact(BuildContext context, List<Contact> listContact,
      String timeSendSMS, String timeCall, String timeWhatsapp) async {
    contextTemp = context;
    try {
      var contactBD = ContactBD("", null, "", "", "", "", "", "Pendiente");

      for (var element in listContact) {
        contactBD.displayName = element.displayName;
        contactBD.phones = element.phones.first.number.replaceAll("+34", "");
        contactBD.photo = element.photo;
        contactBD.timeSendSMS = timeSendSMS;
        contactBD.timeCall = timeCall;
        contactBD.timeWhatsapp = timeWhatsapp;

        bool save = await const HiveData().saveUserContact(contactBD);
        if (save) {
          final MainController mainController = Get.put(MainController());
          var user = await mainController.getUserData();
          await contactServ
              .saveContact(convertToApi(contactBD, user.telephone));
          if (contactBD.photo != null) {
            contactServ.updateImage(user.telephone.replaceAll("+34", ""),
                contactBD.phones.replaceAll("+34", ""), contactBD.photo!);
          }
        }
      }
      // Map info

      showAlertTemp(
          "Contacto guardado correctamente, se ha realizado la solicitud de autorización correctamente");
      return true;
    } catch (error) {
      showAlertTemp(Constant.conexionFail);

      return false;
    }
  }

  void showAlertTemp(String text) {
    showSaveAlert(contextTemp, Constant.info, text);
  }

  Future<void> updateContacts(
      List<ContactBD> contacts, emailTime, phoneTime, smsTime) async {
    for (var contact in contacts) {
      contact.timeSendSMS = emailTime;
      contact.timeCall = phoneTime;
      contact.timeWhatsapp = smsTime;

      await const HiveData().updateContact(contact);

      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      ContactApi contactApi = convertToApi(contact, user.telephone);

      contactServ.updateContact(contactApi);
    }
  }

  Future<void> updateContactStatus(String phones, String status) async {
    var contact = await const HiveData().getContactBD(phones);

    if (contact != null) {
      contact.requestStatus = status;
      await const HiveData().updateContact(contact);
    }
  }

  //Future<void> updateContacts(BuildContext context, List<Contact> contacts, String timeSendSMS,
  //    String timeCall, String timeWhatsapp) async {
  //  var contactBD = ContactBD("", null, "", "", "", "", "", "pendiente");
//
  //  for (var element in contacts) {
  //    contactBD.displayName = element.displayName;
  //    contactBD.phones = element.phones.first.number;
  //    contactBD.photo = element.photo;
  //    contactBD.timeSendSMS = timeSendSMS;
  //    contactBD.timeCall = timeCall;
  //    contactBD.timeWhatsapp = timeWhatsapp;
//
  //    const HiveData().updateContact(contactBD);
//
  //    final MainController mainController = Get.put(MainController());
  //    var user = await mainController.getUserData();
  //    ContactApi contactApi = convertToApi(contactBD, user.telephone);
//
  //    contactServ.updateContact(contactApi);
  //  }
//
  //  showAlert(context, "Contacto guardado correctamente".tr);
  //}

  Future<void> saveFromApi(List<ContactApi> contactsApi) async {
    for (var contactApi in contactsApi) {
      if (contactApi.photo != null && contactApi.photo.isNotEmpty) {
        var bytes = await contactServ.getContactImage(contactApi.photo);
        var contact = ContactBD(
            contactApi.displayName,
            bytes,
            contactApi.name,
            minutesToString(contactApi.timeSendSms),
            minutesToString(contactApi.timeCall),
            minutesToString(contactApi.timeWhatsapp),
            contactApi.phoneNumber,
            contactApi.status);
        const HiveData().saveUserContact(contact);
      }
    }
  }

  ContactApi convertToApi(ContactBD contactBD, String phoneNumber) {
    var contactApi = ContactApi.fromContact(contactBD, phoneNumber);

    return contactApi;
  }

  Future<bool> deleteContact(ContactBD contact) async {
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    var response =
        await contactServ.deleteContact(user.telephone, contact.phones);

    return response;
  }

  //Future<bool> updateContactStatus(ContactBD contact) async {
  //  final MainController mainController = Get.put(MainController());
  //  var user = await mainController.getUserData();
//
  //  var response =
  //      await contactServ.updateContactStatus(user.telephone, contact.phones);
//
  //  return response;
  //}

  Future<List<ContactBD>> getContacts() async {
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    var contactApiList = await contactServ.getContact(user.telephone);

    if (contactApiList != null) {
      return _convertToContactBD(contactApiList);
    }

    return [];
  }

  List<ContactBD> _convertToContactBD(List<ContactApi> contactApiList) {
    List<ContactBD> contacts = [];

    for (var contactApi in contactApiList) {
      var contact = ContactBD(
          contactApi.displayName,
          stringToUint8List(contactApi.photo),
          contactApi.name,
          minutesToString(contactApi.timeSendSms),
          minutesToString(contactApi.timeCall),
          minutesToString(contactApi.timeWhatsapp),
          contactApi.phoneNumber,
          contactApi.status);

      contacts.add(contact);
    }

    return contacts;
  }
}

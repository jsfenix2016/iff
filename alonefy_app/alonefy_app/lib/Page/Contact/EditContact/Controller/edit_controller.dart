import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
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

  Future<bool> saveContact(BuildContext context, ContactBD contact) async {
    contextTemp = context;
    try {
      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      var response =
          await contactServ.saveContact(convertToApi(contact, user.telephone));

      if (response) {
        var contactBD = await const HiveData().getContactBD(contact.phones);
        if (contactBD == null) {
          var url = await contactServ.getUrlPhoto(
              user.telephone.contains('+34')
                  ? user.telephone.replaceAll("+34", "")
                  : user.telephone,
              user.telephone.contains('+34')
                  ? contact.phones.replaceAll("+34", "")
                  : contact.phones);
          if (contact.photo != null && url != null) {
            contactServ.updateImage(url, contact.photo!);
          }
          await const HiveData().saveUserContact(contact);
          showAlertController(Constant.contactSaveCorrectly);
        } else {
          await const HiveData().updateContact(contact);
          showAlertController(Constant.contactEditCorrectly);
        }
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
    showSaveAlert(contextTemp, Constant.info, text.tr);
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

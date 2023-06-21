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
      var save = await const HiveData().saveUserContact(contact);
      if (save) {
        final MainController mainController = Get.put(MainController());
        var user = await mainController.getUserData();

        bool ok = await contactServ
            .saveContact(convertToApi(contact, user.telephone));
        if (ok) {
          showAlertController(Constant.contactSaveCorrectly);
          return true;
        } else {
          return false;
        }
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
    return ContactApi.fromContact(contactBD, phoneNumber);
  }
}

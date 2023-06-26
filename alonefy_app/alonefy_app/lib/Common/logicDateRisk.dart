import 'dart:async';

import 'package:ifeelefine/Common/idleLogic.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LogicDateRisk {
  //Future getDateRisk() async {
  //  await inicializeHiveBD();
//
  //  var user = await const HiveData().getuserbd;
//
  //  final Box<ContactRiskBD> box =
  //      await Hive.openBox<ContactRiskBD>('contactriskbd');
//
  //  List<ContactRiskBD> dateRisk = box.values.toList();
//
  //  if (dateRisk.isEmpty) {
  //    return;
  //  }
  //  for (var element in dateRisk) {
  //    DateTime start = parseDurationRow(element.timeinit);
  //    DateTime end = parseDurationRow(element.timefinish);
//
  //    RedirectViewNotifier.contactRisk = element;
  //    if (now.hour.compareTo(start.hour) == 0 &&
  //        now.minute.compareTo(start.minute) >= 0) {
  //      if (element.isActived == false && element.isFinishTime == false) {
  //        element.isActived = true;
  //        element.isprogrammed = false;
  //        await const HiveDataRisk().updateContactRisk(element);
  //        //RedirectViewNotifier.showDateNotifications();
  //      }
//
  //      return;
  //    } else {
  //      print(
  //          "ahora: ${now.hour}:${now.minute}, hora fin: ${end.hour}:${end.minute},isActived: ${element.isActived}");
  //      if ((now.hour.compareTo(end.hour) == 0 &&
  //              now.minute.compareTo(end.minute) >= 0) &&
  //          element.isActived) {
  //        if (element.isActived && element.isFinishTime == false) {
  //          element.isActived = true;
  //          element.isprogrammed = false;
  //          element.isFinishTime = true;
  //          await const HiveDataRisk().updateContactRisk(element);
  //          sendMessageContactDate(element);
  //        }
  //      }
  //    }
  //  }
  //}

  void sendMessageContactDate(ContactRiskBD contact) async {
    Duration useMobil = await IdleLogic().convertStringToDuration("5 min");
    timerSendSMS = Timer(useMobil, () {
      timerActive = false;
      //TODO:SEND Notification Local
      IdleLogic().notifyContactDate(contact);
      if (contact.sendWhatsapp) {
        IdleLogic().notifyContact();
      }
      mainController.saveUserLog("Envio de SMS a contacto cita", now);
    });
  }
}

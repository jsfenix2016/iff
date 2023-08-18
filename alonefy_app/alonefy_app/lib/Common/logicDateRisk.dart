import 'dart:async';

import 'package:ifeelefine/Common/idleLogic.dart';

import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/main.dart';

class LogicDateRisk {
  void sendMessageContactDate(ContactRiskBD contact) async {
    Duration useMobil = await IdleLogic().convertStringToDuration("5 min");
    timerSendSMS = Timer(useMobil, () {
      timerActive = false;
      //TODO:SEND Notification Local
      IdleLogic().notifyContactDate(contact);
      if (contact.sendWhatsapp) {
        IdleLogic().notifyContact();
      }
      mainController.saveUserLog("Envío de SMS a contacto cita", now);
    });
  }
}

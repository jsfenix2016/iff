import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Provider/user_provider.dart';
import 'package:intl/intl.dart';

class IdleLogic {
  Future<Duration> convertStringToDuration(String time) async {
    return Constant.timeMap[time] ?? const Duration(hours: 80640);
  }

  String whatDayIs() {
    final date = DateTime.now();
    final dayTemp = Constant.dayMap[date.weekday]!;
    return dayTemp;
  }

  Future notifyContact() async {
    final listContact = await const HiveData().listUserContactbd;
    final user = await const HiveData().getuserbd;

    if (listContact.isNotEmpty) {
      final durations = await Future.wait(listContact.map((element) async {
        return await IdleLogic().convertStringToDuration(element.timeSendSMS);
      }));

      for (var i = 0; i < listContact.length; i++) {
        final element = listContact[i];
        final numberCOntact = element.phones;
        final nameContact = element.displayName;
        final authData = {
          "recipient": numberCOntact,
          "originator": nameContact,
          'body':
              "Hola $nameContact, AlertFriends no detecta actividad de ${user.name + user.lastname}, comunicate con el usuario puede estar en riesgo."
        };
        final useMobil = durations[i];
        Timer(useMobil, () {
          UsuarioProvider().sendSMS(authData);
        });
      }
    }
  }

  Future notifyContactDate(ContactRiskBD contact) async {
    final user = await const HiveData().getuserbd;
    final located = contact.sendLocation ? determinePosition().toString() : "";
    final authData = {
      "recipient": contact.phones,
      "originator": contact.name,
      'body':
          "Hola ${contact.name}, AlertFriends no detecta actividad de ${user.name + user.lastname}, su cita termino puede estar en riesgo, su ultima ubicación detectada $located."
    };
    UsuarioProvider().sendSMS(authData);
  }

  Future<Duration> idleLogicDayActivity(
      FlutterBackgroundService service) async {
    await inicializeHiveBD();
    final listActivity = await const HiveData().listUserActivitiesbd;
    final now = DateTime.now();
    final day = whatDayIs();
    final format = DateFormat("HH:mm");
    int nowHour = now.hour;
    int nowMinute = now.minute;
    DateTime start, end;

    for (final element in listActivity) {
      if (day == element.day) {
        start = format.parse(element.timeStart);
        end = format.parse(element.timeFinish);
        if (nowHour == start.hour && nowMinute == start.minute) {
          return start.difference(end);
        }
      }
    }
    return const Duration(seconds: 1);
  }
}

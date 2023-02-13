import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Provider/user_provider.dart';
import 'package:intl/intl.dart';

class IdleLogic {
  Future<Duration> disambleIFF(String time) async {
    var disambleTemp = const Duration();

    switch (time) {
      case "":
        disambleTemp = const Duration(seconds: 15);
        break;
      case "5 min":
        disambleTemp = const Duration(minutes: 5);
        break;
      case "1 hora":
        disambleTemp = const Duration(hours: 1);
        break;
      case "2 horas":
        disambleTemp = const Duration(hours: 2);
        break;
      case "3 horas":
        disambleTemp = const Duration(hours: 3);
        break;
      case "8 horas":
        disambleTemp = const Duration(hours: 8);
        break;
      case "24 horas":
        disambleTemp = const Duration(hours: 24);
        break;
      case "1 semana":
        disambleTemp = const Duration(hours: 168);
        break;
      case "1 mes":
        disambleTemp = const Duration(hours: 672);
        break;
      case "1 año":
        disambleTemp = const Duration(hours: 8064);
        break;
      case "Siempre":
        disambleTemp = const Duration(hours: 80640);
        break;

      default:
    }
    return disambleTemp;
  }

  Future notifyContact() async {
    await inicializeHiveBD();
    var listContact = await const HiveData().listUserContactbd;
    var user = await const HiveData().getuserbd;
    var nameContact = '';
    var numberCOntact = '';
    var authData = {};

    for (var element in listContact) {
      numberCOntact = element.phones;
      nameContact = element.displayName;
      authData = {
        "recipient": numberCOntact,
        "originator": (nameContact),
        'body':
            "Hola $nameContact, IFeelFine no detecta actividad de ${user.name + user.lastname}, comunicate con el usuario puede estar en riesgo."
      };
    }

    var a = UsuarioProvider().sendSMS(authData);
  }

  Future<Duration> idleLogicDayActivity(
      FlutterBackgroundService service) async {
    await inicializeHiveBD();
    var listActivity = await const HiveData().listUserActivitiesbd;

    DateTime now = DateTime.now();
    var day = whatDayIs();
    var format = DateFormat("HH:mm");
    for (var element in listActivity) {
      var start = format.parse(element.timeStart);
      var end = format.parse(element.timeFinish);
      if (day == element.day &&
          now.hour == start.hour &&
          start.minute == now.minute) {
        return start.difference(end);
      }
    }
    return const Duration(seconds: 1);
  }

  String whatDayIs() {
    DateTime date = DateTime.now();
    var day = "";

    switch (date.weekday) {
      case 1:
        day = "Lunes";
        break;
      case 2:
        day = "Martes";
        break;
      case 3:
        day = "Miercoles";
        break;
      case 4:
        day = "Jueves";
        break;
      case 5:
        day = "Viernes";
        break;
      case 6:
        day = "Sabado";
        break;
      case 7:
        day = "Domingo";
        break;
      default:
    }
    return day;
  }
}

import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Provider/user_provider.dart';
import 'package:intl/intl.dart';

class IdleLogic {
  Future<Duration> convertStringToDuration(String time) async {
    var disambleTemp = const Duration();

    const map = {
      '': Duration(seconds: 15),
      '5 min': Duration(minutes: 5),
      '1 hora': Duration(hours: 1),
      '2 horas': Duration(hours: 2),
      '3 horas': Duration(hours: 3),
      '8 horas': Duration(hours: 8),
      '24 horas': Duration(hours: 24),
      '1 semana': Duration(hours: 168),
      '1 mes': Duration(hours: 672),
      '1 año': Duration(hours: 8064),
      'Siempre': Duration(hours: 80640),
    };

    disambleTemp = map[time] ?? const Duration(hours: 80640);

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
      if (listContact.isNotEmpty) {
        var useMobil =
            await IdleLogic().convertStringToDuration(element.timeSendSMS);
        Timer(useMobil, () {
          var a = UsuarioProvider().sendSMS(authData);
        });
      }
    }
  }

  Future notifyContactDate(ContactRiskBD contact) async {
    await inicializeHiveBD();

    var user = await const HiveData().getuserbd;

    var authData = {};
    var located = "";
    if (contact.sendLocation) {
      located = determinePosition().toString();
    }

    authData = {
      "recipient": contact.phones,
      "originator": (contact.name),
      'body':
          "Hola ${contact.name}, IFeelFine no detecta actividad de ${user.name + user.lastname}, su cita termino puede estar en riesgo, su ultima ubicación detectada $located."
    };
    var req = UsuarioProvider().sendSMS(authData);
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

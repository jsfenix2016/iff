import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'dart:convert';

import 'package:ifeelefine/Model/userbd.dart';

class UserRestService {
  Future<Map<String, dynamic>> saveData(
      UserBD user, List<RestDayBD> listRest) async {
    Map<String, dynamic> authData = {};

    for (var element in listRest) {
      authData.addAll({
        "phoneNumber": (user.telephone),
        "dayOfWeek": element.day,
        "wakeUpHour": element.timeWakeup,
        "retireHour": element.timeSleep,
        "index": element.selection,
        "select": element.isSelect,
      });
    }

    try {
      final resp = await http
          .post(Uri.parse("${Constant.baseApi}/v1/sleepHour"), body: authData);

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['errors'] == null) {
        return {"ok": false, "mesaje": decodeResp['description']};
      }

      if (decodeResp['id'] != null) {
        return {"ok": true, "token": decodeResp['id']};
      } else {
        return {"ok": false, "mesaje": decodeResp['id']};
      }
    } catch (error) {
      return {"ko": false, "mesaje": error.toString()};
    }
  }
}

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'dart:convert';

import 'package:ifeelefine/Model/userbd.dart';

class MainService {
  Future<Map<String, dynamic>> cancelNotifications() async {
    Map<String, dynamic> authData = {};

    try {
      final resp = await http.post(
          Uri.parse(
              "${Constant.baseApi}/v1/notifications/cancel/c0ee0444-13a2-44f1-a5da-9f04336c168"),
          body: authData);

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['errors'] == null) {
        return {"ok": false, "mesaje": decodeResp['description']};
      }

      if (decodeResp['id'] != null) {
        return {"ok": true};
      } else {
        return {"ok": false};
      }
    } catch (error) {
      return {"ko": false};
    }
  }

  Future<bool> cancelAllNotifications(List<String> taskIds) async {
    try {
      final response = await http.post(
          Uri.parse("${Constant.baseApi}/v1/notifications/cancel"),
          headers: Constant.headers,
          body: jsonEncode(taskIds));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendAlertToContactImmediately(List<String> taskIds) async {
    try {
      var json = jsonEncode(taskIds);

      final response = await http.post(
          Uri.parse("${Constant.baseApi}/v1/notifications/send"),
          headers: Constant.headers,
          body: jsonEncode(taskIds));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveDrop(UserBD user) async {
    try {
      final resp = await http.post(
          Uri.parse(
              "${Constant.baseApi}/v1/notifications/create/user/${user.telephone.replaceAll("+34", "")}/type/DROP"),
          headers: Constant.headers);

      return resp.statusCode == 200;
    } catch (error) {
      return false;
    }
  }
}

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'dart:convert';

import 'package:ifeelefine/Model/userbd.dart';

class MainService {
  Future<bool> cancelAllNotifications(List<String> taskIds) async {
    try {
      final response = await http.post(
          Uri.parse("${Constant.baseApi}/v1/notifications/cancel"),
          headers: Constant.headers,
          body: jsonEncode(taskIds));

      if (response.statusCode == 200) {
        print("cancelar notificacion: ${taskIds.first}");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendAlertToContactImmediately(List<String> taskIds) async {
    try {
      final response = await http.post(
          Uri.parse("${Constant.baseApi}/v1/notifications/send"),
          headers: Constant.headers,
          body: jsonEncode(taskIds));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveDrop(UserBD user) async {
    try {
      var cell = user.telephone.contains('+34')
          ? user.telephone.replaceAll("+34", "")
          : user.telephone;
      final resp = await http.post(
          Uri.parse(
              "${Constant.baseApi}/v1/notifications/create/user/$cell/type/DROP"),
          headers: Constant.headers);
      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}

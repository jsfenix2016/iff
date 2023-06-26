import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Model/ApiRest/AlertApi.dart';

import '../../../Common/Constant.dart';

class AlertsService {

  Future<AlertApi?> saveAlert(AlertApi alertApi) async {

    try {
      var json = jsonEncode(alertApi);

      var response = await http.post(
              Uri.parse(
                  "${Constant.baseApi}/v1/logAlert"),
                  headers: Constant.headers,
                  body: json
          );

      if (response.statusCode == 200) {
        return AlertApi.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateAlert(AlertApi alertApi, int id) async {

    try {
      var json = jsonEncode(alertApi);

      var response = await http.put(
              Uri.parse(
                  "${Constant.baseApi}/v1/logAlert/$id"),
                  headers: Constant.headers,
                  body: json
          );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteAlert(int id) async {

    try {
      var response = await http.delete(
              Uri.parse(
                  "${Constant.baseApi}/v1/logAlert/$id"),
                  headers: Constant.headers,
                  body: json
          );

      var status = response.statusCode;
    } catch (e) {
      print(e);
    }
  }
}
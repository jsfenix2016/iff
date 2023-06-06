import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Model/ApiRest/AlertApi.dart';

import '../../../Common/Constant.dart';

class AlertsService {

  Future<AlertApi?> saveAlert(AlertApi alertApi) async {

    var json = jsonEncode(alertApi);

    var response = await http.post(
        Uri.parse(
            "${Constant.baseApi}/v1/logAlert"),
        body: json
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<AlertApi?> getAlerts(String phoneNumber) async {

    var response = await http.get(
        Uri.parse(
            "${Constant.baseApi}/v1/logAlert/$phoneNumber")
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<void> updateAlert(AlertApi alertApi, int id) async {

    var json = jsonEncode(alertApi);

    await http.put(
        Uri.parse(
            "${Constant.baseApi}/v1/logAlert/$id"),
        body: json
    );
  }

  Future<void> deleteAlert(int id) async {

    await http.delete(
        Uri.parse(
            "${Constant.baseApi}/v1/logAlert/$id"),
        body: json
    );
  }
}
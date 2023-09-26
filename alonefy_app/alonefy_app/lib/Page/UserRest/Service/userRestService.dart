import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';

import 'dart:convert';

import '../../../Model/ApiRest/UserRestApi.dart';

class UserRestService {
  Future<bool> saveData(List<UserRestApi> listRestApi) async {
    try {
      var json = jsonEncode(listRestApi);
      final resp = await http.post(
          Uri.parse("${Constant.baseApi}/v1/sleepHour"),
          headers: Constant.headers,
          body: json);

      return resp.statusCode == 200;
    } catch (error) {
      return false;
    }
  }
}

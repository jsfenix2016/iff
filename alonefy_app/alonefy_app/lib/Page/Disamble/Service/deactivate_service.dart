import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';

class DeactivateService {
  Future<bool> saveData(String phoneNumber, int time) async {
    try {
      final json = {"phoneNumber": phoneNumber, "time": time};

      var response = await http.post(
          Uri.parse("${Constant.baseApi}/v1/user/temporaryDeactivation"),
          headers: Constant.headers,
          body: jsonEncode(json));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

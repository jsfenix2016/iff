import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../Common/Constant.dart';

class FallService {
  Future<bool> activateFall(String phoneNumber, bool activate) async {
    final json = {
      "phoneNumber": phoneNumber.replaceAll("+34", "").replaceAll(" ", ""),
      "activateFalls": activate
    };

    try {
      var resp = await http.put(
          Uri.parse("${Constant.baseApi}/v1/user/activateFalls"),
          headers: Constant.headers,
          body: jsonEncode(json));
      return resp.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  Future<void> updateFallTime(String phoneNumber, int fallTime) async {
    final json = {
      "phoneNumber": phoneNumber.replaceAll("+34", "").replaceAll(" ", ""),
      "fallTime": fallTime
    };

    await http.put(Uri.parse("${Constant.baseApi}/v1/user/fallTime"),
        headers: Constant.headers, body: jsonEncode(json));
  }
}

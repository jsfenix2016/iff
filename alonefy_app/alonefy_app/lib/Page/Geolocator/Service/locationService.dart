import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../Common/Constant.dart';

class LocationService {

  Future<bool> activateLocation(String phoneNumber, bool activate) async {

    try {
      final json = {"phoneNumber": "$phoneNumber", "activateLocation": activate};

      var response = await http.put(
              Uri.parse("${Constant.baseApi}/v1/user/activateLocation"),
              headers: Constant.headers,
              body: jsonEncode(json));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendLocation(String phoneNumber, String latitude, String longitude) async {

    try {
      final json = {"phoneNumber": "$phoneNumber", "latitude": latitude, "longitude": longitude};

      var response = await http.post(
              Uri.parse("${Constant.baseApi}/v1/location"),
              headers: Constant.headers,
              body: jsonEncode(json));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
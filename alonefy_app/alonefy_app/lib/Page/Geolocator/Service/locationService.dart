import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../Common/Constant.dart';

class LocationService {

  Future<void> activateLocation(String phoneNumber, bool activate) async {

    final json = {"phoneNumber": "$phoneNumber", "activateLocation": activate};

    await http.put(
        Uri.parse("${Constant.baseApi}/v1/user/activateLocation"),
        headers: Constant.headers,
        body: jsonEncode(json));
  }

  Future<void> sendLocation(String phoneNumber, String latitude, String longitude) async {

    final json = {"phoneNumber": "$phoneNumber", "latitude": latitude, "longitude": longitude};

    await http.put(
        Uri.parse("${Constant.baseApi}/v1/location"),
        headers: Constant.headers,
        body: jsonEncode(json));
  }
}
import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ifeelefine/Model/ApiRest/RestoreApi.dart';

class RestoreService {

  Future<RestoreApi?> restoreData(String phoneNumber, String email) async {
    try {
      final response = await http.get(Uri.parse("${Constant.baseApi}/v1/user/all/$phoneNumber"));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ifeelefine/Model/ApiRest/RestoreApi.dart';

import '../../../Model/ApiRest/userApi.dart';

class RestoreService {

  Future<UserApi?> getUser(String phoneNumber) async {

    try {
      final resp = await http.get(
          Uri.parse("${Constant.baseApi}/v1/user/$phoneNumber"),
          headers: Constant.headers
      );

      if (resp.statusCode == 200) {
        return UserApi.fromJson(jsonDecode(resp.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

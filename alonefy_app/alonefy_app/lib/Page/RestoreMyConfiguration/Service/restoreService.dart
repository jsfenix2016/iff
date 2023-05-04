import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class RestoreService {
  Future<bool> restoreData(String num, String email) async {
    final authData = {"recipient": "$num", "originator": (email)};

    try {
      final resp = await http.post(Uri.parse("${Constant.baseApi}/$num"),
          body: authData);

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['id'] != null) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}

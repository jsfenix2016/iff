import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'dart:convert';

import '../../../Model/ApiRest/userApi.dart';

class RestoreService {
  Future<UserApi?> getUser(String phoneNumber) async {
    try {
      final resp = await http.get(
          Uri.parse("${Constant.baseApi}/v1/user/$phoneNumber"),
          headers: Constant.headers);

      if (resp.statusCode == 200) {
        var bytes = resp.bodyBytes;
        var utfBody = utf8.decode(bytes);
        var decodeUtf = jsonDecode(utfBody);
        return UserApi.fromJson(decodeUtf);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

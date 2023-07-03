import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../../../Common/Constant.dart';
import '../../../Model/ApiRest/userApi.dart';

class GetUserService {
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

  Future<Uint8List?> getUserImage(String url) async {

    final resp = await http.get(Uri.parse(url));

    if (resp.statusCode == 200) {
      return resp.bodyBytes;
    } else {
      return null;
    }
  }
}
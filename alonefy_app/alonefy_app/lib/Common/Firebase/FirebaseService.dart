import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Model/ApiRest/FirebaseTokenApi.dart';

import '../Constant.dart';

class FirebaseService {
  Future<void> saveData(FirebaseTokenApi firebaseTokenApi) async {

    var json = jsonEncode(firebaseTokenApi);

    await http.put(
        Uri.parse("${Constant.baseApi}/v1/user/fcm"),
        headers: Constant.headers,
        body: json
    );
  }
}
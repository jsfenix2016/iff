import 'package:http/http.dart' as http;
import 'package:ifeelefine/Model/ApiRest/FirebaseTokenApi.dart';

import '../Constant.dart';

class FirebaseService {
  Future<void> saveData(FirebaseTokenApi firebaseTokenApi) async {

    final resp = await http.put(
        Uri.parse("${Constant.baseApi}/v1/user/fcm"),
        body: firebaseTokenApi
    );
  }
}
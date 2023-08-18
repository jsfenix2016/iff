import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Model/ApiRest/UseMobilApi.dart';
import 'dart:convert';

class UseMobilService {
  Future<bool> saveUseMobil(List<UseMobilApi> listuse) async {
    try {
      var json = jsonEncode(listuse);

      var response = await http.post(
          Uri.parse("${Constant.baseApi}/v1/inactivityTime"),
          headers: Constant.headers,
          body: json);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

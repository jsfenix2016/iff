import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Model/ApiRest/TermsAndConditionsApi.dart';

import '../../../Common/Constant.dart';

class TermsAndConditionsService {
  Future<bool> saveData(TermsAndConditionsApi termsAndConditionsApi) async {
    try {
      var json = jsonEncode(termsAndConditionsApi);

      final resp = await http.put(
          Uri.parse("${Constant.baseApi}/v1/user/termsAndConditions"),
          headers: Constant.headers,
          body: json);

      return resp.statusCode == 200;
    } catch (error) {
      return false;
    }
  }
}

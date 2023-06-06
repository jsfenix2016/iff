import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Model/ApiRest/TermsAndConditionsApi.dart';

import '../../../Common/Constant.dart';

class TermsAndConditionsService {
  Future<bool> saveData(TermsAndConditionsApi termsAndConditionsApi) async {
    try {
      var json = jsonEncode(termsAndConditionsApi);

      final resp = await http.post(Uri.parse("${Constant.baseApi}/v1/contact"),
          body: json);

      Map<String, dynamic> decodeResp = jsonDecode(resp.body);

      if (decodeResp['errors'] != null) {}
      return true;
    } catch (error) {
      return false;
    }
  }
}

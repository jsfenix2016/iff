import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Model/ApiRest/TermsAndConditionsApi.dart';

import '../../../Common/Constant.dart';

class TermsAndConditionsService {

  Future<void> saveData(TermsAndConditionsApi termsAndConditionsApi) async {

    var json = jsonEncode(termsAndConditionsApi);

    await http.put(
        Uri.parse("${Constant.baseApi}/v1/user/termsAndConditions"),
        body: json
    );
  }
}
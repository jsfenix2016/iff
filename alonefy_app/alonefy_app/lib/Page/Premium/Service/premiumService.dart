import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Model/ApiRest/PremiumApi.dart';

import '../../../Common/Constant.dart';

class PremiumService {

  Future<bool> saveData(PremiumApi premiumApi) async {

    try {
      var json = jsonEncode(premiumApi);

      var response = await http.put(
              Uri.parse("${Constant.baseApi}/v1/user/premium"),
              headers: Constant.headers,
              body: json
          );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
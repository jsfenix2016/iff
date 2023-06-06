import 'package:http/http.dart' as http;

import '../../../Common/Constant.dart';

class FallService {

  Future<void> activateFall(String phoneNumber, bool activate) async {

    final json = {"phoneNumber": phoneNumber, "activateFalls": activate};

    await http.put(
        Uri.parse("${Constant.baseApi}/v1/user/activateFalls"),
        body: json);
  }

  Future<void> updateFallTime(String phoneNumber, int fallTime) async {

    final json = {"phoneNumber": phoneNumber, "fallTime": fallTime};

    await http.put(
        Uri.parse("${Constant.baseApi}/v1/user/fallTime"),
        body: json);
  }
}
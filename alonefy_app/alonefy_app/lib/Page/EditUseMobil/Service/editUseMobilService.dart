import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Model/useMobilbd.dart';
import 'dart:convert';

import 'package:ifeelefine/Model/userbd.dart';

import '../../../Model/ApiRest/UseMobilApi.dart';

class EditUseMobilService {
  Future<Map<String, List<UseMobilBD>>> getUseMobil(UserBD user) async {
    return {};
  }

  Future<void> saveUseMobil(List<UseMobilApi> listuse) async {

    var json = jsonEncode(listuse);

    await http.put(
        Uri.parse("${Constant.baseApi}/v1/inactivityTime"),
        body: json);

  }
}

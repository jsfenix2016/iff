import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Model/ApiRest/UseMobilApi.dart';
import 'package:ifeelefine/Model/useMobilbd.dart';
import 'dart:convert';

import 'package:ifeelefine/Model/userbd.dart';

class UseMobilService {

  void saveUseMobil(List<UseMobilApi> listuse) async {

    var json = jsonEncode(listuse);

    await http.post(
        Uri.parse("${Constant.baseApi}/v1/inactivityTime"),
        body: json);

    //Map<String, dynamic> decodeResp = json.decode(resp.body);
  }
}

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Model/useMobilbd.dart';
import 'dart:convert';

import 'package:ifeelefine/Model/userbd.dart';

import '../../../Model/ApiRest/UseMobilApi.dart';

class EditUseMobilService {
  Future<Map<String, List<UseMobilBD>>> getUseMobil(UserBD user) async {
    return {};
    // try {
    //   final resp = await http.post(Uri.parse(
    //       "${Constant.baseApi}/v1/user/${user.telephone}/personalData"));

    //   Map<String, dynamic> decodeResp = json.decode(resp.body);

    //   if (decodeResp['errors'] == null) {
    //     return {"ok": false, "mesaje": decodeResp['description']};
    //   }

    //   if (decodeResp['id'] != null) {
    //     return {"ok": true, "token": decodeResp['id']};
    //   } else {
    //     return {"ok": false, "mesaje": decodeResp['id']};
    //   }
    // } catch (error) {
    //   return {"ko": false, "mesaje": error.toString()};
    // }
  }

  Future<void> saveUseMobil(List<UseMobilApi> listuse) async {

    final resp = await http.put(
        Uri.parse("${Constant.baseApi}/v1/inactivityTime"),
        body: listuse);

    Map<String, dynamic> decodeResp = json.decode(resp.body);
  }
}

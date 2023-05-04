import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Model/useMobilbd.dart';
import 'dart:convert';

import 'package:ifeelefine/Model/userbd.dart';

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

  Future<Map<String, dynamic>> saveUseMobil(
      List<UseMobilBD> listuse, UserBD user) async {
    final authData = {"listday": (listuse)};

    try {
      final resp = await http.post(
          Uri.parse(
              "${Constant.baseApi}/v1/user/${user.telephone}/personalData"),
          body: authData);

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['errors'] == null) {
        return {"ok": false, "mesaje": decodeResp['description']};
      }

      if (decodeResp['id'] != null) {
        return {"ok": true, "token": decodeResp['id']};
      } else {
        return {"ok": false, "mesaje": decodeResp['id']};
      }
    } catch (error) {
      return {"ko": false, "mesaje": error.toString()};
    }
  }
}

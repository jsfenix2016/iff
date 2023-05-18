import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'dart:convert';

import 'package:ifeelefine/Model/userbd.dart';

class UserConfig2Service {
  Future<Map<String, dynamic>> saveData(UserBD user) async {
    final authData = {
      "idUser": (user.idUser),
      "name": (user.name),
      "lastname": (user.lastname),
      "email": (user.email),
      "gender": (user.gender),
      "maritalStatus": (user.maritalStatus),
      "stylelife": (user.styleLife),
      "pathImage": null,
      "age": (user.age),
      "country": (user.country),
      "city": (user.city)
    };

    try {
      final resp = await http.put(
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

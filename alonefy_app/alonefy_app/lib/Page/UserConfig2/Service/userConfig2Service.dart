import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'dart:convert';

import 'package:ifeelefine/Model/userbd.dart';

class UserConfig2Service {
  Future<bool> saveData(UserBD user) async {
    final authData = {
      "phoneNumber": user.telephone.contains('+34')
          ? user.telephone.replaceAll("+34", "").replaceAll(" ", "")
          : user.telephone.replaceAll(" ", ""),
      "idUser": (user.idUser),
      "name": (user.name),
      "lastname": (user.lastname),
      "email": (user.email),
      "gender": (user.gender),
      "maritalStatus": (user.maritalStatus),
      "stylelife": (user.styleLife),
      "pathImage": user.pathImage,
      "age": (user.age),
      "country": (user.country),
      "city": (user.city)
    };

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8'
      };

      var json = jsonEncode(authData);
      final resp = await http.post(Uri.parse("${Constant.baseApi}/v1/user"),
          headers: headers, body: json);

      return resp.statusCode == 200;
    } catch (error) {
      return false;
    }
  }
}

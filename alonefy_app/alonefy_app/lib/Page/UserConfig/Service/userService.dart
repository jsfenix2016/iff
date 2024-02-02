import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ifeelefine/Model/userbd.dart';

class UserService {
  Future<bool> saveData(UserBD user) async {
    final authData = {
      "phoneNumber": user.telephone.contains('+34')
          ? user.telephone.replaceAll("+34", "").replaceAll(" ", "")
          : user.telephone.replaceAll(" ", ""),
      "idUser": (user.idUser),
      "name": (user.name),
      "lastname": (user.lastname),
      "email": user.email,
      "gender": (user.gender),
      "maritalStatus": (user.maritalStatus),
      "styleLife": (user.styleLife),
      "pathImage": (user.pathImage),
      "age": (user.age),
      "country": (user.country),
      "city": (user.city)
    };

    try {
      var dataTemp = jsonEncode(authData);
      final resp = await http.post(Uri.parse("${Constant.baseApi}/v1/user"),
          headers: Constant.headers, body: dataTemp);

      return resp.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  Future<Map<String, dynamic>> validateCodeSMS(String id, String code) async {
    // final authData = {"recipient": "$num", "originator": (code)};
    final headersData = {
      "Authorization": "AccessKey ${Constant.codeMessageBird}",
      "timeout": "240",
      "language": "es-es",
      "country": "ES"
    };

    try {
      final resp = await http.get(
        Uri.parse("$id?token=$code"),
        headers: headersData,
      );

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      // print(decodeResp);
      if (decodeResp['errors'] != null) {
        return {"ok": false, "mesaje": "error"};
      }

      if (decodeResp['id'] != null) {
        return {"ok": true, "href": decodeResp['href']};
      } else {
        return {"ok": false, "href": decodeResp['href']};
      }
    } catch (error) {
      return {"ko": false, "mesaje": error.toString()};
    }
  }

  Future<Map<String, dynamic>> validateCodeEmail(String id, String code) async {
    final headersData = {
      "Authorization": "AccessKey ${Constant.codeMessageBird}"
    };

    try {
      final resp =
          await http.get(Uri.parse("$id?token=$code"), headers: headersData);

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      // print(decodeResp);
      if (decodeResp['errors'] != null) {
        return {"ok": false, "mesaje": "error"};
      }

      if (decodeResp['status'] == "verified") {
        return {"ok": true, "status": decodeResp['status']};
      } else {
        return {"ok": false, "status": decodeResp['status']};
      }
    } catch (error) {
      return {"ko": false, "mesaje": error.toString()};
    }
  }

  Future<Map<String, dynamic>> verificateSMS(int num) async {
    final authData = {
      "recipient": "$num",
      "originator": "$num",
      "type": "sms",
      "timeout": "280",
      "language": "es-es",
      "country": "ES",
      "template": "Token de verificación: %token",
      "datacoding": "auto",
      "subject": "Solicitud de token"
    };
    final headersData = {
      "Authorization": "AccessKey ${Constant.codeMessageBird}"
    };

    try {
      final resp = await http.post(
          Uri.parse("${Constant.baseApiMessageBird}verify"),
          headers: headersData,
          body: authData);

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['errors'] != null) {
        return {"ok": false, "mesaje": decodeResp['description']};
      }

      if (decodeResp["id"] != null) {
        return {"ok": true, "href": decodeResp["href"]};
      } else {
        return {"ok": false, "href": decodeResp["href"]};
      }
    } catch (error) {
      return {"ko": false, "mesaje": error.toString()};
    }
  }

  Future<Map<String, dynamic>> validateEmailWithMessageBird(
      String email) async {
    final authData = {
      "recipient": email,
      "originator": ("hello@alertfriends.app"),
      "type": "email",
      "timeout": "280",
      "language": "es-es",
      "country": "ES",
      "template": "Token de verificación: %token",
      "datacoding": "auto",
      "subject": "Solicitud de token"
    };
    final headersData = {
      "Authorization": "AccessKey ${Constant.codeMessageBird}"
    };

    try {
      final resp = await http.post(
          Uri.parse("${Constant.baseApiMessageBird}verify"),
          headers: headersData,
          body: authData);

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      // print(decodeResp);
      // print(decodeResp);
      if (decodeResp['errors'] != null) {
        return {"ok": false, "mesaje": "error"};
      }

      if (decodeResp['id'] != null) {
        return {"ok": true, "href": decodeResp['href']};
      } else {
        return {"ok": false, "href": decodeResp['href']};
      }
    } catch (error) {
      return {"ko": false, "mesaje": error.toString()};
    }
  }

//FUNCIONA CORRECTAMENTE
  Future<Map<String, dynamic>> subirImagen(File image, String user) async {
    final bytes = image.readAsBytesSync();

    String img64 = base64Encode(bytes);

    final authData = {"image": img64, "user": user, "idUser": 50};

    final resp = await http.post(Uri.parse("${Constant.baseApi}/imageSa"),
        body: json.encode(authData));

    var decodeResp = json.decode(resp.body);

    var reslt = decodeResp;

    if (reslt[0]["image_1"] != null) {
      final algomas = {"ok": true, "imageUrl": reslt[0]["image_1"]};
      return algomas;
    } else {
      return {"ok": false, "mesaje": "no existe"};
    }
  }

  Future<Uint8List?> buscarImagen(String imgUrl) async {
    final resp = await http
        .get(Uri.parse("${Constant.baseApi}/imageSa?imgName=$imgUrl"));

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }

    Uint8List bytesImage;

    bytesImage = const Base64Decoder().convert(resp.body);

    return bytesImage;
  }

  Future<int> deleteUser(int id) async {
    // final resp = await http.delete(Uri.parse("url"));
    // print(json.decode(resp.body));

    return 1;
  }
}

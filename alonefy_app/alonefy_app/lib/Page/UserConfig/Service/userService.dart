import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class UserService {
  Future<Map<String, dynamic>> verificateSMS(int num, String name) async {
    final authData = {"recipient": "$num", "originator": (name)};
    final headersData = {
      "Authorization": "AccessKey slL8Vl8b2QKT0P54RC2rRjBqL"
    };

    try {
      final resp = await http.post(
          Uri.parse("${Constant.baseApiMessageBird}verify"),
          headers: headersData,
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

  Future<Map<String, dynamic>> verificateEmail(int num, String name) async {
    final authData = {"recipient": "$num", "originator": (name)};
    final headersData = {
      "Authorization": "AccessKey slL8Vl8b2QKT0P54RC2rRjBqL"
    };

    try {
      final resp = await http.post(
          Uri.parse("${Constant.baseApiMessageBird}verify"),
          headers: headersData,
          body: authData);

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      // print(decodeResp);
      if (decodeResp['id'] == null) {
        return {"ok": false, "mesaje": "error"};
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

  Future<Map<String, dynamic>> sendSMS(Map<dynamic, dynamic> data) async {
    // final authData = {"recipient": "$num", "originator": (name), 'body': ""};
    final headersData = {
      "Authorization": "AccessKey slL8Vl8b2QKT0P54RC2rRjBqL"
    };

    try {
      final resp = await http.post(
          Uri.parse("${Constant.baseApiMessageBird}messages"),
          headers: headersData,
          body: data);

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      // print(decodeResp);
      if (decodeResp['id'] == null) {
        return {"ok": false, "mesaje": "error"};
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

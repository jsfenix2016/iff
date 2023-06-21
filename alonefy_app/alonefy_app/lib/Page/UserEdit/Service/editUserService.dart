import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'dart:convert';

import 'package:ifeelefine/Model/userbd.dart';

import '../../../Utils/MimeType/mime_type.dart';

class EditUserService {
  Future<bool> updateUser(UserBD user) async {
    final authData = {
      "phoneNumber": (user.telephone.replaceAll("+34", "")),
      "idUser": (user.idUser),
      "name": (user.name),
      "lastname": (user.lastname),
      "email": user.email,
      "gender": (user.gender),
      "maritalStatus": (user.maritalStatus),
      "stylelife": (user.styleLife),
      "pathImage": "",
      "age": (user.age),
      "country": (user.country),
      "city": (user.city)
    };

    try {
      var json = jsonEncode(authData);
      final resp = await http.put(
          Uri.parse("${Constant.baseApi}/v1/user/personalData"),
          headers: Constant.headers,
          body: json);

      return resp.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  Future<String?> getUrlPhoto(String phoneNumber) async {
    try {
      var json = { "phoneNumber": phoneNumber };

      final resp = await http.put(
              Uri.parse("${Constant.baseApi}/v1/user/photo"),
              headers: Constant.headers,
              body: jsonEncode(json));

      return resp.body;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateImage(String url, Uint8List? bytes) async {
    try {
      var postUri = Uri.parse(url);

      var mime = lookupMimeType('', headerBytes: bytes);
      var extension = "";
      if (mime != null) {
        extension = extensionFromMime(mime);
      }

      final resp = await http.put(
          postUri,
          headers: {'Content-Type': mime ?? 'image/jpeg'},
          body: bytes);

    } catch (e) {
      print(e);
    }
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Model/ApiRest/ContactRiskApi.dart';

import '../../../../Utils/MimeType/mime_type.dart';

class ContactRiskService {

  Future<ContactRiskApi?> createContactRisk(ContactRiskApi contactRisk) async {

    var json = jsonEncode(contactRisk);

    var response = await http.post(
        Uri.parse("${Constant.baseApi}/v1/contactRisk"),
        headers: Constant.headers,
        body: json);

    if (response.statusCode == 200) {
      return ContactRiskApi.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<ContactRiskApi?> updateContactRisk(ContactRiskApi contactRisk, int id) async {

    try {
      var contactRiskJson = contactRisk.toJson();
      var idMap = <String, dynamic> {
            "id": id
          };
      contactRiskJson.addAll(idMap);

      var json = jsonEncode(contactRiskJson);

      var response = await http.put(
              Uri.parse("${Constant.baseApi}/v1/contactRisk"),
              headers: Constant.headers,
              body: json);

      if (response.statusCode == 200) {
        return ContactRiskApi.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<ContactRiskApi>> getContactsRisk(String phoneNumber) async {

    var response = await http.get(
        Uri.parse("${Constant.baseApi}/v1/contactRisk/$phoneNumber"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  Future<void> deleteContactsRisk(int id) async {
    try {
      var response = await http.delete(
              Uri.parse("${Constant.baseApi}/v1/contactRisk/$id"),
              headers: Constant.headers);

      var status = response.statusCode;
    } catch (e) {
      print(e);
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

      var status = resp.statusCode;

    } catch (e) {
      print(e);
    }
  }

  Future<Uint8List?> getContactImage(String url) async {

    final resp = await http.get(Uri.parse(url));

    if (resp.statusCode == 200) {
      return resp.bodyBytes;
    } else {
      return null;
    }
  }
}
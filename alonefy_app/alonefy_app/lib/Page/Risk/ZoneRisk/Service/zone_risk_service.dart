import 'dart:convert';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Model/ApiRest/ZoneRiskApi.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';

import '../../../../Common/Constant.dart';
import '../../../../Utils/MimeType/mime_type.dart';

class ZoneRiskService {

  Future<ZoneRiskApi?> createContactZoneRisk(ZoneRiskApi zoneRiskApi) async {

    var json = jsonEncode(zoneRiskApi);

    var response = await http.post(
        Uri.parse("${Constant.baseApi}/v1/zoneRisk"),
        headers: Constant.headers,
        body: json);

    if (response.statusCode == 200) {
      return ZoneRiskApi.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<ZoneRiskApi?> updateZoneRisk(ZoneRiskApi zoneRiskApi, int id) async {
    try {
      var zoneRiskJson = zoneRiskApi.toJson();
      var zoneRiskUpdate = <String, dynamic> {
        "id": id,
        "name": zoneRiskApi.name
      };
      zoneRiskJson.addAll(zoneRiskUpdate);
      var json = jsonEncode(zoneRiskJson);

      var response = await http.put(
              Uri.parse("${Constant.baseApi}/v1/zoneRisk"),
              headers: Constant.headers,
              body: json);

      if (response.statusCode == 200) {
        return ZoneRiskApi.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<ZoneRiskApi>> getContactsZoneRisk(String phoneNumber) async {

    var response = await http.get(
        Uri.parse("${Constant.baseApi}/v1/zoneRisk/$phoneNumber"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  Future<bool> deleteZoneRisk(int id) async {

    try {
      var response = await http.delete(
              Uri.parse("${Constant.baseApi}/v1/zoneRisk/$id"),
              headers: Constant.headers);

      return response.statusCode == 200;
    } catch (e) {
      return false;
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

  Future<String?> getVideoUrl(String phoneNumber, int id) async {
    try {
      var json = {
        "phoneNumber": phoneNumber,
        "id": id
      };
      var response = await http.put(
          Uri.parse("${Constant.baseApi}/v1/zoneRisk/video"),
          headers: Constant.headers,
          body: jsonEncode(json));

      return response.body;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateVideo(String url, Uint8List? bytes) async {
    try {
      var postUri = Uri.parse(url);

      var mime = lookupMimeType('', headerBytes: bytes);
      var extension = "";
      if (mime != null) {
        extension = extensionFromMime(mime);
      }

      final resp = await http.put(
          postUri,
          headers: {'Content-Type': mime ?? 'video/mp4'},
          body: bytes);

      var status = resp.statusCode;

    } catch (e) {
      print(e);
    }
  }

  Future<List<String>> createZoneRiskAlert(ZoneRiskApi zoneRiskApi) async {
    try {
      var zoneRiskJson = zoneRiskApi.toJson();
      
      zoneRiskJson.remove("customContactWhatsappNotification");
      zoneRiskJson.remove("customContactVoiceNotification");

      var json = jsonEncode(zoneRiskJson);

      var response = await http.post(
          Uri.parse("${Constant.baseApi}/v1/notifications/create/user/${zoneRiskApi.phoneNumber}/type/RISK_ZONE"),
          headers: Constant.headers,
          body: json);

      var body = response.body;
      var decode = jsonDecode(body);
      List<String> list = dynamicToStringList(decode);

      return list;
    } catch (e) {
      return [];
    }
  }

  Future<Uint8List?> getZoneRiskImage(String url) async {

    final resp = await http.get(Uri.parse(url));

    if (resp.statusCode == 200) {
      return resp.bodyBytes;
    } else {
      return null;
    }
  }
}
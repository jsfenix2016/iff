import 'dart:convert';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;

import 'package:ifeelefine/Model/ApiRest/ZoneRiskApi.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';

import '../../../../Common/Constant.dart';
import '../../../../Utils/MimeType/mime_type.dart';

class ZoneRiskService {

  Future<ZoneRiskApi?> createContactZoneRisk(ZoneRiskApi zoneRiskApi) async {

    var json = jsonEncode(zoneRiskApi);

    var response = await http.post(
        Uri.parse("${Constant.baseApi}/v1/zoneRisk"),
        body: json);

    if (response.statusCode == 200) {
      return ZoneRiskApi.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  void updateZoneRisk(ZoneRiskApi zoneRiskApi, int id) async {

    var json = jsonEncode(zoneRiskApi);

    await http.put(
        Uri.parse("${Constant.baseApi}/v1/zoneRisk/$id"),
        body: json);
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

  Future<void> deleteZoneRisk(int id) async {
    await http.delete(
        Uri.parse("${Constant.baseApi}/v1/zoneRisk/$id"));
  }

  Future<void> updateImage(String phoneNumber, int id, Uint8List bytes) async {
    var postUri = Uri.parse("${Constant.baseApi}/v1/zoneRisk/setMedia/$id");
    var request = new http.MultipartRequest("PUT", postUri);
    request.fields['phoneNumber'] = phoneNumber;

    var mime = lookupMimeType('', headerBytes: bytes);
    var extension = "";
    if (mime != null) {
      extension = extensionFromMime(mime);
    }

    request.files.add(http.MultipartFile.fromBytes('file', bytes, contentType: MediaType(mime ?? "", extension)));

    request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");
    });
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
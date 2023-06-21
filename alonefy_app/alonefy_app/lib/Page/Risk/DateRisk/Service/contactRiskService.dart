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

    var response = await http
        .post(Uri.parse("${Constant.baseApi}/v1/contactRisk"), body: json);

    if (response.statusCode == 200) {
      return ContactRiskApi.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  void updateContactRisk(ContactRiskApi contactRisk, int id) async {
    var json = jsonEncode(contactRisk);

    await http.put(Uri.parse("${Constant.baseApi}/v1/contactRisk/$id"),
        body: json);
  }

  Future<List<ContactRiskApi>> getContactsRisk(String phoneNumber) async {
    var response = await http
        .get(Uri.parse("${Constant.baseApi}/v1/contactRisk/$phoneNumber"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  Future<void> deleteContactsRisk(int id) async {
    await http.delete(Uri.parse("${Constant.baseApi}/v1/contactRisk/$id"));
  }

  Future<void> updateImage(String phoneNumber, int id, Uint8List bytes) async {
    var postUri = Uri.parse("${Constant.baseApi}/v1/contactRisk/setMedia/$id");
    var request = new http.MultipartRequest("PUT", postUri);
    request.fields['phoneNumber'] = phoneNumber;

    var mime = lookupMimeType('', headerBytes: bytes);
    var extension = "";
    if (mime != null) {
      extension = extensionFromMime(mime);
    }

    request.files.add(http.MultipartFile.fromBytes('file', bytes,
        contentType: MediaType(mime ?? "", extension)));

    request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");
    });
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

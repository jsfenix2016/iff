import 'dart:io';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Model/ApiRest/ContactApi.dart';
import 'dart:convert';

import 'package:ifeelefine/Model/contact.dart';

import '../../../Utils/MimeType/mime_type.dart';

class ContactService {

  Future<void> saveContact(ContactApi contact) async {

    var json = jsonEncode(contact);

    await http.post(
        Uri.parse(
            "${Constant.baseApi}/v1/contact"),
            body: json
        );

    //Map<String, dynamic> decodeResp = json.decode(resp.body);

  }

  Future<void> updateContact(ContactApi contact) async {

    var json = jsonEncode(contact);

    await http.put(
        Uri.parse(
            "${Constant.baseApi}/v1/contact"),
        body: json
    );

  }

  Future<bool> deleteContact(String userPhoneNumber, String phoneNumber) async {

    var response = await http.delete(
        Uri.parse(
            "${Constant.baseApi}/v1/contact/user/$userPhoneNumber/contact/$phoneNumber")
    );

    return response.statusCode == 200;
  }

  Future<bool> updateContactStatus(String userPhoneNumber, String phoneNumber) async {

    var response = await http.get(
        Uri.parse(
            "${Constant.baseApi}/v1/contact/user/$userPhoneNumber/contact/$phoneNumber/ACCEPTED")
    );

    return response.statusCode == 200;
  }

  Future<List<ContactApi>?> getContact(String userPhoneNumber) async {

    var response = await http.get(
        Uri.parse(
            "${Constant.baseApi}/v1/contact/user/$userPhoneNumber")
    );

    Iterable responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var list = responseBody.map((contact) => ContactApi.fromJson(contact)).toList();
      return list;
    } else {
      return null;
    }
  }

  Future<void> updateImage(String phoneNumber, String contactPhoneNumber, Uint8List bytes) async {
    var postUri = Uri.parse("${Constant.baseApi}/v1/contact/setPhoto");
    var request = new http.MultipartRequest("PUT", postUri);
    request.fields['phoneNumber'] = phoneNumber;
    request.fields['contactPhoneNumber'] = contactPhoneNumber;

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

  Future<Uint8List?> getContactImage(String url) async {

    final resp = await http.get(Uri.parse(url));

    if (resp.statusCode == 200) {
      return resp.bodyBytes;
    } else {
      return null;
    }
  }
}

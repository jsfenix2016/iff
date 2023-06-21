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

  Future<bool> saveContact(ContactApi contact) async {

    var json = jsonEncode(contact);

    try {
      final resp = await http.post(Uri.parse("${Constant.baseApi}/v1/contact"),
          headers: Constant.headers,
          body: json);

      return resp.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateContact(ContactApi contact) async {

    var json = jsonEncode(contact);

    try {
      final resp = await http.put(Uri.parse("${Constant.baseApi}/v1/contact"),
          headers: Constant.headers,
          body: json);

      return resp.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteContact(String userPhoneNumber, String phoneNumber) async {
    try {
      var response = await http.delete(Uri.parse(
          "${Constant.baseApi}/v1/contact/user/$userPhoneNumber/contact/$phoneNumber"),
        headers: Constant.headers);

      return response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  Future<List<ContactApi>?> getContact(String userPhoneNumber) async {
    try {
      var response = await http.get(
          Uri.parse("${Constant.baseApi}/v1/contact/user/$userPhoneNumber"),
        headers: Constant.headers);

      Iterable responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var list = responseBody
            .map((contact) => ContactApi.fromJson(contact))
            .toList();
        return list;
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<String?> getUrlPhoto(String userPhoneNumber, String phoneNumber) async {
    try {
      var json = { "userPhoneNumber": userPhoneNumber, "phoneNumber": phoneNumber };

      final resp = await http.put(
          Uri.parse("${Constant.baseApi}/v1/contact/photo"),
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

  Future<Uint8List?> getContactImage(String url) async {

    final resp = await http.get(Uri.parse(url));

    if (resp.statusCode == 200) {
      return resp.bodyBytes;
    } else {
      return null;
    }
  }
}

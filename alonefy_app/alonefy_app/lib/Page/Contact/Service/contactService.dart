import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Model/ApiRest/ContactApi.dart';
import 'dart:convert';

class ContactService {
  Future<void> saveContact(ContactApi contact) async {
    var json = jsonEncode(contact);

    try {
      final resp = await http.post(Uri.parse("${Constant.baseApi}/v1/contact"),
          body: json);

      Map<String, dynamic> decodeResp = jsonDecode(resp.body);

      if (decodeResp['errors'] != null) {}
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateContact(ContactApi contact) async {
    var json = jsonEncode(contact);

    try {
      final resp = await http.put(Uri.parse("${Constant.baseApi}/v1/contact"),
          body: json);

      Map<String, dynamic> decodeResp = jsonDecode(resp.body);

      if (decodeResp['errors'] != null) {}
    } catch (error) {
      print(error);
    }
  }

  Future<bool> deleteContact(String userPhoneNumber, String phoneNumber) async {
    // return response.statusCode == 200;

    try {
      var response = await http.delete(Uri.parse(
          "${Constant.baseApi}/v1/contact/user/$userPhoneNumber/contact/$phoneNumber"));

      Map<String, dynamic> decodeResp = jsonDecode(response.body);

      if (decodeResp['errors'] != null) {}
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateContactStatus(
      String userPhoneNumber, String phoneNumber) async {
    // return response.statusCode == 200;
    try {
      var response = await http.get(Uri.parse(
          "${Constant.baseApi}/v1/contact/user/$userPhoneNumber/contact/$phoneNumber/ACCEPTED"));

      Map<String, dynamic> decodeResp = jsonDecode(response.body);

      if (decodeResp['errors'] != null) {}
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<List<ContactApi>?> getContact(String userPhoneNumber) async {
    try {
      var response = await http.get(
          Uri.parse("${Constant.baseApi}/v1/contact/user/$userPhoneNumber"));

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
}

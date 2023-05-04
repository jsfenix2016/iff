import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'dart:convert';

import 'package:ifeelefine/Model/contact.dart';

class ContactService {
  Future<Map<String, dynamic>> saveContact(ContactBD contact) async {
    final authData = {"l": "$num", "originator": (contact.name), 'body': ""};

    try {
      final resp = await http.post(
          Uri.parse(
              "${Constant.baseApi}/v1/user/${contact.phones}/personalData"),
          body: authData);

      Map<String, dynamic> decodeResp = json.decode(resp.body);

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
}

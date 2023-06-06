import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'dart:convert';

import 'package:ifeelefine/Model/userbd.dart';

class EditUserService {
  Future<Map<String, dynamic>> updateUser(UserBD user) async {
    final authData = {
      "phoneNumber": (user.telephone),
      "idUser": (user.idUser),
      "name": (user.name),
      "lastname": (user.lastname),
      "email": (user.email),
      "gender": (user.gender),
      "maritalStatus": (user.maritalStatus),
      "stylelife": (user.styleLife),
      "pathImage": (user.pathImage),
      "age": (user.age),
      "country": (user.country),
      "city": (user.city)
    };

    try {
      final resp = await http.put(
          Uri.parse(
              "${Constant.baseApi}/v1/user/personalData"),
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

  Future<void> updateImage(String phoneNumber, String imagePath) async {
    var postUri = Uri.parse("${Constant.baseApi}/v1/user/setPhoto");
    var request = new http.MultipartRequest("PUT", postUri);
    request.fields['phoneNumber'] = phoneNumber;
    var bytes = await File(imagePath).readAsBytes();

    var imageType = "";
    if (imagePath.contains('png')) imageType = 'png';
    else imageType = 'jpg';

    request.files.add(new http.MultipartFile.fromBytes('file', bytes, contentType: MediaType('image', imageType)));

    request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");
    });
  }
}

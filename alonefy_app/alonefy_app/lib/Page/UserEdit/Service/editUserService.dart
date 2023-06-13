import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';
import 'dart:convert';

import 'package:ifeelefine/Model/userbd.dart';

class EditUserService {
  Future<bool> updateUser(UserBD user) async {
    final authData = {
      "phoneNumber": (user.telephone.replaceAll("+34", "")),
      "idUser": (user.idUser),
      "name": (user.name),
      "lastname": (user.lastname),
      "email": "bb@gmail.es",
      "gender": (user.gender),
      "maritalStatus": (user.maritalStatus),
      "stylelife": (user.styleLife),
      "pathImage": (user.pathImage),
      "age": (user.age),
      "country": (user.country),
      "city": (user.city)
    };

    try {
      Map<String,String> headers = {
        'Content-Type':'application/json; charset=UTF-8'
      };

      var json = jsonEncode(authData);
      final resp = await http.put(
          Uri.parse("${Constant.baseApi}/v1/user/personalData"),
          headers: headers,
          body: json);

      return resp.statusCode == 200;
    } catch (error) {
      return false;
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

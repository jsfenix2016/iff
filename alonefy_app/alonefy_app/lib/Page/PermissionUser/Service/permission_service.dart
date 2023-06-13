import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Model/ApiRest/PermissionApi.dart';

import '../../../Common/Constant.dart';

class PermissionService {

  Future<bool> activatePermissions(String phoneNumber, PermissionApi permissionApi) async {

    try {
      final json = jsonEncode(permissionApi);

      var response = await http.put(
              Uri.parse("${Constant.baseApi}/v1/user/activate"),
              headers: Constant.headers,
              body: json);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

}
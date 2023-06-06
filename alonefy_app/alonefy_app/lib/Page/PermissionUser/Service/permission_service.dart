import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifeelefine/Model/ApiRest/PermissionApi.dart';

import '../../../Common/Constant.dart';

class PermissionService {

  Future<void> activatePermissions(String phoneNumber, PermissionApi permissionApi) async {

    final json = jsonEncode(permissionApi);

    await http.put(
        Uri.parse("${Constant.baseApi}/v1/user/activate"),
        body: json);
  }

}
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:ifeelefine/Model/ApiRest/userApi.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/UserEdit/Service/getUserService.dart';
import 'package:ifeelefine/main.dart';
import 'package:uuid/uuid.dart';

import '../../../Model/user.dart';

class GetUserController extends GetxController {
  
  Future<UserApi?> getUser(String phoneNumber) async {
    var userApi = await GetUserService().getUser(phoneNumber);

    return userApi;
  }

  UserBD userApiToUserBD(UserApi userApi, String pathImage) {
    return UserBD(
        idUser: const Uuid().v1(),
        name: userApi.name,
        lastname: userApi.lastname,
        email: userApi.email,
        telephone: userApi.phoneNumber,
        gender: userApi.gender,
        maritalStatus: userApi.maritalStatus,
        styleLife: userApi.styleLife,
        pathImage: pathImage,
        age: userApi.age > 0 ? userApi.age.toString() : "",
        country: userApi.country,
        city: userApi.city
    );
  }

  Future<Uint8List?> getUserImage(String url) async {
    return await GetUserService().getUserImage(url);
  }
}
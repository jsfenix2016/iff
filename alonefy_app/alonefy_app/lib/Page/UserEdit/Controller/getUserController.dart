import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:ifeelefine/Model/ApiRest/userApi.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/UserEdit/Service/getUserService.dart';
import 'package:ifeelefine/main.dart';
import 'package:uuid/uuid.dart';

import '../../../Model/user.dart';

class GetUserController extends GetxController {
  
  Future<User?> getUser(String phoneNumber) async {
    var userApi = await GetUserService().getUser(phoneNumber);

    if (userApi != null) {
      var user = User(
        idUser: userApi.idUser,
        name: userApi.name,
        lastname: userApi.lastname,
        email: userApi.email,
        telephone: userApi.telephone,
        gender: userApi.gender,
        maritalStatus: userApi.maritalStatus,
        styleLife: userApi.styleLife,
        pathImage: userApi.pathImage,
        age: userApi.age,
        country: userApi.country,
        city: userApi.city
      );

      return user;
    }

    return null;
  }

  UserBD userApiToUserBD(UserApi userApi, String pathImage) {
    return UserBD(
        idUser: const Uuid().v1(),
        name: userApi.name,
        lastname: userApi.lastname,
        email: userApi.email,
        telephone: userApi.telephone,
        gender: userApi.gender,
        maritalStatus: userApi.maritalStatus,
        styleLife: userApi.styleLife,
        pathImage: pathImage,
        age: userApi.age,
        country: userApi.country,
        city: userApi.city
    );
  }

  Future<Uint8List?> getUserImage(String url) async {
    return await GetUserService().getUserImage(url);
  }
}
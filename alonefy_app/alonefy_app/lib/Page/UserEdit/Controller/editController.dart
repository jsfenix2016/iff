import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Provider/user_provider.dart';
import 'package:country_state_city_picker/model/select_status_model.dart'
    as StatusModel;

class EditConfigController extends GetxController {
  // final usuarioProvider = UsuarioProvider();

  final List<String> _states = ["Seleccionar estado"];
  final List<String> _country = ["Seleccionar pais"];
  final String _selectedCountry = "Choose Country";
  List<dynamic> countryres = [];
  List<dynamic> stateTemp = [];
  Map<String, String> ages = {};
  late int indexState = 0;
  late int indexCountry = 0;
  late String selectState = "";
  late String selectCountry = "";
  User? user;
  UserBD? userbd;

  Future<Map<String, String>> getAgeVC() async {
    var ages = getAge();
    return ages;
  }

  Future getResponse() async {
    var res = await rootBundle.loadString(
        'packages/country_state_city_picker/lib/assets/country.json');

    return jsonDecode(res);
  }

  Future refreshContry() async {
    indexCountry = _country.indexWhere((item) => item == user!.country);
    print(indexCountry);
    if (indexCountry < 0) indexCountry = 0;
    selectCountry = _country[indexCountry];
    print(selectCountry);

    for (var element in countryres) {
      var model = StatusModel.StatusModel();
      model.name = element['name'];
      model.emoji = element['emoji'];
      var states = element['state'];
      if (element == null) break;

      if (selectCountry.contains(("${model.emoji!}  ${model.name!}"))) {
        if (stateTemp.isNotEmpty) {
          stateTemp.clear();
        }
        stateTemp.add(states);
        if (states.length > 1) {
          filterState();
        } else {
          indexState = 0;
        }
      }
    }
  }

  Future<List<String>> getCounty() async {
    countryres = await getResponse() as List;
    for (var data in countryres) {
      var model = StatusModel.StatusModel();
      model.name = data['name'];
      model.emoji = data['emoji'];
      if (data == null) continue;

      _country.add("${model.emoji!}  ${model.name!}");
    }

    indexCountry = _country.indexWhere((item) => item == user!.country);
    print(indexCountry);
    if (indexCountry < 0) indexCountry = 0;
    selectCountry = _country[indexCountry];
    print(selectCountry);

    for (var i in _country) {
      if (i == user!.country) {
        for (var element in countryres) {
          var model = StatusModel.StatusModel();
          model.name = element['name'];
          model.emoji = element['emoji'];

          if (i.contains(("${model.emoji!}  ${model.name!}"))) {
            if (stateTemp.isNotEmpty) {
              stateTemp.removeLast();
            }
            stateTemp.add(element['state']);

            filterState();
            break;
          }
        }

        break;
      }
    }
    indexState = _states.indexWhere((item) => item == user!.city);

    if (indexState < 0) indexState = 0;
    selectState = _states[indexState];

    return _country;
  }

  Future<List<String>> filterState() async {
    if (_states.isNotEmpty) {
      _states.clear();
    }

    for (var f in stateTemp) {
      if (f == null) continue;

      f.forEach((data) {
        _states.add("${data['name']}");
      });
    }

    return _states;
  }

  Future<List<String>> getState() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.emoji + "    " + item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    for (var f in states) {
      if (f == null) continue;

      var name = f.map((item) => item.name).toList();
      for (var statename in name) {
        _states.add(statename.toString());
      }
    }

    return _states;
  }

  Future<bool> updateUserDate(BuildContext context, User user) async {
    try {
      // Map info
      UserBD userbd = UserBD(
          idUser: user.idUser.toString(),
          name: user.name,
          lastname: user.lastname,
          email: user.email,
          telephone: user.telephone,
          gender: user.gender,
          maritalStatus: user.maritalStatus,
          styleLife: user.styleLife,
          pathImage: user.pathImage,
          age: user.age,
          country: user.country,
          city: user.city);

      await const HiveData().updateUser(userbd);
      // Box<UserBD> box = await Hive.openBox<UserBD>('userBD');

      // await box.putAt(int.parse(userbd.idUser), userbd);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<User> getUserDate() async {
    user = User(
        idUser: -1,
        name: '',
        lastname: '',
        email: '',
        telephone: '',
        gender: '',
        maritalStatus: '',
        styleLife: '',
        pathImage: '',
        age: '18',
        country: '',
        city: '');

    UserBD box = await const HiveData().getuserbd;
    if (box.idUser == "-1") {
      user = User(
          idUser: int.parse(box.idUser),
          name: box.name,
          lastname: box.lastname,
          email: box.email,
          telephone: box.telephone,
          gender: box.gender,
          maritalStatus: box.maritalStatus,
          styleLife: box.styleLife,
          pathImage: box.pathImage,
          age: box.age,
          country: box.country,
          city: box.city);
      return user!;
    } else {
      return user!;
    }
  }
}

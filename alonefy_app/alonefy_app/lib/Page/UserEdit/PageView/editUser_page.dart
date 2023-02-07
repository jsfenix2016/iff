import 'dart:convert';
import 'dart:io';

import 'package:country_state_city_picker/model/select_status_model.dart'
    as StatusModel;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';

import 'package:ifeelefine/Page/UserRest/PageView/configurationUserRest_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Utils/Widgets/dropdownNotBorder.dart';

class UserEditPage extends StatefulWidget {
  const UserEditPage({super.key});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final UserConfigCOntroller userVC = Get.put(UserConfigCOntroller());

  bool isCheck = false;
  late bool selectImage = false;
  final bool _guardado = false;
  User? user;
  UserBD? userbd;
  late bool istrayed;

  late bool selectOther = false;

  late Image imgNew;

  final formKey = GlobalKey<FormState>();
  final formKeyName = GlobalKey<FormState>();
  final formKeyLastName = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late File? foto = File("");
  late int indexState = 0;
  late int indexCountry = 0;
  late String selectState = "";
  late String selectCountry = "";
  final List<String> _states = ["Seleccionar estado"];
  final List<String> _country = ["Seleccionar pais"];
  final String _selectedCountry = "Choose Country";
  List<dynamic> countryres = [];
  List<dynamic> stateTemp = [];
  Map<String, String> ages = {};

  @override
  void initState() {
    getCounty();
    user = User(
        idUser: 0,
        name: "",
        lastname: "",
        email: "",
        telephone: "",
        gender: "",
        maritalStatus: "",
        styleLife: "",
        pathImage: "",
        age: '18',
        country: '',
        city: '');

    super.initState();

    getUserData();
    _getAge();
  }

  Future<Map<String, String>> _getAge() async {
    ages = getAge();
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
      if (!mounted) break;

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
    setState(() {});
  }

  Future SelectDropState() async {
    indexState = _states.indexWhere((item) => item == user!.city);
    print(indexState);
    if (indexState < 0) indexState = 0;
    selectState = _states[indexState];
  }

  Future getCounty() async {
    countryres = await getResponse() as List;
    for (var data in countryres) {
      var model = StatusModel.StatusModel();
      model.name = data['name'];
      model.emoji = data['emoji'];
      if (!mounted) continue;
      setState(() {
        _country.add("${model.emoji!}  ${model.name!}");
      });
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
          if (!mounted) break;

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
    print(indexState);
    if (indexState < 0) indexState = 0;
    selectState = _states[indexState];
    print(selectCountry);

    return _country;
  }

  Future filterState() async {
    if (_states.isNotEmpty) {
      _states.clear();
    }

    for (var f in stateTemp) {
      if (!mounted) continue;

      f.forEach((data) {
        _states.add("${data['name']}");
      });
    }

    setState(() {});
    return _states;
  }

  Future getState() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.emoji + "    " + item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    for (var f in states) {
      if (!mounted) continue;
      setState(
        () {
          var name = f.map((item) => item.name).toList();
          for (var statename in name) {
            _states.add(statename.toString());
          }
        },
      );
    }

    return _states;
  }

  Future getUserData() async {
    userbd = await userVC.getUserDate();
    if (userbd != null) {
      user = User(
          idUser: int.parse(userbd!.idUser),
          name: userbd!.name,
          lastname: userbd!.lastname,
          email: userbd!.email,
          telephone: userbd!.telephone,
          gender: userbd!.gender,
          maritalStatus: userbd!.maritalStatus,
          styleLife: userbd!.styleLife,
          pathImage: userbd!.pathImage,
          age: userbd!.age.toString(),
          country: userbd!.country,
          city: userbd!.city);

      selectCountry = userbd!.country;
      selectState = userbd!.city;
    }

    setState(() {});
  }

  Future<Image> getImage(String urlImage) async {
    Uint8List bytesImages = const Base64Decoder().convert(urlImage);

    return imgNew = Image.memory(bytesImages,
        fit: BoxFit.cover, width: double.infinity, height: 250.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 76, 52, 22),
        title: const Text('Editar perfil'),
      ),
      backgroundColor: const Color.fromRGBO(115, 75, 24, 1),
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          decoration: decorationCustom(),
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                Column(
                  children: <Widget>[
                    const SizedBox(height: 10),
                    _crearNombre(""),
                    const SizedBox(height: 10),
                    _lastName(""),
                    const SizedBox(height: 10),
                    _telefono(""),
                    const SizedBox(height: 10),
                    _emailTxt(""),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorPalette.principal,
                              width: 1,
                              style: BorderStyle.none),
                        ),
                        child: SizedBox(
                          height: 52,
                          child: DropdownButton<String?>(
                            underline: Container(
                              height: 1,
                              color: ColorPalette.principal,
                            ),
                            hint: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (userbd != null && userbd!.gender != "")
                                    ? userbd!.gender
                                    : Constant.selectGender,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: ColorPalette.principal),
                              ),
                            ),
                            iconEnabledColor: ColorPalette.principal, //Ico
                            value: Constant.gender[0],
                            isExpanded: true,
                            items: Constant.gender.keys
                                .toList()
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: Constant.gender[e],
                                    child: Text(
                                      Constant.gender[e] ?? "",
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              userbd!.gender = v.toString();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorPalette.principal,
                              width: 1,
                              style: BorderStyle.none),
                        ),
                        child: SizedBox(
                          height: 52,
                          child: DropdownButton<String?>(
                            underline: Container(
                              height: 1,
                              color: ColorPalette.principal,
                            ),
                            hint: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (userbd != null && userbd!.maritalStatus != "")
                                    ? userbd!.maritalStatus
                                    : Constant.maritalStatus,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: ColorPalette.principal),
                              ),
                            ),
                            iconEnabledColor: ColorPalette.principal, //Ico
                            value: Constant.maritalState[0],
                            isExpanded: true,
                            items: Constant.maritalState.keys
                                .toList()
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: Constant.maritalState[e],
                                    child: Text(
                                      Constant.maritalState[e] ?? "",
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              // userbd!.gender = v.toString();
                              userbd!.maritalStatus = v.toString();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorPalette.principal,
                              width: 1,
                              style: BorderStyle.none),
                        ),
                        child: SizedBox(
                          height: 52,
                          child: DropdownButton<String?>(
                            key: const Key("styleLife"),
                            underline: Container(
                              height: 1,
                              color: ColorPalette.principal,
                            ),
                            hint: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (user != null && user!.styleLife != "")
                                    ? user!.styleLife
                                    : Constant.styleLive,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: ColorPalette.principal),
                              ),
                            ),
                            iconEnabledColor: ColorPalette.principal, //Ico
                            value: Constant.lifeStyle[0],
                            isExpanded: true,
                            items: Constant.lifeStyle.keys
                                .toList()
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: Constant.lifeStyle[e],
                                    child: Text(
                                      Constant.lifeStyle[e] ?? "",
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              // userbd!.gender = v.toString();
                              user!.styleLife = v.toString();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorPalette.principal,
                              width: 1,
                              style: BorderStyle.none),
                        ),
                        child: SizedBox(
                          height: 52,
                          child: DropdownButton<String?>(
                            key: const Key("age"),
                            underline: Container(
                              height: 1,
                              color: ColorPalette.principal,
                            ),
                            hint: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (user != null && user!.age != "")
                                    ? user!.age
                                    : Constant.age,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: ColorPalette.principal),
                              ),
                            ),
                            dropdownColor: Colors.brown,
                            iconEnabledColor: ColorPalette.principal, //Ico
                            value: ages[0],
                            isExpanded: true,
                            items: ages.keys
                                .toList()
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: ages[e],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        ages[e] ?? "",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: ColorPalette.principal),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              user!.age = v.toString();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorPalette.principal,
                              width: 1,
                              style: BorderStyle.none),
                        ),
                        child: SizedBox(
                          height: 52,
                          child: DropdownButton<String?>(
                            key: const Key("country"),
                            underline: Container(
                              height: 1,
                              color: ColorPalette.principal,
                            ),
                            dropdownColor: Colors.brown,
                            hint: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (user != null && user!.country != "")
                                    ? user!.country
                                    : selectCountry,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: ColorPalette.principal),
                              ),
                            ),
                            iconEnabledColor: ColorPalette.principal, //Ico
                            value: _country[indexCountry],
                            isExpanded: true,

                            items: _country
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: ColorPalette.principal),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              selectCountry = v!;
                              user?.country = v;
                              // user!.city = "";
                              // indexState = 0;
                              refreshContry();
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorPalette.principal,
                              width: 1,
                              style: BorderStyle.none),
                        ),
                        child: SizedBox(
                          height: 52,
                          child: DropdownButton<String?>(
                            key: const Key("city"),
                            underline: Container(
                              height: 1,
                              color: ColorPalette.principal,
                            ),
                            dropdownColor: Colors.brown,
                            hint: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    (user != null && user!.city != "")
                                        ? user!.city
                                        : selectState,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: ColorPalette.principal),
                                  ),
                                ),
                              ),
                            ),
                            iconEnabledColor: ColorPalette.principal, //Ico
                            value: _states[indexState],
                            isExpanded: true,

                            items: _states
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: ColorPalette.principal),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              user?.city = v.toString();
                              selectState = v!;
                              // selectOther = false;
                              // int index =
                              //     _states.indexWhere((item) => item == v);
                              // indexState = index;
                              SelectDropState();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 138,
                      child: Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shadowColor: MaterialStateProperty.all<Color>(
                              Colors.transparent,
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent,
                            ),
                          ),
                          onPressed: _submit,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(219, 177, 42, 1),
                              border: Border.all(
                                color: const Color.fromRGBO(219, 177, 42, 1),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            height: 42,
                            width: 138,
                            child: const Center(
                              child: Text(
                                'Guardar',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre(String name) {
    if (userbd != null) {
      name = userbd!.name;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Center(
        child: TextFormField(
          onChanged: (value) {
            user?.name = value;
          },
          style: const TextStyle(color: ColorPalette.principal),
          key: Key(name),
          initialValue: name,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.edit, color: ColorPalette.principal),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorPalette.principal),
              // borderRadius: BorderRadius.circular(100.0),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 1, color: ColorPalette.principal), //<-- SEE HERE
            ),
            hintStyle: const TextStyle(color: ColorPalette.principal),
            filled: true,
            hintText: name,
            labelText: Constant.nameUser,
            labelStyle: const TextStyle(color: ColorPalette.principal),
          ),
          onSaved: (value) => {
            user?.name = value!,
          },
          validator: (value) {
            return Constant.namePlaceholder;
          },
        ),
      ),
    );
  }

  Widget _lastName(String lastName) {
    if (userbd != null) {
      lastName = userbd!.lastname;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: TextFormField(
        onChanged: (valor) {
          user?.lastname = valor;
        },
        autofocus: false,
        key: Key(lastName),
        initialValue: userbd == null ? lastName : userbd?.lastname,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: userbd == null ? lastName : userbd?.lastname,
          labelText: Constant.lastName,
          suffixIcon: const Icon(Icons.edit, color: ColorPalette.principal),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorPalette.principal),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: ColorPalette.principal), //<-- SEE HERE
          ),
          hintStyle: const TextStyle(color: ColorPalette.principal),
          filled: true,
          labelStyle: const TextStyle(color: ColorPalette.principal),
        ),
        style: const TextStyle(color: ColorPalette.principal),
        onSaved: (value) => {
          user?.lastname = value!,
        },
      ),
    );
  }

  Widget _emailTxt(String email) {
    if (userbd != null) {
      email = userbd!.email;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: TextFormField(
        onChanged: (valor) {
          user?.lastname = valor;
        },
        autofocus: false,
        key: Key(email),
        initialValue: userbd == null ? email : userbd?.email,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: userbd == null ? email : userbd?.email,
          labelText: Constant.email,
          suffixIcon: const Icon(Icons.edit, color: ColorPalette.principal),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorPalette.principal),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: ColorPalette.principal), //<-- SEE HERE
          ),
          hintStyle: const TextStyle(color: ColorPalette.principal),
          filled: true,
          labelStyle: const TextStyle(color: ColorPalette.principal),
        ),
        style: const TextStyle(color: ColorPalette.principal),
        onSaved: (value) => {
          user?.lastname = value!,
        },
      ),
    );
  }

  Widget _telefono(String phone) {
    if (userbd != null) {
      phone = userbd!.telephone;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 3.0, right: 3.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (value) {
          user?.telephone = value;
        },
        key: Key(phone),
        initialValue: '+34$phone',
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: '+34$phone',
          labelText: Constant.telephone,
          suffixIcon: const Icon(Icons.edit, color: ColorPalette.principal),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorPalette.principal),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: ColorPalette.principal), //<-- SEE HERE
          ),
          hintStyle: const TextStyle(color: ColorPalette.principal),
          filled: true,
          labelStyle: const TextStyle(color: ColorPalette.principal),
        ),
        style: const TextStyle(color: ColorPalette.principal),
        onSaved: (value) => {
          user?.telephone = value!,
        },
        validator: (value) {
          return Constant.telephonePlaceholder;
        },
      ),
    );
  }

  void _submit() async {
    // Uint8List? bytes;
    // String img64 = "";
    // if (foto?.path != "") {
    //   bytes = foto?.readAsBytesSync();
    //   img64 = base64Encode(bytes!);
    // } else {
    //   img64 = userbd!.pathImage;
    // }

    UserBD person = UserBD(
        idUser: '0',
        name: user!.name,
        lastname: user!.lastname,
        email: user!.email,
        telephone: user!.telephone,
        gender: user!.gender,
        maritalStatus: user!.maritalStatus,
        styleLife: user!.styleLife,
        pathImage: userbd!.pathImage,
        age: user!.age.toString(),
        country: user!.country,
        city: user!.city);

    // if (userbd != null) {
    //   var update = await userVC.updateUserDate(context, person);

    //   if (update) {
    //     // ignore: use_build_context_synchronously
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => const UserRestPage()),
    //     );
    //     return;
    //   }
    // } else {
    bool a = await userVC.updateUserDate(context, person);

    if (a) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Informacion"),
              content: Text("Datos guardados".tr),
              actions: <Widget>[
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const UserRestPage()),
                    // );
                  },
                )
              ],
            );
          });
    }
  }
}

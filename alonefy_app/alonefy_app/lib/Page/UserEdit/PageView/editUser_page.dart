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
import 'package:ifeelefine/Page/UserEdit/Controller/editController.dart';

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
  final EditConfigController editVC = Get.put(EditConfigController());

  bool isCheck = false;
  late bool selectImage = false;
  final bool _guardado = false;
  User? user;
  // UserBD? userbd;
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
  List<String> _states = ["Seleccionar estado"];
  List<String> _country = ["Seleccionar pais"];
  final String _selectedCountry = "Choose Country";
  List<dynamic> countryres = [];
  List<dynamic> stateTemp = [];
  Map<String, String> ages = {};

  @override
  void initState() {
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
  }

  Future getUserData() async {
    user = await editVC.getUserDate();
    ages = await editVC.getAgeVC();
    if (user!.idUser != -1) {
      selectCountry = user!.country;
      selectState = user!.city;
    }
    _country = await editVC.getCounty();
    setState(() {});
  }

  Future SelectDropState() async {
    indexState = _states.indexWhere((item) => item == user!.city);
    print(indexState);
    if (indexState < 0) indexState = 0;
    selectState = _states[indexState];
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
                    genericTxt((user == null) ? "" : user!.name,
                        Constant.namePlaceholder, (value) {
                      user?.name = value;
                    }),
                    const SizedBox(height: 10),
                    genericTxt((user == null) ? "" : user!.lastname,
                        Constant.lastnamePlaceholder, (value) {
                      user?.lastname = value;
                    }),
                    const SizedBox(height: 10),
                    _telefono(""),
                    const SizedBox(height: 10),
                    genericTxt(
                        (user == null) ? "" : user!.email, Constant.email,
                        (value) {
                      user?.email = value;
                    }),
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
                                (user != null && user!.gender != "")
                                    ? user!.gender
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
                              user!.gender = v.toString();
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
                                (user != null && user!.maritalStatus != "")
                                    ? user!.maritalStatus
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
                              user!.maritalStatus = v.toString();
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
                                (user!.idUser != -1 && user!.country != "")
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
                            onChanged: (v) async {
                              selectCountry = v!;

                              user!.country = v;
                              await editVC.refreshContry();
                              final int index2 = _country.indexWhere(
                                  (country) => country.contains(v.toString()));
                              indexCountry = index2;
                              _states = await editVC.filterState();
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

  Widget genericTxt(
      String text, String labeltext, Function(String value) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: TextFormField(
        onChanged: (valor) {
          onChanged(valor);
        },
        autofocus: false,
        key: Key(text),
        initialValue: text,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: text,
          labelText: labeltext,
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
          onChanged(value!),
        },
      ),
    );
  }

  Widget _telefono(String phone) {
    if (user != null) {
      phone = user!.telephone;
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
    bool a = await editVC.updateUserDate(context, user!);

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
                  },
                )
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Informacion"),
              content: Text("Hubo un error".tr),
              actions: <Widget>[
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
}

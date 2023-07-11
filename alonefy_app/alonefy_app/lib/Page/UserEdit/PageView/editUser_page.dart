import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/button_style_custom.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Page/Onboarding/PageView/onboarding_page.dart';
import 'package:ifeelefine/Page/UserEdit/Controller/editController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

import 'package:country_state_city_picker/model/select_status_model.dart'
    as StatusModel;
import 'package:ifeelefine/Utils/Widgets/loading_page.dart';
import 'package:onboarding/onboarding.dart';

class UserEditPage extends StatefulWidget {
  const UserEditPage({super.key});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final EditConfigController editVC = Get.put(EditConfigController());

  bool isCheck = false;
  late bool selectImage = false;
  User? user;
  List<String> _states = ["Seleccionar estado"];
  List<String> _country = ["Seleccionar pais"];
  Map<String, String> ages = {};

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
  List<dynamic> countryres = [];
  List<dynamic> stateTemp = [];
  bool isloading = true;
  @override
  void initState() {
    user = initUser();

    super.initState();

    getUserData();
  }

  Future getUserData() async {
    user = await editVC.getUserDate();
    ages = await editVC.getAgeVC();
    _country = await getCounty();
    _states.addAll(await editVC.getState());

    indexCountry = _country.indexWhere((item) => item == user!.country);
    selectCountry = user!.country;
    selectState = user!.city;
    selectDropState();
  }

  Future getCounty() async {
    countryres = await getResponse() as List;
    for (var data in countryres) {
      var model = StatusModel.StatusModel();
      model.name = data['name'];
      model.emoji = data['emoji'];
      if (!mounted) continue;
      if (user!.country.contains(("${model.emoji!}  ${model.name!}"))) {
        stateTemp.add(data['state']);
      }
      setState(() {
        _country.add("${model.emoji!}  ${model.name!}");
      });
    }
    filterState();

    setState(() {});
    return _country;
  }

  Future filterState() async {
    _states.clear();
    _states.add('Seleccionar estado');
    for (var f in stateTemp) {
      if (!mounted) continue;
      f.forEach((data) {
        _states.add("${data['name']}");
      });
    }
    return _states;
  }

  Future updateStates() async {
    stateTemp.clear();
    for (var data in countryres) {
      var model = StatusModel.StatusModel();
      model.name = data['name'];
      model.emoji = data['emoji'];
      if (!mounted) continue;
      if (user!.country.contains(("${model.emoji!}  ${model.name!}"))) {
        stateTemp.add(data['state']);
      }
    }
    await filterState();
    selectDropState();
    setState(() {});
  }

  Future getResponse() async {
    var res = await rootBundle.loadString(
        'packages/country_state_city_picker/lib/assets/country.json');

    return jsonDecode(res);
  }

  void selectDropState() {
    indexState = _states.indexWhere((item) => item == user?.city);
    if (indexState < 0) indexState = 0;

    selectState = (indexState < 0) ? _states[0] : _states[indexState];
    isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      isLoading: isloading,
      child: Scaffold(
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
                                  selectCountry,
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
                                //await editVC.refreshContry();
                                final int index2 = _country.indexWhere(
                                    (country) =>
                                        country.contains(v.toString()));
                                indexCountry = index2;
                                //_states = await editVC.filterState();
                                updateStates();
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
                                      selectState,
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
                                selectDropState();
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          text: '',
                          children: <TextSpan>[
                            TextSpan(
                              onEnter: (event) {},
                              text: 'Darse de baja de la aplicación',
                              style: GoogleFonts.barlow(
                                fontSize: 16.0,
                                wordSpacing: 1,
                                letterSpacing: 0.001,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Información'),
                                      content:
                                          const Text('¿Desea darse de baja?'),
                                      actions: <Widget>[
                                        IconButton(
                                            icon: const Icon(
                                              Icons.cancel,
                                            ),
                                            tooltip: 'Cancelar',
                                            onPressed: () async {
                                              Navigator.of(context).pop(true);
                                            }),
                                        IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                            ),
                                            tooltip: 'Borrar',
                                            onPressed: () async {
                                              setState(() {
                                                Navigator.of(context).pop(true);
                                                isloading = true;
                                              });
                                              bool delete = await editVC
                                                  .deleteUser(user!);
                                              if (delete) {
                                                setState(() {
                                                  isloading = false;
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OnboardingPage()),
                                                  );
                                                });
                                              }
                                            }),
                                      ],
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 138,
                        child: Center(
                          child: ElevatedButton(
                            style: styleColorClear(),
                            onPressed: _submit,
                            child: Container(
                              decoration: buttonPrincipalColorRadius8(),
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
        initialValue: '$phone',
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: '+34',
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
    bool resp = await editVC.updateUserDate(context, user!);

    if (resp) {
      showSaveAlert(context, "Información", "Datos guardados".tr);
    } else {
      showSaveAlert(context, "Información", "Hubo un error".tr);
    }
  }
}

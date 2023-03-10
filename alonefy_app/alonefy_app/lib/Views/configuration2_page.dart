import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/UseMobil/PageView/configurationUseMobile_page.dart';
import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Utils/Widgets/CustomDropdownMaritalState.dart';
import 'package:ifeelefine/Utils/Widgets/CustomDropdownStylelive.dart';
import 'package:ifeelefine/Utils/Widgets/customDropDown.dart';
import 'package:ifeelefine/Utils/Widgets/datepickerwidget.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Views/protectuser_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_state_city_picker/model/select_status_model.dart'
    as StatusModel;
import 'package:uuid/uuid.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

// ignore: use_key_in_widget_constructors
class UserConfigPage2 extends StatefulWidget {
  @override
  State<UserConfigPage2> createState() => _UserConfigPageState2();
}

class _UserConfigPageState2 extends State<UserConfigPage2> {
  final UserConfigCOntroller userVC = Get.put(UserConfigCOntroller());

  User? user;
  UserBD? userbd;

  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _states = ["Seleccionar estado"];
  late String selectState = "";
  final List<String> _country = ["Seleccionar pais"];
  late String selectCountry = "";

  Map<String, String> ages = {};

  late String _title;
  late TimeOfDay _timeOfDay;
  // late Function _updateTimeFunction;

  @override
  void initState() {
    user = initUser();
    _timeOfDay = const TimeOfDay(hour: 00, minute: 00);
    super.initState();

    _getAge();
  }

  Future<Map<String, String>> _getAge() async {
    ages = getAge();
    getCounty();
    return ages;
  }

  List<dynamic> countryres = [];
  List<dynamic> stateTemp = [];
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
    setState(() {});
    return _country;
  }

  Future filterState() async {
    for (var f in stateTemp) {
      if (!mounted) continue;
      f.forEach((data) {
        _states.add("${data['name']}");
      });
    }
    setState(() {});
    return _states;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: decorationCustom(),
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: ListView(
          children: <Widget>[
            CustomDropdownMaritalState(
              instance: Constant.gender,
              mensaje: Constant.selectGender,
              isVisible: true,
              onChanged: (value) {
                user?.gender = value;
              },
            ),
            const SizedBox(height: 10),
            CustomDropdownMaritalState(
              instance: Constant.maritalState,
              mensaje: Constant.maritalStatus,
              isVisible: true,
              onChanged: (value) {
                user?.maritalStatus = value;
              },
            ),
            const SizedBox(height: 10),
            CustomDropdownStylelive(
              instance: Constant.lifeStyle,
              mensaje: Constant.styleLive,
              isVisible: true,
              onChanged: (value) {
                user?.styleLife = value;
              },
            ),
            const SizedBox(height: 10),
            CustomDropdownMaritalState(
              instance: ages,
              mensaje: Constant.age,
              isVisible: true,
              onChanged: (value) {
                user?.age = value;
              },
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorPalette.principal,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: SizedBox(
                  height: 52,
                  child: DropdownButton<String?>(
                    underline: Container(),
                    dropdownColor: Colors.brown,
                    hint: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Selecciona el pais",
                        style: GoogleFonts.barlow(
                          fontSize: 18.0,
                          wordSpacing: 1,
                          letterSpacing: 0.001,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    iconEnabledColor: ColorPalette.principal, //Ico
                    value: selectCountry.isEmpty ? _country[0] : selectCountry,
                    isExpanded: true,

                    items: _country
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                e,
                                style: GoogleFonts.barlow(
                                  fontSize: 18.0,
                                  wordSpacing: 1,
                                  letterSpacing: 0.001,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      selectCountry = v!;
                      user?.country = v;
                      for (var element in countryres) {
                        var model = StatusModel.StatusModel();
                        model.name = element['name'];
                        model.emoji = element['emoji'];
                        if (!mounted) return;

                        if (v.contains(("${model.emoji!}  ${model.name!}"))) {
                          stateTemp.add(element['state']);
                        }
                      }
                      filterState();
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
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: SizedBox(
                  height: 52,
                  child: DropdownButton<String?>(
                    underline: Container(),
                    dropdownColor: Colors.brown,
                    hint: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Selecciona la ciudad",
                        style: GoogleFonts.barlow(
                          fontSize: 16.0,
                          wordSpacing: 1,
                          letterSpacing: 0.001,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    iconEnabledColor: ColorPalette.principal, //Ico
                    value: selectState.isEmpty ? _states[0] : selectState,
                    isExpanded: true,

                    items: _states
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                e,
                                style: GoogleFonts.barlow(
                                  fontSize: 16.0,
                                  wordSpacing: 1,
                                  letterSpacing: 0.001,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      user?.city = v.toString();
                      selectState = v!;
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevateButtonCustomBorder(
                onChanged: ((value) {
                  _submit;
                }),
                mensaje: "Gratuito 30 dias"),
            const SizedBox(height: 20),
            _createButtonPremium(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  _createBottom(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.remove_red_eye_outlined),
      backgroundColor: ColorPalette.principal,
      onPressed: () {
        //createPlantFoodNotification();
        Navigator.pushNamed(context, "preview", arguments: null);
      },
    );
  }

  Widget _createButtonFree() {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.principal)),
      label: Text(
        "Gratuito 30 dias",
        style: GoogleFonts.barlow(
          fontSize: 18.0,
          wordSpacing: 1,
          letterSpacing: 1.2,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
      icon: const Icon(
        Icons.security,
      ),
      onPressed: _submit,
    );
  }

  Widget _createButtonPremium() {
    return ElevatedButton(
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
          gradient: linerGradientButtonFilling(),
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        height: 42,
        width: 200,
        child: Center(
          child: Text(
            "Protecci??n 360??",
            style: GoogleFonts.barlow(
              fontSize: 16.0,
              wordSpacing: 1,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    UserBD person = UserBD(
        idUser: '0',
        name: user!.name,
        lastname: user!.lastname,
        email: user!.email,
        telephone: user!.telephone,
        gender: user!.gender,
        maritalStatus: user!.maritalStatus,
        styleLife: user!.styleLife,
        pathImage: "",
        age: user!.age,
        country: user!.country,
        city: user!.city);

    bool a = await userVC.updateUserDate(context, person);

    //if (!formKey.currentState.validate()) return;
    //formKey.currentState.save();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserMobilePage()),
    );
  }
}

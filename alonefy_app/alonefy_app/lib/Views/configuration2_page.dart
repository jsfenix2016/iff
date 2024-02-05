import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/button_style_custom.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
import 'package:ifeelefine/Page/UseMobil/PageView/configurationUseMobile_page.dart';
import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Utils/Widgets/CustomDropdownMaritalState.dart';
import 'package:ifeelefine/Utils/Widgets/CustomDropdownStylelive.dart';

import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:country_state_city_picker/model/select_status_model.dart'
    as StatusModel;

import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/main.dart';

// ignore: use_key_in_widget_constructors
class UserConfigPage2 extends StatefulWidget {
  const UserConfigPage2({super.key, required this.userbd});
  final UserBD userbd;
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

  var premiumController = Get.put(PremiumController());

  @override
  void initState() {
    user = initUser();
    userbd = widget.userbd;
    super.initState();
    starTap();
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
      backgroundColor: Colors.black,
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: ListView(
            children: <Widget>[
              CustomDropdownMaritalState(
                instance: Constant.gender,
                mensaje: Constant.selectGender,
                isVisible: true,
                onChanged: (value) {
                  user?.gender =
                      value == "Prefiero no decir" ? "Otro/a" : value;
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
                      value:
                          selectCountry.isEmpty ? _country[0] : selectCountry,
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
                          Constant.selectCity,
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
                    requestSubscription();
                  }),
                  mensaje: "Gratuito 30 dias"),
              const SizedBox(height: 20),
              _createButtonPremium(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createButtonPremium() {
    return ElevatedButton(
      style: styleColorClear(),
      onPressed: requestSubscription,
      child: Container(
        decoration: BoxDecoration(
          gradient: linerGradientButtonFilling(),
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        height: 42,
        width: 200,
        child: Center(
          child: Text(
            "Protección 360º",
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

  void requestSubscription() {
    //premiumController.requestPurchaseByProductId(
    //    PremiumController.subscriptionId, responseSubscription());
  }

  Function responseSubscription() {
    return (bool response) => {if (response) _submit()};
  }

  void _submit() async {
    userbd!.age = user!.age;
    userbd!.city = user!.city;
    userbd!.styleLife = user!.styleLife;
    userbd!.maritalStatus = user!.maritalStatus;
    userbd!.gender = user!.gender;
    userbd!.country = user!.country;
    bool isupdate = await userVC.updateUserDate(context, userbd!);
    if (isupdate) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UseMobilePage(
                  userbd: userbd!,
                )),
      );
    }
    //if (!formKey.currentState.validate()) return;
    //formKey.currentState.save();
  }
}

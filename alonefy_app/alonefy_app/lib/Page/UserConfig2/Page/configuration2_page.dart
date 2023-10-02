import 'dart:async';

import 'package:flutter_countries/models/country.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/button_style_custom.dart';
import 'package:ifeelefine/Common/Firebase/firebaseManager.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/location_custom.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Page/UseMobil/PageView/configurationUseMobile_page.dart';

import 'package:ifeelefine/Page/UserConfig2/Controller/userConfig2Controller.dart';
import 'package:ifeelefine/Page/UserConfig2/Widgets/country_select.dart';
import 'package:ifeelefine/Page/UserConfig2/Widgets/stated_select.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/CustomDropdownMaritalState.dart';
import 'package:ifeelefine/Utils/Widgets/CustomDropdownStylelive.dart';

import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:country_state_city_picker/model/select_status_model.dart'
    as StatusModel;

import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/main.dart';

class UserConfigPage2 extends StatefulWidget {
  const UserConfigPage2({super.key, required this.userbd});
  final UserBD userbd;
  @override
  State<UserConfigPage2> createState() => _UserConfigPageState2();
}

class _UserConfigPageState2 extends State<UserConfigPage2> {
  final UserConfig2COntroller userConfigVC = Get.put(UserConfig2COntroller());

  User? user;
  UserBD? userbd;

  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _states = ["Seleccionar estado"];
  late String selectState = "";
  final List<String> _country = ["Seleccionar pais"];
  late String selectCountry = "";

  Map<String, String> ages = {};

  List<dynamic> countryres = [];
  List<dynamic> stateTemp = [];
  final PreferenceUser _prefs = PreferenceUser();
  @override
  void initState() {
    user = initUser();

    if (widget.userbd.idUser == "-1") {
      _getUserData();
    } else {
      userbd = widget.userbd;
    }

    _prefs.saveLastScreenRoute("config2");
    super.initState();
    contactList();
    _getAge();
    starTap();
  }

  Future<UserBD> _getUserData() async {
    userbd = await userConfigVC.getUserData();

    return userbd!;
  }

  void contactList() async {
    contactlist = await getContacts(context);
  }

  Future<Map<String, String>> _getAge() async {
    ages = getAge();
    getCounty();
    return ages;
  }

  Future getCounty() async {
    countryres = await getTraslateCountry();

    for (var data in countryres) {
      var model = StatusModel.StatusModel();

      model.name = data.translations!.es ?? data.name;
      model.emoji = data.emoji;
      if (!mounted) continue;
      setState(() {
        _country.add("${model.emoji!}  ${model.name!}");
      });
    }
    setState(() {});
    return _country;
  }

  void _showCountryListScreen(BuildContext context) async {
    String? selectedCountry = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryListScreen(
          countries: _country,
          onCountrySelected: (country) {
            setState(() {
              selectCountry = country;
              // Opcional: También puedes actualizar la variable user?.country aquí
              user?.country = selectCountry;
              for (var element in countryres) {
                var model = StatusModel.StatusModel();
                model.name = element.translations!.es ?? element.name;
                model.emoji = element.emoji;
                if (!mounted) return;

                if (selectCountry
                    .contains(("${model.emoji!}  ${model.name!}"))) {
                  stateTemp.clear();
                  getTraslateState(element);
                }
              }
            });
          },
        ),
      ),
    );

    if (selectedCountry != null) {
      setState(() {
        selectCountry = selectedCountry;
        // Opcional: También puedes actualizar la variable user?.country aquí
      });
    }
  }

  void _showStateListScreen(BuildContext context) async {
    String? selectedStateTemp = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatesListScreen(
          states: liststate.value.obs,
          onStatesSelected: (country) {
            setState(() {
              selectState = country;

              // Opcional: También puedes actualizar la variable user?.country aquí
              user?.city = selectState;
            });
          },
        ),
      ),
    );

    if (selectedStateTemp != null) {
      setState(() {
        selectState = selectedStateTemp;
        user?.city = selectState;

        // Opcional: También puedes actualizar la variable user?.country aquí
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    RedirectViewNotifier.setStoredContext(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: SizedBox.expand(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 34),
                    const WidgetLogoApp(),
                    SizedBox(height: 34),
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
                      instance: ages,
                      mensaje: Constant.age,
                      isVisible: true,
                      onChanged: (value) {
                        user?.age = value;
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

                    // LocationCustom(
                    //   title: "Coloca tu dirección",
                    //   isVisible: true,
                    //   onChange: (String value) {
                    //     print(value);
                    //     user?.country = value != '' ? value : '';
                    //     // userModel.localizacion = value != '' ? value : '';
                    //   },
                    // ),
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
                        child: GestureDetector(
                          onTap: () => _showCountryListScreen(context),
                          child: SizedBox(
                            width: 350,
                            height: 52,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 16, top: 14),
                              child: Text(
                                selectCountry.isEmpty
                                    ? "Selecciona el país"
                                    : selectCountry.obs.value,
                                style: textNormal16White(),
                              ),
                            ),
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
                        child: GestureDetector(
                          onTap: () => _showStateListScreen(context),
                          child: SizedBox(
                            width: 350,
                            height: 52,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 16, top: 14),
                              child: Text(
                                selectState.isEmpty
                                    ? "Selecciona la ciudad"
                                    : selectState,
                                style: textNormal16White(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const SizedBox(height: 20),
                    // ElevateButtonCustomBorder(
                    //     onChanged: ((value) {
                    //       // free(false);

                    //     }),
                    //     mensaje: "Gratuito 30 días"),
                    // const SizedBox(height: 20),
                    // _createButtonPremium(),
                    ElevatedButton(
                      style: styleColorClear(),
                      onPressed: (() {
                        _submit(false);
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          border: Border.all(color: ColorPalette.principal),
                        ),
                        height: 42,
                        width: 250,
                        child: Center(
                          child: Text(
                            "Prueba Premium gratis 30 días",
                            style: GoogleFonts.barlow(
                              fontSize: 16.0,
                              wordSpacing: 1,
                              letterSpacing: 0.005,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevateButtonCustomBorder(
                        onChanged: ((value) {
                          free(true);
                        }),
                        mensaje: "Continuar"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createButtonPremium() {
    return ElevatedButton(
      style: styleColorClear(),
      onPressed: () {
        _submit(false);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
          ),
          gradient: linerGradientButtonFilling(),
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        height: 42,
        width: 200,
        child: Center(
          child: Text(
            "Gratuito 30 días",
            style: textNormal16White(),
          ),
        ),
      ),
    );
  }

  void free(bool isFree) async {
    if (await updateUser()) {
      updateFirebaseToken();
      refreshMenu('config2');

      var premiumController = Get.put(PremiumController());
      premiumController.updatePremiumAPI(!isFree);
      _prefs.setUserFree = true;
      _prefs.setUserPremium = false;
      if (!isFree) {
        _prefs.setUserPremium = true;
        _prefs.setDayFree = DateTime.now().toString();
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UseMobilePage(userbd: userbd!),
        ),
      );
    }
  }

  Future<bool> updateUser() async {
    userbd!.age = user!.age;
    userbd!.city = user!.city;
    userbd!.styleLife = user!.styleLife;
    userbd!.maritalStatus = user!.maritalStatus;
    userbd!.gender = user!.gender;
    userbd!.country = user!.country;
    bool isupdate = await userConfigVC.updateUserDate(userbd!);

    return isupdate;
  }

  void _submit(bool isFreeTrial) async {
    if (await updateUser()) {
      updateFirebaseToken();
      _prefs.setUserPremium = true;
      List<String> addList = ["config2"];
      _prefs.setlistConfigPage = addList;

      Future.sync(
        () async => await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PremiumPage(
                isFreeTrial: false,
                img: 'Pantalla5.jpg',
                title: Constant.premiumTitle,
                subtitle: ''),
          ),
        ).then(
          (value) {
            if (value != null && value) {
              _prefs.setUserPremium = true;
              _prefs.setUserFree = false;
              var premiumController = Get.put(PremiumController());
              premiumController.updatePremiumAPI(true);

              Get.off(
                () => UseMobilePage(userbd: userbd!),
              );
            }
          },
        ),
      );
    }
  }
}

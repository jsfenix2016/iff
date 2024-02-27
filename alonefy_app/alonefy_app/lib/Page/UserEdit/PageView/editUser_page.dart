import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/button_style_custom.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Page/Onboarding/PageView/onboarding_page.dart';
import 'package:ifeelefine/Page/UserConfig2/Widgets/country_select.dart';
import 'package:ifeelefine/Page/UserConfig2/Widgets/stated_select.dart';
import 'package:ifeelefine/Page/UserEdit/Controller/editController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

import 'package:country_state_city_picker/model/select_status_model.dart'
    as StatusModel;
import 'package:ifeelefine/Utils/Widgets/loading_page.dart';
import 'package:ifeelefine/main.dart';

class UserEditPage extends StatefulWidget {
  const UserEditPage({super.key});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final EditConfigController editVC = Get.put(EditConfigController());
  final formKey = GlobalKey<FormState>();
  final formKeyName = GlobalKey<FormState>();
  final formKeyLastName = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  User? user;

  bool isloading = true;
  bool isCheck = false;
  late bool selectImage = false;
  late bool istrayed;
  late bool selectOther = false;

  List<String> _country = ["Seleccionar pais"];
  List<dynamic> countryres = [];
  List<dynamic> stateTemp = [];

  Map<String, String> ages = {};

  late Image imgNew;

  late File? foto = File("");

  late int indexState = 0;
  late int indexCountry = 0;

  late String selectState = "";
  late String selectCountry = "";

  @override
  void initState() {
    user = initUser();

    super.initState();
    starTap();
    getUserData();
  }

  Future getUserData() async {
    user = await editVC.getUserDate();
    ages = await editVC.getAgeVC();
    _country = await getCounty();
    // await getAllState();
    // _states.addAll(await editVC.getState());
    var country = user!.country.split(" ").last;
    try {
      indexCountry = _country.indexWhere((item) => item == country);
    } catch (e) {
      print(e);
    }
    // if (indexCountry == -1) {
    //   for (Country i in countryres.length) {
    //     if (countryres[i] == country) {}
    //   }
    //   indexCountry;
    // }
    selectCountry = user!.country;
    selectState = user!.city;

    if (indexCountry > 0)
      getTraslateState(countryres.isEmpty ? [] : countryres[indexCountry - 1]);
  }

  Future getCounty() async {
    // countryres = await getResponse() as List;
    countryres = await getTraslateCountry();

    for (var data in countryres) {
      var model = StatusModel.StatusModel();

      model.name =
          data.translations!.es == null ? data.name : data.translations!.es;
      model.emoji = data.emoji;
      if (!mounted) continue;
      setState(() {
        _country.add("${model.emoji!}  ${model.name!}");
      });
    }

    setState(() {
      isloading = false;
    });
    return _country;
  }

  void selectDropState() async {
    indexState = liststate.indexWhere((item) => item == user?.city);
    if (indexState < 0) indexState = 0;

    selectState = (indexState < 0) ? liststate[0] : liststate[indexState];
    getTraslateState(countryres.isEmpty ? [] : countryres[indexCountry - 1]);
    setState(() {
      isloading = false;
    });
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
                  setState(() {
                    stateTemp.clear();
                    selectState = "";
                    getTraslateState(element);
                  });
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      isLoading: isloading,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.brown,
          title: Text(
            "Editar perfil",
            style: textForTitleApp(),
          ),
        ),
        backgroundColor: Colors.black,
        key: scaffoldKey,
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Container(
              decoration: decorationCustom(),
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Text(
                      "V. 1.0.40",
                      style: textForTitleApp(),
                    ),
                    const SizedBox(height: 20),
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
                                dropdownColor: Colors.brown,
                                underline: Container(
                                  height: 1,
                                  color: ColorPalette.principal,
                                ),
                                hint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    (user != null && user!.gender != "")
                                        ? user!.gender == "Otro/a"
                                            ? "Prefiero no decir"
                                            : user!.gender
                                        : Constant.selectGender == "Otro/a"
                                            ? "Prefiero no decir"
                                            : user!.gender,
                                    style: textNormal16White(),
                                  ),
                                ),
                                iconEnabledColor: ColorPalette.principal, //Ico
                                value: Constant.gender[0],
                                isExpanded: true,
                                items: Constant.gender.keys
                                    .toList()
                                    .map(
                                      (e) => DropdownMenuItem<String>(
                                        value: Constant.gender[e] == "Otro/a"
                                            ? "Prefiero no decir"
                                            : Constant.gender[e],
                                        child: Text(
                                          Constant.gender[e] == "Otro/a"
                                              ? "Prefiero no decir"
                                              : Constant.gender[e] ?? "",
                                          style: textNormal16White(),
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
                                dropdownColor: Colors.brown,
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
                                    style: textNormal16White(),
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
                                          style: textNormal16White(),
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
                                dropdownColor: Colors.brown,
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
                                    style: textNormal16White(),
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
                                          style: textNormal16White(),
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
                                dropdownColor: Colors.brown,
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
                                    style: textNormal16White(),
                                  ),
                                ),

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
                                            style: textNormal16White(),
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
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: ColorPalette.principal,
                                  width: 1.0, // Grosor de la línea
                                ),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () => _showCountryListScreen(context),
                              child: SizedBox(
                                width: 350,
                                height: 52,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16, top: 12),
                                  child: Text(
                                    selectCountry.isEmpty
                                        ? "Selecciona el país"
                                        : selectCountry.tr,
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
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: ColorPalette.principal,
                                  width: 1.0, // Grosor de la línea
                                ),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () => _showStateListScreen(context),
                              child: SizedBox(
                                width: 350,
                                height: 52,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16, top: 12),
                                  child: Text(
                                    selectState.isEmpty
                                        ? Constant.selectCity
                                        : selectState,
                                    style: textNormal16White(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(Constant.info),
                                content: const Text('¿Desea darse de baja?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("Cancelar",
                                        style: textBold16Black()),
                                    onPressed: () => {
                                      Navigator.of(context).pop(true),
                                    },
                                  ),
                                  TextButton(
                                      child: Text("Confirmar",
                                          style: textBold16Black()),
                                      onPressed: () async {
                                        Navigator.of(context).pop(true);
                                        setState(() {
                                          isloading = true;
                                        });
                                        bool delete =
                                            await editVC.deleteUser(user!);
                                        if (delete) {
                                          isloading = false;

                                          setState(() {
                                            Get.offAll(OnboardingPage());
                                          });
                                        }
                                      }),
                                ],
                              ),
                            );
                          },
                          child: RichText(
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
                                ),
                              ],
                            ),
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
                                    Constant.saveBtn,
                                    style: TextStyle(
                                        color: Colors.black,
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
      ),
    );
  }

  Widget genericTxt(
      String text, String labeltext, Function(String value) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: TextFormField(
        cursorColor: Colors.white,
        onChanged: (valor) {
          onChanged(valor);
        },
        readOnly: labeltext.contains(Constant.email) ? true : false,
        autofocus: false,
        key: Key(text),
        initialValue: text,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          filled: false,
          hintText: text,
          labelText: labeltext,
          suffixIcon: labeltext.contains(Constant.email)
              ? null
              : const Icon(Icons.edit, color: ColorPalette.principal),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorPalette.principal),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: ColorPalette.principal), //<-- SEE HERE
          ),
          hintStyle: textNormal16White(),
          labelStyle: textNormal16White(),
        ),
        style: textNormal16White(),
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
        cursorColor: Colors.white,
        readOnly: true,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          user?.telephone = value;
        },
        key: Key(phone),
        initialValue: phone,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: '+34',
          labelText: Constant.telephone,
          // suffixIcon: const Icon(Icons.edit, color: ColorPalette.principal),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorPalette.principal),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: ColorPalette.principal), //<-- SEE HERE
          ),
          hintStyle: textNormal16White(),
          filled: false,
          labelStyle: textNormal16White(),
        ),
        style: textNormal16White(),
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

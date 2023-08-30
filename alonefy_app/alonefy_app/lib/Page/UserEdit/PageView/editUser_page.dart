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
    // await getAllState();
    // _states.addAll(await editVC.getState());

    indexCountry = _country.indexWhere((item) => item == user!.country);
    selectCountry = user!.country;
    selectState = user!.city;

    getTraslateState(countryres.isEmpty ? [] : countryres[indexCountry - 1]);
  }

  Future getCounty() async {
    // countryres = await getResponse() as List;
    countryres = await getTraslateCountry();

    for (var data in countryres) {
      var model = StatusModel.StatusModel();
      print(data.translations!.es == null ? data.name : data.translations!.es);
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
    indexState = liststate.value.indexWhere((item) => item == user?.city);
    if (indexState < 0) indexState = 0;

    selectState =
        (indexState < 0) ? liststate.value[0] : liststate.value[indexState];
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
    return LoadingIndicator(
      isLoading: isloading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text(
            "Editar perfil",
            style: textForTitleApp(),
          ),
        ),
        backgroundColor: Colors.transparent,
        key: scaffoldKey,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                              dropdownColor: Colors.brown,
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
                                      value: Constant.gender[e],
                                      child: Text(
                                        Constant.gender[e] ?? "",
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
                                      ? "Selecciona la ciudad"
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
                                              Navigator.of(context).pop(true);
                                              setState(() {
                                                isloading = true;
                                              });
                                              bool delete = await editVC
                                                  .deleteUser(user!);
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
        readOnly: labeltext.contains(Constant.email) ? true : false,
        autofocus: false,
        key: Key(text),
        initialValue: text,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
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
          filled: true,
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
        readOnly: true,
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
          // suffixIcon: const Icon(Icons.edit, color: ColorPalette.principal),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorPalette.principal),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: ColorPalette.principal), //<-- SEE HERE
          ),
          hintStyle: textNormal16White(),
          filled: true,
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

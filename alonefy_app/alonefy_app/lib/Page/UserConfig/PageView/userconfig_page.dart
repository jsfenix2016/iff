import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/UseMobil/PageView/configurationUseMobile_page.dart';
import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Utils/Widgets/CustomDropdownMaritalState.dart';
import 'package:ifeelefine/Utils/Widgets/CustomDropdownStylelive.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ifeelefine/Utils/Widgets/textFieldFormCustomBorder.dart';
import 'package:ifeelefine/Views/configuration2_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_state_city_picker/model/select_status_model.dart'
    as StatusModel;
import 'package:uuid/uuid.dart';

class UserConfigPage extends StatefulWidget {
  const UserConfigPage({super.key});

  @override
  State<UserConfigPage> createState() => _UserConfigPageState();
}

class _UserConfigPageState extends State<UserConfigPage> {
  final UserConfigCOntroller userVC = Get.put(UserConfigCOntroller());

  User? user;
  UserBD? userbd;
  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  var isValidEmail = false;
  var isValidSms = false;

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
        age: '',
        country: '',
        city: '');
    super.initState();

    isValidEmail = userVC.validateEmail.isFalse;
    isValidSms = userVC.validateSms.isFalse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: decorationCustom(),
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 30),
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 10),
                      TextFieldFormCustomBorder(
                        labelText: Constant.nameUser,
                        mesaje: "",
                        onChanged: (String value) {
                          user?.name = value;
                        },
                        placeholder: Constant.namePlaceholder,
                        typeInput: TextInputType.text,
                      ),
                      const SizedBox(height: 20),
                      TextFieldFormCustomBorder(
                        labelText: Constant.lastName,
                        mesaje: "",
                        onChanged: (String value) {
                          user?.lastname = value;
                        },
                        placeholder: Constant.lastName,
                        typeInput: TextInputType.text,
                      ),
                      const SizedBox(height: 20),
                      TextFieldFormCustomBorder(
                        labelText: Constant.telephone,
                        mesaje: "",
                        onChanged: (String value) {
                          user?.telephone = value;
                        },
                        placeholder: Constant.telephonePlaceholder,
                        typeInput: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      TextFieldFormCustomBorder(
                        labelText: Constant.email,
                        mesaje: "",
                        onChanged: (String value) {
                          user?.email = value;
                        },
                        placeholder: Constant.email,
                        typeInput: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
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
                            child: Container(
                              decoration: const BoxDecoration(
                                color: ColorPalette.principal,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                              ),
                              height: 42,
                              width: 227,
                              child: Center(
                                child: Text(
                                  'Enviar código de verificación',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.barlow(
                                    fontSize: 16.0,
                                    wordSpacing: 1,
                                    letterSpacing: 0.001,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              isValidSms = await userVC.validateSmsUser(context,
                                  int.parse(user!.telephone), user!.name);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _crearTxtCodigoMail("email", "",
                          'Introduce el código enviado a tu correo'),
                      const SizedBox(height: 20),
                      _crearTxtCodigoMail("Sms", "",
                          'Introduce el código enviado a tu teléfono'),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
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
                                color: Colors.transparent,
                                border: Border.all(
                                  color: ColorPalette.principal,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                              ),
                              height: 42,
                              width: 200,
                              child: Center(
                                child: Text(
                                  'Configurar',
                                  style: GoogleFonts.barlow(
                                    fontSize: 18.0,
                                    wordSpacing: 1,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
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
          ],
        ),
      ),
    );
  }

  Widget _crearTxtCodigoMail(String type, String code, String message) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 133,
              height: 50,
              child: Text(
                message,
                textAlign: TextAlign.right,
                style: GoogleFonts.barlow(
                  fontSize: 14.0,
                  wordSpacing: 1,
                  letterSpacing: 1,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 200,
              child: TextFormField(
                keyboardType: TextInputType.number,
                initialValue: code,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ColorPalette.principal),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: ColorPalette.principal), //<-- SEE HERE
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 18),
                  hintText: code,
                  labelText: "",
                  labelStyle:
                      const TextStyle(color: Colors.white, fontSize: 18),
                ),
                onSaved: (value) => value,
                validator: (value) {
                  return Constant.codeEmailPlaceholder;
                },
                onChanged: (value) async {
                  if (value.length == 6) {
                    if (type == "email") {
                      isValidEmail = await userVC.validateEmailUser(context);
                    } else {
                      isValidSms = await userVC.validateSmsUser(
                          context, int.parse(value), user!.name);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (isValidSms == false) {
      mostrarAlerta(context, 'Debe verificar su numero de telefono');
      return;
    }

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

    int a = await userVC.saveUserData(context, person, const Uuid().v1());

    if (a != -1) {
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserConfigPage2()),
                    );
                  },
                )
              ],
            );
          });
    }
  }
}

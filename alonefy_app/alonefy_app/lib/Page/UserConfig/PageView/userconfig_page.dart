import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ifeelefine/Utils/Widgets/textFieldFormCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';
import 'package:ifeelefine/Page/UserConfig2/Page/configuration2_page.dart';

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
    user = initUser();

    super.initState();
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
                      const WidgetLogoApp(),
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
                          user?.telephone = "+34$value";
                        },
                        placeholder: Constant.telephonePlaceholder,
                        typeInput: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      TextFieldFormCustomBorder(
                        labelText: Constant.email,
                        mesaje: "",
                        onChanged: (String value) {
                          user!.email = value;

                          //GetUtils.isEmail(value) ? "" : "";
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
                                  'Solicitar códigos de verificación',
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
                              await userVC.requestCode(context, user!);
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
                            onPressed: (isValidSms && isValidEmail)
                                ? _submit
                                : () {
                                    showAlert(context,
                                        "Debe tener el telefono e email validado para continuar.");
                                  },
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
              width: 120,
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
                  suffixIcon: const Text(
                    '*',
                    style: TextStyle(color: Colors.red, fontSize: 40),
                  ),
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
                style: GoogleFonts.barlow(
                    fontSize: 14.0,
                    wordSpacing: 1,
                    letterSpacing: 1,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
                onChanged: (value) async {
                  if (value.length < 6) {
                    return;
                  }
                  if (type == 'sms' && !validatePhoneNumber(user!.telephone)) {
                    showAlert(context, Constant.validatePhoneNumber);
                    return;
                  }

                  if (type == 'email' && !validateEmail(user!.email)) {
                    // El correo electrónico no es válido
                    showAlert(context, Constant.validateEmail);
                    return;
                  }

                  if (type == 'Sms') {
                    isValidSms = await userVC.validateCodeSMS(context, value);
                  }
                  if (type == 'email') {
                    isValidEmail =
                        await userVC.validateCodeEmail(context, value);
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
    if (!validatePhoneNumber(user!.telephone)) {
      // El número de teléfono no es inválido
      showAlert(context, Constant.validatePhoneNumber);
      return;
    }

    if (!validateEmail(user!.email)) {
      // El correo electrónico no es válido
      showAlert(context, Constant.validateEmail);
      return;
    }

    if (isValidSms && isValidEmail) {
      UserBD resp =
          await userVC.saveUserData(context, user!, const Uuid().v1());

      if (resp.idUser != "-1") {
        Future.delayed(const Duration(milliseconds: 10), () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(Constant.info),
                  content: Text("Datos guardados".tr),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Ok"),
                      onPressed: () {
                        print(resp);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserConfigPage2(
                                    userbd: resp,
                                  )),
                        );
                      },
                    )
                  ],
                );
              });
        });
      }
    }
  }

  void showAlert(BuildContext context, String mensaje) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Informacion "),
            content: Text(mensaje),
            actions: <Widget>[
              TextButton(
                child: const Text("Ok"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }
}

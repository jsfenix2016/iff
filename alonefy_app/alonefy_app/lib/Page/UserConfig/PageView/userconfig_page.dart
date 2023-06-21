import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/button_style_custom.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Page/UserConfig/Widget/txt_validated_token.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

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
  final _prefs = PreferenceUser();
  var isValidEmail = true;
  var isValidSms = false;
  bool isVisibilyEmail = false;
  @override
  void initState() {
    user = initUser();
    _prefs.saveLastScreenRoute("userConfig");
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline
                            .alphabetic, // Agrega este parámetro y proporciona un valor de TextBaseline
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                              flex: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 30,
                                  width: 60,
                                  child: TextField(
                                    style: textNormal20White(),
                                    enabled:
                                        false, // Establecer enabled en false para bloquear el TextField
                                    controller: TextEditingController(text: ""),
                                    // Opcionalmente, puedes establecer un valor inicial
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      hintText: "",
                                      labelText: "+34",
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: ColorPalette.principal),
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1,
                                            color: ColorPalette
                                                .principal), //<-- SEE HERE
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ),
                                      hintStyle: textNormal20White(),
                                      filled: true,
                                      labelStyle: textNormal20White(),
                                    ),
                                  ),
                                ),
                              )),
                          Flexible(
                            flex: 1,
                            child: TextFieldFormCustomBorder(
                              labelText: Constant.telephone,
                              mesaje: "",
                              onChanged: (String value) {
                                user?.telephone = '+34$value';
                              },
                              placeholder: Constant.telephonePlaceholder,
                              typeInput: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFieldFormCustomBorder(
                        labelText: Constant.email,
                        mesaje: "",
                        onChanged: (String value) {
                          user!.email = value;
                        },
                        placeholder: Constant.email,
                        typeInput: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: ElevatedButton(
                            style: styleColorClear(),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: ColorPalette.principal,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                              ),
                              height: 42,
                              width: 235,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2.0, right: 2),
                                  child: Text(
                                    Constant.tokenRequestTxt,
                                    textAlign: TextAlign.center,
                                    style: textNormal16Black(),
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (user!.telephone.isEmpty) {
                                return;
                              }

                              await userVC.requestCode(context, user!);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: isVisibilyEmail,
                        child: TextValidateToken(
                          type: "email",
                          code: "",
                          message: Constant.validateCodeEmail,
                          onChanged: (String value) async {
                            if (!validateEmail(user!.email)) {
                              // El correo electrónico no es válido
                              showSaveAlert(context, Constant.info,
                                  Constant.validateEmail);
                              return;
                            }

                            isValidEmail =
                                await userVC.validateCodeEmail(context, value);
                            (context as Element).markNeedsBuild();
                          },
                          isValid: isValidEmail,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextValidateToken(
                        type: "Sms",
                        code: "",
                        message: Constant.validateCodeSms,
                        onChanged: (String value) async {
                          if (!validatePhoneNumber(user!.telephone)) {
                            showSaveAlert(context, Constant.info,
                                Constant.validatePhoneNumber);
                            isValidSms = false;
                            (context as Element).markNeedsBuild();
                            return;
                          }

                          isValidSms =
                              await userVC.validateCodeSMS(context, value);
                          (context as Element).markNeedsBuild();
                        },
                        isValid: isValidSms,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: ElevatedButton(
                            style: styleColorClear(),
                            onPressed: (isValidSms || isValidEmail)
                                ? _submit
                                : () {
                                    showSaveAlert(context, Constant.info,
                                        Constant.alertMessageValidateUser);
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
                                  Constant.configurationbtn,
                                  style: textNomral18White(),
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

  void _submit() async {
    if (!validatePhoneNumber(user!.telephone)) {
      // El número de teléfono no es inválido
      showSaveAlert(context, Constant.info, Constant.validatePhoneNumber);
      return;
    }
    if (isVisibilyEmail) {
      if (!validateEmail(user!.email)) {
        // El correo electrónico no es válido
        showSaveAlert(context, Constant.info, Constant.validateEmail);
        return;
      }
    }

    if (isValidSms) {
      UserBD resp =
          await userVC.saveUserData(context, user!, const Uuid().v1());

      if (resp.idUser != "-1") {
        await Future.delayed(
          const Duration(milliseconds: 10),
          () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(Constant.info),
                  content: Text(Constant.saveData.tr),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(Constant.ok),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserConfigPage2(
                              userbd: resp,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
      }
    }
  }
}

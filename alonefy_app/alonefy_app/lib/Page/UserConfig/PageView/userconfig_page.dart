import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/button_style_custom.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Page/UserConfig/Controller/userConfigController.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Page/UserConfig/Widget/txt_validated_token.dart';

import 'package:ifeelefine/Utils/Widgets/textFieldFormCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';
import 'package:ifeelefine/Page/UserConfig2/Page/configuration2_page.dart';
import 'package:ifeelefine/main.dart';

import 'package:uuid/uuid.dart';

class UserConfigPage extends StatefulWidget {
  const UserConfigPage({super.key, required this.isMenu});
  final bool isMenu;
  @override
  State<UserConfigPage> createState() => _UserConfigPageState();
}

class _UserConfigPageState extends State<UserConfigPage> {
  final UserConfigCOntroller userVC = Get.put(UserConfigCOntroller());

  User? userlocal;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var isValidEmail = false;
  var isValidSms = false;

  bool isVisibilyEmail = true;
  bool sendtoken = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RedirectViewNotifier.setStoredContext(context);
    });
    userlocal = initUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          height: size.height,
          width: size.width,
          decoration: decorationCustom(),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 30),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const WidgetLogoApp(),
                            const SizedBox(height: 10),
                            TextFieldFormCustomBorder(
                              labelText: Constant.nameUser,
                              mesaje: "",
                              onChanged: (String value) {
                                userlocal?.name = value;
                              },
                              placeholder: Constant.namePlaceholder,
                              typeInput: TextInputType.text,
                            ),
                            const SizedBox(height: 20),
                            TextFieldFormCustomBorder(
                              labelText: Constant.lastName,
                              mesaje: "",
                              onChanged: (String value) {
                                userlocal?.lastname = value;
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
                                  flex: 1,
                                  child: TextFieldFormCustomBorder(
                                    labelText: Constant.telephone,
                                    mesaje: "",
                                    onChanged: (String value) {
                                      userlocal?.telephone = '+34$value';
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
                                userlocal!.email = value;
                              },
                              placeholder: Constant.email,
                              typeInput: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              child: Center(
                                child: ElevatedButton(
                                  style: styleColorClear(),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: ColorPalette.principal,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                    ),
                                    width: 235,
                                    height: 45,
                                    child: Text(
                                      sendtoken
                                          ? Constant.tokenRequestSendAgainTxt
                                          : Constant.tokenRequestTxt,
                                      textAlign: TextAlign.center,
                                      style: textNormal16Black(),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (!validatePhoneNumber(
                                            userlocal!.telephone) ||
                                        userlocal!.telephone.length > 12 ||
                                        userlocal!.telephone.isEmpty) {
                                      showSaveAlert(context, Constant.info,
                                          Constant.validatePhoneNumber);

                                      return;
                                    }

                                    if (!validateEmail(userlocal!.email)) {
                                      // El correo electrónico no es válido
                                      showSaveAlert(context, Constant.info,
                                          Constant.validateEmail);
                                      return;
                                    }

                                    await userVC.requestCode(
                                        context, userlocal!);
                                    sendtoken = true;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextValidateToken(
                              type: "Sms",
                              code: "",
                              message: Constant.validateCodeSms,
                              onChanged: (String value) async {
                                if (!validatePhoneNumber(
                                    userlocal!.telephone)) {
                                  showSaveAlert(context, Constant.info,
                                      Constant.validatePhoneNumber);
                                  isValidSms = false;
                                  FocusScope.of(context).unfocus();
                                  return;
                                }
                                if (value.length < 6 || value.length > 7) {
                                  isValidSms = false;
                                } else {
                                  isValidSms = await userVC.validateCodeSMS(
                                      context, value);
                                }
                                if (isValidSms) {
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              isValid: isValidSms,
                            ),
                            const SizedBox(height: 20),
                            Visibility(
                              visible: true,
                              child: TextValidateToken(
                                type: "email",
                                code: "",
                                message: Constant.validateCodeEmail,
                                onChanged: (String value) async {
                                  if (!validateEmail(userlocal!.email)) {
                                    isValidEmail = false;
                                    // El correo electrónico no es válido
                                    showSaveAlert(context, Constant.info,
                                        Constant.validateEmail);
                                    FocusScope.of(context).unfocus();
                                    return;
                                  }
                                  if (value.length < 6 || value.length > 7) {
                                    isValidEmail = false;
                                  } else {
                                    isValidEmail = await userVC
                                        .validateCodeEmail(context, value);
                                  }

                                  if (isValidEmail) {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                isValid: isValidEmail,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: ElevatedButton(
                                  style: styleColorClear(),
                                  onPressed: (isValidEmail || isValidSms)
                                      ? _submit
                                      : () {
                                          showSaveAlert(context, Constant.info,
                                              "Debe tener validado los tokens del correo y teléfono");
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
                                        Constant.continueTxt,
                                        style: GoogleFonts.barlow(
                                          fontSize: 16.0,
                                          wordSpacing: 1,
                                          letterSpacing: 0.001,
                                          fontWeight: FontWeight.w700,
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if ((userlocal!.name.isEmpty || userlocal!.lastname.isEmpty)) {
      // El número de teléfono no es inválido
      showSaveAlert(context, Constant.info, "No puede haber campos vacios");
      return;
    }

    if (!validatePhoneNumber(userlocal!.telephone)) {
      // El número de teléfono no es inválido
      showSaveAlert(context, Constant.info, Constant.validatePhoneNumber);
      return;
    }
    if (!validateEmail(userlocal!.email)) {
      isValidEmail = false;
      // El correo electrónico no es válido
      showSaveAlert(context, Constant.info, Constant.validateEmail);
      return;
    }

    UserBD resp = await userVC.saveUserData(userlocal!, const Uuid().v1());

    if (resp.idUser != "-1") {
      user = resp;
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
                      Get.offAll(
                        () => UserConfigPage2(
                          userbd: resp,
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

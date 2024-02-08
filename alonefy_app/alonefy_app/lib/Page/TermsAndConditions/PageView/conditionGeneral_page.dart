import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/button_style_custom.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Page/PermissionUser/Controller/permission_controller.dart';
import 'package:ifeelefine/Page/TermsAndConditions/Controller/terms_conditionController.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/TermsAndConditions/PageView/webview_terms_conditions.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';

import '../../../Common/colorsPalette.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class ConditionGeneralPage extends StatefulWidget {
  const ConditionGeneralPage({super.key});

  @override
  State<ConditionGeneralPage> createState() => _ConditionGeneralPageState();
}

class _ConditionGeneralPageState extends State<ConditionGeneralPage> {
  final TermsAndConditionsController termsVC =
      Get.put(TermsAndConditionsController());
  final _prefs = PreferenceUser();
  bool aceptedConditions = false;
  bool aceptedSendMessage = false;
  bool sawTerms = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    RedirectViewNotifier.setStoredContext(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    const SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 36,
                          ),
                          WidgetLogoApp(),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Acepto las condiciones generales',
                                      textAlign: TextAlign.right,
                                      style: textNomral18White(),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Transform.scale(
                                        scale: 0.8,
                                        child: CupertinoSwitch(
                                          value: aceptedConditions,
                                          activeColor:
                                              ColorPalette.activeSwitch,
                                          trackColor:
                                              CupertinoColors.inactiveGray,
                                          onChanged: (bool? value) {
                                            setState(
                                              () {
                                                aceptedConditions = value!;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 14, left: 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        'Acepto envío de whatsapp SMS y llamadas en caso de interpretar AlertFriends que pueda estar en riesgo ',
                                        textAlign: TextAlign.right,
                                        style: textNomral18White(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Transform.scale(
                                          scale: 0.8,
                                          child: CupertinoSwitch(
                                            value: aceptedSendMessage,
                                            activeColor:
                                                ColorPalette.activeSwitch,
                                            trackColor:
                                                CupertinoColors.inactiveGray,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                aceptedSendMessage = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Container(
                              width: 314,
                              height: 254,
                              padding:
                                  const EdgeInsets.fromLTRB(12, 40, 12, 18),
                              decoration: BoxDecoration(
                                  color: ColorPalette.backgroundDarkGrey,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          text:
                                              '''Diecisiete Digital actúa como responsable de tratamiento de los datos personales de los usuarios.\n\nPara mayor información por favor, lea las condiciones de uso en el siguiente enlace.\n\n''',
                                          style: textNormal16White(),
                                          children: <TextSpan>[
                                            TextSpan(
                                              onEnter: (event) {},
                                              text:
                                                  'https://alertfriends.app/politica_privacidad/',
                                              style: GoogleFonts.barlow(
                                                fontSize: 16.0,
                                                wordSpacing: 1,
                                                letterSpacing: 0.001,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {
                                                  // Abrir WebView
                                                  // Aquí puedes usar una navegación o abrir una URL en un WebView
                                                  sawTerms =
                                                      await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const WebViewTermsConditions(),
                                                    ),
                                                  );
                                                  if (sawTerms) {
                                                    setState(() {});
                                                  }
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: ElevatedButton(
                                      style: styleColorClear(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: (aceptedConditions &&
                                                  aceptedSendMessage &&
                                                  sawTerms)
                                              ? ColorPalette.principal
                                              : Colors.transparent,
                                          border: Border.all(
                                              color: ColorPalette.secondView,
                                              width: 2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(100)),
                                        ),
                                        height: 50,
                                        width: (aceptedConditions &&
                                                aceptedSendMessage &&
                                                sawTerms)
                                            ? 320
                                            : 200,
                                        child: Center(
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            (aceptedConditions &&
                                                    aceptedSendMessage &&
                                                    sawTerms)
                                                ? 'He leido y aceptado la politica de privacidad'
                                                : Constant.continueTxt,
                                            style: (aceptedConditions &&
                                                    aceptedSendMessage &&
                                                    sawTerms)
                                                ? textNormal16Black()
                                                : textNormal16White(),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (aceptedConditions &&
                                            aceptedSendMessage &&
                                            sawTerms) {
                                          PermissionController()
                                              .saveNotification();
                                          termsVC.saveConditions(
                                              context,
                                              aceptedConditions,
                                              aceptedSendMessage);
                                        } else {
                                          if (!sawTerms ||
                                              !aceptedSendMessage ||
                                              !aceptedConditions) {
                                            showSaveAlert(
                                                context,
                                                Constant.info,
                                                'Debe leer y aceptar las condiciones de uso y el envio de mensajes para continuar');
                                            return;
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/button_style_custom.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Page/PermissionUser/Controller/permission_controller.dart';
import 'package:ifeelefine/Page/TermsAndConditions/Controller/terms_conditionController.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/TermsAndConditions/PageView/webview_terms_conditions.dart';

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
  bool aceptedConditions = false;
  bool aceptedSendMessage = false;
  bool sawTerms = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        WidgetLogoApp(),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
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
                                        activeColor: ColorPalette.activeSwitch,
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
                            padding: const EdgeInsets.only(top: 24),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Acepto envío de SMS y llamadas en caso de interpretar AlertFriends que pueda estar en riesgo ',
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
                            width: 304,
                            height: 274,
                            padding: const EdgeInsets.fromLTRB(12, 40, 12, 18),
                            decoration: BoxDecoration(
                                color: ColorPalette.backgroundDarkGrey,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                        text:
                                            '''Política de privacidad\n\n1. Introducción\n\n Diecisiete Digital es el titular del sitio web https://alertfriends.app/es/ (en adelante, el “Portal”) y actúa como responsable de tratamiento de los datos personales de los usuarios (“Usuario/s”) que acceden y usan el Portal.\n\nMediante la presente Política de Privacidad, y en cumplimiento del Reglamento (UE) 2016/679 (“RGPD”)  y Ley  Orgánica  3/2018,  de  5 de  diciembre,  de  Protección  de  Datos  Personales  y garantía de los derechos digitales (“LOPDPGDD”), Diecisiete Digital informa a los Usuarios que se registren y/o hagan uso del Portal, de los tratamientos  de aquellos datos personales  que puedan ser recabados a través del Portal y tratados por Diecisiete Digital, con el fin de que los Usuarios decidan, libre y voluntariamente, si desean facilitar la información solicitada.\n\n''',
                                        style: textNormal16White(),
                                        children: <TextSpan>[
                                          TextSpan(
                                            onEnter: (event) {},
                                            text:
                                                'Antes de continuar lee los términos y condiciones: https://alertfriends.app/politica_privacidad/',
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
                                                sawTerms = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const WebViewTermsConditions(),
                                                  ),
                                                );
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
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color: ColorPalette.secondView,
                                            width: 2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100)),
                                      ),
                                      height: 42,
                                      width: 200,
                                      child: Center(
                                        child: Text(
                                          Constant.continueTxt,
                                          style: textNormal16White(),
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
                                        showSaveAlert(context, Constant.info,
                                            'Para continuar debe aceptar las condiciones y el permiso de envío de mensajes y llamadas.');
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
    );
  }
}

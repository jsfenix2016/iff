import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/button_style_custom.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Page/TermsAndConditions/Controller/terms_conditionController.dart';
import 'package:flutter/material.dart';
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
                                        'Acepto las condiciones generales *',
                                        textAlign: TextAlign.right,
                                        style: textNomral18White(),
                                      )),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 16),
                                            child: Transform.scale(
                                              scale: 0.8,
                                              child: CupertinoSwitch(
                                                value: aceptedConditions,
                                                activeColor:
                                                    ColorPalette.activeSwitch,
                                                trackColor: CupertinoColors
                                                    .inactiveGray,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    aceptedConditions = value!;
                                                  });
                                                },
                                              ),
                                            ))))
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        'Acepto envío de SMS y llamadas en caso de interpretar I’m Fine que pueda estar en riesgo ',
                                        textAlign: TextAlign.right,
                                        style: textNomral18White(),
                                      )),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 16),
                                            child: Transform.scale(
                                              scale: 0.8,
                                              child: CupertinoSwitch(
                                                value: aceptedSendMessage,
                                                activeColor:
                                                    ColorPalette.activeSwitch,
                                                trackColor: CupertinoColors
                                                    .inactiveGray,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    aceptedSendMessage = value!;
                                                  });
                                                },
                                              ),
                                            ))))
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Container(
                                width: 304,
                                height: 274,
                                padding:
                                    const EdgeInsets.fromLTRB(12, 40, 12, 18),
                                decoration: BoxDecoration(
                                    color: ColorPalette.backgroundDarkGrey,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection:
                                            Axis.vertical, //.horizontal
                                        child: Text(
                                          'I’m Fine, como responsable del tratamiento, realizará el tratamiento de sus datos para la gestión.',
                                          style: textNormal16White(),
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
                                            borderRadius:
                                                const BorderRadius.all(
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
                                              aceptedSendMessage) {
                                            termsVC.saveConditions(
                                                context,
                                                aceptedConditions,
                                                aceptedSendMessage);
                                          } else {
                                            showSaveAlert(
                                                context,
                                                Constant.info,
                                                'Para continuar debe aceptar las condiciones y el permiso de envio de mesnajes y llamadas.');
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ))),
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

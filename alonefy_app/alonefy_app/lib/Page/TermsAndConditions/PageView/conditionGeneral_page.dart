import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/TermsAndConditions/Controller/terms_conditionController.dart';
import 'package:flutter/material.dart';

import '../../../Common/colorsPalette.dart';

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
                    child: Container(
                      height: 50.0,
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        'Acepto las condiciones generales *',
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.barlow(
                                          fontSize: 18.0,
                                          wordSpacing: 1,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      )),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                            padding: EdgeInsets.only(left: 16),
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
                                        style: GoogleFonts.barlow(
                                          fontSize: 18.0,
                                          wordSpacing: 1,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
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
                                    const Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection:
                                            Axis.vertical, //.horizontal
                                        child: Text(
                                          'I’m Fine, como responsable del tratamiento, realizará el tratamiento de sus datos para la gestión.',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          shadowColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.transparent,
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.transparent,
                                          ),
                                        ),
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
                                          child: const Center(
                                            child: Text(
                                              Constant.continueTxt,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
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
                                            showAlert(context,
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

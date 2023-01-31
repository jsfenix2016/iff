import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/TermsAndConditions/Controller/terms_conditionController.dart';
import 'package:ifeelefine/Views/finishConfig_page.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:flutter/material.dart';

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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment(0, 1),
            colors: <Color>[
              Color.fromRGBO(21, 14, 3, 1),
              Color.fromRGBO(115, 75, 24, 1),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
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
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            width: 311,
                            height: 98,
                            color: const Color.fromRGBO(169, 146, 125, 0.5),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'I’m Fine, como responsable del tratamiento, realizará el tratamiento de sus datos para la gestión.',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.barlow(
                                    fontSize: 16.0,
                                    wordSpacing: 1,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Add the image here

                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 5),
                          child: SwitchListTile(
                            title: Text(
                              'Acepto las condiciones generales *',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.barlow(
                                fontSize: 16.0,
                                wordSpacing: 1,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            value: aceptedConditions,
                            onChanged: ((value) async {
                              aceptedConditions = value;
                              setState(() {});
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 5),
                          child: SwitchListTile(
                            title: Text(
                              'Acepto envío de SMS y llamadas en caso de interpretar I’m Fine que pueda estar en riesgo ',
                              style: GoogleFonts.barlow(
                                fontSize: 16.0,
                                wordSpacing: 1,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            value: aceptedSendMessage,
                            onChanged: ((value) async {
                              aceptedSendMessage = value;
                              setState(() {});
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 30,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
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
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: const Color.fromRGBO(219, 177, 42, 1),
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                    ),
                    height: 42,
                    width: 200,
                    child: const Center(
                      child: Text(
                        Constant.continueTxt,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (aceptedConditions && aceptedSendMessage) {
                      termsVC.saveConditions(
                          context, aceptedConditions, aceptedSendMessage);
                    } else {
                      mostrarAlerta(context,
                          'Para continuar debe aceptar las condiciones y el permiso de envio de mesnajes y llamadas.');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

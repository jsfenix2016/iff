import 'dart:async';

import 'package:get/get.dart';

import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';

import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/contentCode.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Services/mainService.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/loading_page.dart';
import 'package:ifeelefine/main.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class CancelDatePage extends StatefulWidget {
  const CancelDatePage(
      {super.key, required this.contactRisk, required this.taskIds});

  final ContactRiskBD contactRisk;
  final List<String> taskIds;
  // final String timefinish;
  // final Timer useMobil;
  @override
  State<CancelDatePage> createState() => _CancelDatePageState();
}

class _CancelDatePageState extends State<CancelDatePage> {
  EditRiskController editVC = Get.put(EditRiskController());
  RiskController riskVC = Get.put(RiskController());
  // String timeinit = "00:05";
  String codeTemp = '';
  var code = CodeModel();
  late ContactRiskBD contactRiskTemp;

  int _secondsRemaining = 60; //5 minutes = 300 seconds
  Timer? _timer;
  bool isLoading = false;

  @override
  void dispose() {
    stopTimer();

    super.dispose();
  }

  @override
  void initState() {
    contactRiskTemp = widget.contactRisk;

    startTimer();
    super.initState();
    starTap();
  }

  void saveDate(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    if (widget.contactRisk.code == codeTemp) {
      contactRiskTemp.isActived = false;
      contactRiskTemp.isprogrammed = false;
      contactRiskTemp.code = "";
      // contactRiskTemp.timefinish = '00:00';
      // contactRiskTemp.timeinit = '00:00';

      bool res = false;
      if (contactRiskTemp.taskIds != null &&
          contactRiskTemp.taskIds!.isNotEmpty) {
        MainService().cancelAllNotifications(contactRiskTemp.taskIds!);
      } else if (widget.taskIds.isNotEmpty) {
        MainService().cancelAllNotifications(widget.taskIds);
      }
      if (contactRiskTemp.saveContact == false) {
        res = await editVC.deleteContactRisk(context, contactRiskTemp);
      } else {
        res = await editVC.updateContactRisk(context, contactRiskTemp);
      }

      if (res) {
        setState(() {
          isLoading = false;
        });
        riskVC.update();
        stopTimer();
        timerSendSMS.cancel();
      }
    }
    setState(() {
      riskVC.update();
      Navigator.of(context).pop();
    });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = null;
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_secondsRemaining < 1) {
            timer.cancel();
          } else {
            _secondsRemaining -= 1;
          }
        },
      ),
    );
  }

  String get timerText {
    int minutes = (_secondsRemaining ~/ 60);
    int seconds = (_secondsRemaining % 60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return LoadingIndicator(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text(
            "Finalizar cita",
            style: textForTitleApp(),
          ),
        ),
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
            height: size.height,
            decoration: decorationCustom(),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Stack(
                children: [
                  SafeArea(
                    child: Container(
                      height: 20.0,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25.0, left: 8, right: 8),
                          child: Center(
                            child: Text(
                              "La hora programada para la finalización de tu cita de riesgo ha terminado",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.barlow(
                                fontSize: 24.0,
                                wordSpacing: 1,
                                letterSpacing: 1,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 20, right: 8),
                                  child: Text(
                                    "Introduce tú clave de cancelación",
                                    textAlign: TextAlign.center,
                                    style: textNomral18White(),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        ContentCode(
                          code: code,
                          onChanged: (value) {
                            code = value;
                            codeTemp =
                                '${value.textCode1},${value.textCode2},${value.textCode3},${value.textCode4}';
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevateButtonFilling(
                            showIcon: false,
                            onChanged: (value) {
                              saveDate(context);
                            },
                            mensaje: 'Cancelar alerta',
                            img: '',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              timerText,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.barlow(
                                fontSize: 74.0,
                                wordSpacing: 1,
                                letterSpacing: 1,
                                fontWeight: FontWeight.normal,
                                color: ColorPalette.principal,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              "Aunque se apague el smartphone, el servidor de AlertFriends ha registrado tu última ubicación y emitirá una alerta a tu contacto",
                              textAlign: TextAlign.center,
                              style: textNormal14White(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

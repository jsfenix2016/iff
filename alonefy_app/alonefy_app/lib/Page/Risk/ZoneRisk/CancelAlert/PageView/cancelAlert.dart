import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/PageView/riskDatePage.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/contentCode.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/popUpContact.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/PageView/zoneRisk.dart';
import 'package:ifeelefine/Services/mainService.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class CancelAlertPage extends StatefulWidget {
  const CancelAlertPage(
      {super.key, required this.contactRisk, required this.taskdIds});

  final ContactZoneRiskBD contactRisk;
  final List<String> taskdIds;
  // final String timefinish;
  // final Timer useMobil;
  @override
  State<CancelAlertPage> createState() => _CancelAlertState();
}

class _CancelAlertState extends State<CancelAlertPage> {
  String timeinit = "00:05";
  String codeTemp = '';
  var code = CodeModel();

  int _secondsRemaining = 180; //5 minutes = 300 seconds
  Timer? _timer;

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  void initState() {
    List<String> parts = [];
    if (widget.contactRisk.code != "") {
      parts = widget.contactRisk.code.split(',');

      code.textCode1 = parts[0];
      code.textCode2 = parts[1];
      code.textCode3 = parts[2];
      code.textCode4 = parts[3];
    }
    code.textCode1 = '';
    code.textCode2 = '';
    code.textCode3 = '';
    code.textCode4 = '';

    startTimer();
    super.initState();
  }

  void saveDate(BuildContext context) async {
    if (widget.contactRisk.code == codeTemp) {
      if (widget.taskdIds != null && widget.taskdIds.isNotEmpty) {
        MainService().cancelAllNotifications(widget.taskdIds);
      }
      NotificationCenter().notify('getContactZoneRisk');
      stopTimer();
      timerSendSMS.cancel();
      Route route = MaterialPageRoute(
        builder: (context) => const ZoneRiskPage(),
      );
      Navigator.of(context).pop();
    } else {
      showSaveAlert(context, Constant.info, Constant.codeError);
    }
  }

  void stopTimer() {
    _timer!.cancel();
    // _timer = null;
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_secondsRemaining < 1) {
            timer.cancel();
            showSaveAlert(context, Constant.info,
                "El servidor de AlertFriends envío una alerta con tu última ubicación.");
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
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
                            top: 85.0, left: 12, right: 12),
                        child: Center(
                          child: Text(
                            "AlertFriends ha activado una alerta en el servidor y se ejecutará en: ",
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
                                  style: GoogleFonts.barlow(
                                    fontSize: 18.0,
                                    wordSpacing: 1,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
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
                      SizedBox(
                        child: Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 27.0, top: 20, right: 27),
                                child: Text(
                                  "Si no cancelas, el servidor de AlertFriends enviará una alerta con tu última ubicación.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.barlow(
                                    fontSize: 18.0,
                                    wordSpacing: 1,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            "Aunque se apague el smartphone, el servidor de AlertFriends ha registrado tu última ubicación y emitirá una alerta a tu contacto",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(
                              fontSize: 14.0,
                              wordSpacing: 1,
                              letterSpacing: 1,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
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
    );
  }
}

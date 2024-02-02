import 'dart:async';

import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Page/Disamble/Controller/disambleController.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/contentCode.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/Controller/listContactZoneController.dart';

import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Services/mainService.dart';

import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class CancelAlertPage extends StatefulWidget {
  const CancelAlertPage({super.key, required this.taskIds});

  final List<String> taskIds;
  // final Timer useMobil;
  @override
  State<CancelAlertPage> createState() => _CancelAlertState();
}

class _CancelAlertState extends State<CancelAlertPage> {
  ListContactZoneController riskVC = ListContactZoneController();

  String codeTemp = '';
  var code = CodeModel();
  ContactZoneRiskBD? contactSelect;
  final PreferenceUser _prefs = PreferenceUser();
  @override
  void dispose() {
    super.dispose();
    secondsRemaining = prefs.getTimerCancelZone;
  }

  @override
  void initState() {
    _prefs.saveLastScreenRoute("cancelZone");
    getcontactRisk();
    startTimer();
    starTap();
    secondsRemaining = prefs.getTimerCancelZone;
    super.initState();
  }

  void getcontactRisk() async {
    await _prefs.initPrefs();
    var resp = await riskVC.getContactsZoneRisk();
    int indexSelect =
        resp.indexWhere((item) => item.id == _prefs.getIsSelectContactRisk);
    contactSelect = resp[indexSelect];

    List<String> parts = [];

    if (contactSelect!.code != "") {
      parts = contactSelect!.code.split(',');

      code.textCode1 = parts[0];
      code.textCode2 = parts[1];
      code.textCode3 = parts[2];
      code.textCode4 = parts[3];
    }

    listTask = widget.taskIds;
    if (listTask.isNotEmpty) {
      _prefs.setlistTaskIdsCancel = listTask;
    }

    taskdIds =
        widget.taskIds.isEmpty ? _prefs.getlistTaskIdsCancel : widget.taskIds;
  }

  void gotoHome() async {
    code.textCode1 = '';
    code.textCode2 = '';
    code.textCode3 = '';
    code.textCode4 = '';
    // NotificationCenter().notify('getContactZoneRisk');
    stopTimer();

    _prefs.setlistTaskIdsCancel = [];
    _prefs.setSelectContactRisk = -1;
    prefs.setTimerCancelZone = 30;

    countTimer.value = 30;
    if (contactSelect!.save == false) {
      riskVC.deleteContactRisk(context, contactSelect!);
    }
    _prefs.saveLastScreenRoute("home");
    await Get.offAll(const HomePage());
  }

  void saveDate(BuildContext context) async {
    if (contactSelect == null) {
      showSaveAlert(context, Constant.info, "No se encontro el contacto");

      gotoHome();
    }
    if (taskdIds.isEmpty) {
      setState(() async {
        showSaveAlert(
            context, Constant.info, "No se encontro el list de id de tareas");

        gotoHome();
      });
    }
    if (contactSelect!.code == codeTemp || contactSelect!.code == ',,,') {
      if (taskdIds.isNotEmpty) {
        MainService().cancelAllNotifications(taskdIds);
        contactSelect!.isActived = false;
        if (contactSelect!.save == true) {
          await const HiveDataRisk().updateContactZoneRisk(contactSelect!);
        }
      }

      gotoHome();
    } else {
      showSaveAlert(context, Constant.info, Constant.codeError);
    }
  }

  void stopTimer() {
    timerCancelZone!.cancel();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    timerCancelZone = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (secondsRemaining < 1) {
            timer.cancel();
            prefs.setTimerCancelZone = 30;
            countTimer.value = 30;
            showSaveAlert(context, Constant.info,
                "El servidor de AlertFriends envió una alerta con tu última ubicación.");
            // gotoHome();
          } else {
            secondsRemaining -= 1;
            prefs.setTimerCancelZone = secondsRemaining;
            countTimer.value = secondsRemaining;
          }
        },
      ),
    );
  }

  String get timerText {
    int minutes = (secondsRemaining ~/ 60);
    int seconds = (secondsRemaining % 60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
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
                  Container(
                    color: Colors.transparent,
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
                        Column(
                          children: [
                            Container(
                              color: Colors.transparent,
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
                              height: 30,
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
                          ],
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
      ),
    );
  }
}

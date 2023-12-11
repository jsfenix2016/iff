import 'dart:async';

import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';

import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/contentCode.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Services/mainService.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/loading_page.dart';
import 'package:ifeelefine/main.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class CancelDatePage extends StatefulWidget {
  const CancelDatePage({super.key, required this.taskIds});

  // final ContactRiskBD contactRisk;
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

  int secondsRemaining = 60; //5 minutes = 300 seconds
  Timer? _timer;
  bool isLoading = false;
  final PreferenceUser _prefs = PreferenceUser();

  @override
  void dispose() {
    super.dispose();
    secondsRemaining = _prefs.getTimerCancelZone;
  }

  @override
  void initState() {
    // contactRiskTemp = widget.contactRisk;

    getcontactRisk();
    _prefs.saveLastScreenRoute("cancelDate");

    startTimer();
    super.initState();
    starTap();
    var secondsRemaining1 = _prefs.getTimerCancelZone;
    secondsRemaining = secondsRemaining1;
  }

  void getcontactRisk() async {
    await _prefs.initPrefs();
    var resp = await riskVC.getContactsRisk();
    int indexSelect = resp.indexWhere((item) => item.isActived == true);
    contactRiskTemp = resp[indexSelect];

    List<String> parts = [];

    if (contactRiskTemp.code != "") {
      parts = contactRiskTemp.code.split(',');

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

  void saveDate(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    if (contactRiskTemp.code == codeTemp) {
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
      await _prefs.initPrefs();
      _prefs.saveLastScreenRoute("home");
      if (contactRiskTemp.saveContact == false &&
          contactRiskTemp.isFinishTime) {
        res = await editVC.deleteContactRisk(context, contactRiskTemp);
      } else {
        res = await editVC.updateContactRisk(context, contactRiskTemp);
      }

      if (res) {
        isLoading = false;

        // riskVC.update();
        stopTimer();

        await Get.off(const HomePage());
      }
    }
    // riskVC.update();
    // Navigator.of(context).pop();
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    if (timerCancelZone != null) {
      timerCancelZone!.cancel();
    }
    timerCancelZone = null;
    _timer = null;
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
    _prefs.setTimerCancelZone = 60;

    countTimer.value = 60;
    if (contactRiskTemp.saveContact == false) {
      riskVC.deleteContactRisk(context, contactRiskTemp);
    }
    _prefs.saveLastScreenRoute("home");
    await Get.offAll(const HomePage());
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    timerCancelZone = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (secondsRemaining < 1) {
            timer.cancel();
            _prefs.setTimerCancelZone = 60;
            countTimer.value = 60;
            showSaveAlert(context, Constant.info,
                "El servidor de AlertFriends envío una alerta con tu última ubicación.");
            timerCancelZone!.cancel();
            // gotoHome();
          } else {
            secondsRemaining -= 1;
            _prefs.setTimerCancelZone = secondsRemaining;
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

    return LoadingIndicator(
      isLoading: isLoading,
      child: WillPopScope(
        onWillPop: () async {
          // Aquí puedes ejecutar acciones personalizadas antes de volver atrás
          // Por ejemplo, mostrar un diálogo de confirmación
          _prefs.setTimerCancelZone = secondsRemaining;
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
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
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
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
      ),
    );
  }
}

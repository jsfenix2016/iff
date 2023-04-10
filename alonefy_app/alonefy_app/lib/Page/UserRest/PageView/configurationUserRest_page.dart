import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/restday.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'package:ifeelefine/Page/UserInactivityPage/PageView/previewInactivityPage.dart';

import 'package:ifeelefine/Page/UserRest/Controller/userRestController.dart';

import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/UserRest/PageView/previewRestTime.dart';
import 'package:ifeelefine/Page/UserRest/Widgets/rowSelectTimer.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/listDayweekCustom.dart';

class UserRestPage extends StatefulWidget {
  const UserRestPage({super.key});

  @override
  State<UserRestPage> createState() => _UserRestPageState();
}

class _UserRestPageState extends State<UserRestPage> {
  final UserRestController userRestVC = Get.put(UserRestController());

  late String timeLblAM = "00:00"; //AM
  late String timeLblPM = "00:00"; //PM

  int indexFile = 0;
  int noSelectDay = 1;
  late RestDayBD restDay;

  bool isVisibleBtn = false;
  final List<String> _selectedDays = [];
  final List<String> tempNoSelectListDay = <String>[
    "L",
    "M",
    "X",
    "J",
    "V",
    "S",
    "D",
  ];

  List<RestDayBD> tempRestDays = [];
  @override
  void initState() {
    // restDays.add(tempDicRest);

    super.initState();
    if (tempRestDays.isEmpty) {
      for (var element in tempNoSelectListDay) {
        restDay = RestDayBD(
            day: element,
            timeSleep: timeLblPM,
            timeWakeup: timeLblAM,
            selection: 0,
            isSelect: false);

        tempRestDays.add(restDay);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: SizedBox(
          child: Stack(
            children: <Widget>[
              SizedBox(
                width: size.width,
                height: size.height - 120,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 120.0, left: 50, right: 50, bottom: 30),
                      child: Container(
                        color: Colors.transparent,
                        width: size.width,
                        child: Text(
                          Constant.hoursSleepAndWakeup,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.barlow(
                            fontSize: 24.0,
                            wordSpacing: 1,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.transparent,
                      width: size.width,
                      height: 210 * noSelectDay.toDouble(),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: noSelectDay,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            key: Key(index.toString()),
                            children: [
                              ListDayWeek(
                                listRest: tempRestDays,
                                newIndex: index,
                                onChanged: (value) {
                                  var temp = tempRestDays[value];
                                  temp.selection = index;

                                  temp.isSelect =
                                      (temp.isSelect == false) ? true : false;

                                  tempRestDays.remove(temp);
                                  tempRestDays.insert(value, temp);

                                  indexFile = index;
                                  setState(() {});
                                },
                              ),
                              RowSelectTimer(
                                index: index,
                                timeLblAM: timeLblAM, //AM
                                timeLblPM: timeLblPM, //PM
                                onChanged: (value) {
                                  timeLblAM = value.timeWakeup;
                                  timeLblPM = value.timeSleep;
                                  indexFile = index;
                                  setState(() {});
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 70,
                child: SizedBox(
                  width: size.width,
                  child: Center(
                    child: ElevateButtonFilling(
                      onChanged: (value) {
                        btnAdd();
                      },
                      mensaje: "Agregar",
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                child: Visibility(
                  visible: (isVisibleBtn) ? true : false,
                  child: SizedBox(
                    width: size.width,
                    child: Center(
                      child: ElevateButtonFilling(
                        onChanged: (value) {
                          btnContinue();
                        },
                        mensaje: Constant.continueTxt,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void btnAdd() async {
    var val = await validateAllDaySelect();
    if (val == false) {
      noSelectDay++;
      await processSelectedInfo();

      // SaveAndContinueScreen();
      showAlert(context, "Faltan dias por seleccionar.");
    } else {
      showAlert(context, "Puede continuar.");
      isVisibleBtn = true;
    }
    setState(() {});
  }

  void btnContinue() async {
    if (!validateDays(tempRestDays)) {
      return;
    }
    if (tempRestDays.length == 7) {
      await processSelectedInfo();
      saveAndContinueScreen();
      return;
    }
    var val = await validateAllDaySelect();
    if (val == false) {
      await processSelectedInfo();

      showAlert(context,
          "Todos los dias ya fueron asignados puedes continuar con la configuración");

      setState(() {});
      return;
    }
    if (_selectedDays.length < 7) {
      await processSelectedInfo();
      if (tempRestDays.length == 7) {
        await processSelectedInfo();
        saveAndContinueScreen();
        return;
      }
      // ignore: use_build_context_synchronously
      showAlert(
          context, "debes seleccionar los dias restantes antes de continuar");
      setState(() {});
    }
  }

  void saveAndContinueScreen() async {
    int id = await userRestVC.saveUserListRestTime(context, tempRestDays);

    if (id != -1) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PreviewRestTimePage(
            isMenu: false,
          ),
        ),
      );
    }
  }

  bool validateDays(List<RestDayBD> restDays) {
    for (var i = 0; i < restDays.length; i++) {
      var rowDays = restDays[i].day;
      var uniqueDays = rowDays.toString();
      if (uniqueDays.length != rowDays.length) {
        return false; // días repetidos en la fila
      }
    }
    return true; // no hay días repetidos en ninguna fila
  }

  Future<bool> validateAllDaySelect() async {
    bool isSelectedAllWeek = true;
    isVisibleBtn = true;
    for (var i = 0; i < tempRestDays.length; i++) {
      if (tempRestDays[i].isSelect == false) {
        isSelectedAllWeek = false;
        isVisibleBtn = false;
      }
    }

    return isSelectedAllWeek;
  }

  Future processSelectedInfo() async {
    for (int i = 0; i < tempRestDays.length; i++) {
      if (tempRestDays[i].selection == indexFile) {
        restDay = tempRestDays[i];
        restDay.timeSleep = timeLblPM;
        restDay.timeWakeup = timeLblAM;

        tempRestDays.removeAt(i);
        tempRestDays.insert(i, restDay);

        // tempDicRest.add(restDay);
      }
    }
  }
}

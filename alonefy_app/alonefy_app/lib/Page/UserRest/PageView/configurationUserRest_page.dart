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

  int noSelectDay = 1;
  late RestDayBD restDay;

  List<RestDayBD> tempDicRest = [];
  List<List<RestDayBD>> restDays = [];

  final List<String> _selectedDays = [];

  @override
  void initState() {
    restDays.add(tempDicRest);

    super.initState();
  }

  Future<void> getUserRestDay() async {
    tempDicRest = await userRestVC.getUserRest();
    print(tempDicRest);
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
                    Positioned(
                      top: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 128.0, left: 50, right: 50, bottom: 30),
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
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: size.width,
                        height: size.height - 120,
                        child: ListView.builder(
                            itemCount: noSelectDay,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                key: Key(index.toString()),
                                children: [
                                  ListDayWeek(
                                    selectedDays: _selectedDays,
                                    listRest: restDays.isEmpty
                                        ? tempDicRest
                                        : restDays[index],
                                    newIndex: index,
                                    onChanged: (value) {
                                      print(value);

                                      tempDicRest.remove(value);
                                      restDays[index].remove(value);
                                      _selectedDays.clear();
                                      // setState(() {});
                                    },
                                  ),
                                  RowSelectTimer(
                                    index: index,
                                    timeLblAM: timeLblAM, //AM
                                    timeLblPM: timeLblPM, //PM
                                    onChanged: (value) {
                                      timeLblAM = value.timeWakeup;
                                      timeLblPM = value.timeSleep;
                                    },
                                  ),
                                ],
                              );
                            })),
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
            ],
          ),
        ),
      ),
    );
  }

  void btnAdd() async {
    if (tempDicRest.isEmpty && _selectedDays.length == 7) {
      await processSelectedInfo();
      // SaveAndContinueScreen();
      mostrarAlerta(context,
          "Todos los dias ya fueron asignados puedes continuar con la configuración");

      setState(() {});
      return;
    }
    if (_selectedDays.length < 7 && tempDicRest.length < 7) {
      await processSelectedInfo();
      noSelectDay++;

      // ignore: use_build_context_synchronously

      setState(() {});
    }
  }

  void btnContinue() async {
    // noSelectDay++;
    // tempList.add(noSelectDay);
    if (!validateDays(tempDicRest)) {
      return;
    }
    if (tempDicRest.length == 7) {
      SaveAndContinueScreen();
      return;
    }
    if (tempDicRest.isEmpty && _selectedDays.length == 7) {
      await processSelectedInfo();
      // SaveAndContinueScreen();
      mostrarAlerta(context,
          "Todos los dias ya fueron asignados puedes continuar con la configuración");

      setState(() {});
      return;
    }
    if (_selectedDays.length < 7) {
      await processSelectedInfo();
      if (tempDicRest.length == 7) {
        SaveAndContinueScreen();
        return;
      }
      // ignore: use_build_context_synchronously
      mostrarAlerta(
          context, "debes seleccionar los dias restantes antes de continuar");
      setState(() {});
    }
  }

  void SaveAndContinueScreen() async {
    int id = await userRestVC.saveUserListRestTime(context, tempDicRest);

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

  int countInser = 0;
  Future processSelectedInfo() async {
    if (tempDicRest.length < 7) {
      for (var element in _selectedDays) {
        restDay = RestDayBD(
          day: diaConvert(element),
          timeSleep: timeLblPM,
          timeWakeup: timeLblAM,
          selection: countInser,
        );

        tempDicRest.add(restDay);
        // int id = await userRestVC.saveRestTime(context, restDay);
      }
      timeLblAM = "00:00";
      timeLblPM = "00:00";
      _selectedDays.clear();

      restDays.insert(countInser, tempDicRest);
    }

    if (tempDicRest.length == 7) {
      mostrarAlerta(context,
          "Todos los dias ya fueron asignados puedes continuar con la configuración");
      return;
    }
    if (tempDicRest.length < 7) countInser++;
  }
}

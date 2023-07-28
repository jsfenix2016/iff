import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

import 'package:ifeelefine/Model/restdaybd.dart';

import 'package:ifeelefine/Page/UserRest/Controller/userRestController.dart';

import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/UserRest/PageView/previewRestTime.dart';
import 'package:ifeelefine/Page/UserRest/Widgets/rowSelectTimer.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/listDayweekCustom.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

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

  List<RestDayBD> tempRestDays = [];
  final PreferenceUser _prefs = PreferenceUser();
  @override
  void initState() {
    // restDays.add(tempDicRest);
    _prefs.saveLastScreenRoute("restDay");
    super.initState();
    if (tempRestDays.isEmpty) {
      for (var element in Constant.tempListShortDay) {
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
                    Column(
                      children: const [
                        WidgetLogoApp(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 90.0, left: 30, right: 30, bottom: 30),
                      child: Container(
                        color: Colors.transparent,
                        width: size.width,
                        child: Text(
                          Constant.hoursSleepAndWakeup,
                          textAlign: TextAlign.center,
                          style: textBold24PrincipalColor(),
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

                                  for (var element in tempRestDays) {
                                    if (element.selection == index) {
                                      element.timeWakeup = timeLblAM;
                                      element.timeSleep = timeLblPM;
                                    }
                                  }
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

      showSaveAlert(context, Constant.info, "Faltan días por seleccionar.");
    } else {
      showSaveAlert(context, Constant.info, "Puede continuar.");
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

      showSaveAlert(context, Constant.info,
          "Todos los días ya fueron asignados puedes continuar con la configuración");
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
      showSaveAlert(context, Constant.info,
          "debes seleccionar los días restantes antes de continuar");

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

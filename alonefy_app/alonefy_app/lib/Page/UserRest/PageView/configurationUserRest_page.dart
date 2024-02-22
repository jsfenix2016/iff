import 'dart:collection';

import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'package:ifeelefine/Page/PreviewActivitiesFilteredByDate/PageView/previewActivitiesByDate_page.dart';
import 'package:ifeelefine/Page/UserRest/Controller/userRestController.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/UserRest/Widgets/rowSelectTimer.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/listDayweekCustom.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/main.dart';
import 'package:collection/collection.dart';

class UserRestPage extends StatefulWidget {
  const UserRestPage({super.key});

  @override
  State<UserRestPage> createState() => _UserRestPageState();
}

class _UserRestPageState extends State<UserRestPage> {
  final UserRestController userRestVC = Get.put(UserRestController());
  final PreferenceUser _prefs = PreferenceUser();
  late String timeLblAM = "00:00:00"; //AM
  late String timeLblPM = "00:00:00"; //PM

  int indexFile = 0;
  int noSelectDay = 1;
  late RestDayBD restDay;

  bool isVisibleBtn = false;
  final List<String> _selectedDays = [];

  List<RestDayBD> tempRestDays = [];
  List<RestDayBD> selecDicActivity = <RestDayBD>[];
  List<RestDayBD> selecDicActivityTemp = <RestDayBD>[];
  Map<String, List<RestDayBD>> groupedProducts = {};
  List<RestDayBD> tempSave = <RestDayBD>[];

  List<RestDayBD> lista = [];
  List<RestDayBD> sortWeekdays(List<RestDayBD> weekdays) {
    return weekdays
      ..sort((a, b) => LinkedHashMap.from({
            'L': 1,
            'M': 2,
            'X': 3,
            'J': 4,
            'V': 5,
            'S': 6,
            'D': 7,
          })[a.day]
              .compareTo(LinkedHashMap.from({
            'L': 1,
            'M': 2,
            'X': 3,
            'J': 4,
            'V': 5,
            'S': 6,
            'D': 7,
          })[b.day]));
  }

  @override
  void initState() {
    super.initState();
    getInactivity();
    starTap();
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

  Future<void> getInactivity() async {
    groupedProducts = {};
    selecDicActivity = [];
    selecDicActivityTemp = [];
    lista = [];
    selecDicActivity = await userRestVC.getUserRest();

    if (selecDicActivity.isEmpty) {
      for (var element in Constant.tempListShortDay) {
        RestDayBD restDay = RestDayBD(
            day: element,
            timeSleep: timeLblPM,
            timeWakeup: timeLblAM,
            selection: 0,
            isSelect: false);

        selecDicActivity.add(restDay);
      }
    }
    if (tempSave.isEmpty) {
      tempSave = selecDicActivity;
    }

    List<RestDayBD> sortedWeekdays = sortWeekdays(selecDicActivity);
    selecDicActivity = sortedWeekdays;

    groupedProducts =
        groupBy(selecDicActivity, (product) => product.selection.toString());
    for (var element in groupedProducts.values) {
      selecDicActivityTemp.add(element.first);
    }
    selecDicActivityTemp.sort((a, b) => a.selection.compareTo(b.selection));

    groupedProducts.forEach((key, value) {
      for (var element in value) {
        lista.add(element);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: SizedBox(
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    width: size.width,
                    height: size.height - 140,
                    child: ListView(
                      children: [
                        const Column(
                          children: [
                            SizedBox(
                              height: 36,
                            ),
                            WidgetLogoApp(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 32.0, left: 54, right: 54, bottom: 20),
                          child: Container(
                            color: Colors.transparent,
                            width: 262,
                            height: 105,
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
                          height: 230 * noSelectDay.toDouble(),
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

                                      temp.isSelect = (temp.isSelect == false)
                                          ? true
                                          : false;

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
                                          tempRestDays[index].timeWakeup =
                                              timeLblAM;
                                          tempRestDays[index].timeSleep =
                                              timeLblPM;
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
                    bottom: 55,
                    child: SizedBox(
                      width: size.width,
                      child: Center(
                        child: ElevateButtonFilling(
                          showIcon: false,
                          onChanged: (value) {
                            btnAdd();
                          },
                          mensaje: "Guardar",
                          img: '',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    child: Visibility(
                      visible: (isVisibleBtn) ? true : false,
                      child: SizedBox(
                        width: size.width,
                        child: Center(
                          child: ElevateButtonFilling(
                            showIcon: false,
                            onChanged: (value) {
                              btnContinue();
                            },
                            mensaje: Constant.continueTxt,
                            img: '',
                          ),
                        ),
                      ),
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

  void btnAdd() async {
    var val = await validateAllDaySelect();
    if (val == false) {
      noSelectDay++;
      await processSelectedInfo();

      showSaveAlert(context, Constant.info, "Faltan días por seleccionar");
    } else {
      showSaveAlert(context, Constant.info, "Puede continuar");
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

      setState(() {
        showSaveAlert(context, Constant.info,
            "Todos los días ya fueron asignados puedes continuar con la configuración");
      });
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
          "Debes seleccionar los días restantes antes de continuar");

      setState(() {});
    }
  }

  void saveAndContinueScreen() async {
    int id = await userRestVC.saveUserListRestTime(context, tempRestDays);

    if (id != -1) {
      refreshMenu('restDay');

      Future.sync(
        () async => {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const PreviewActivitiesByDate(isMenu: false),
            ),
          ),
        },
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

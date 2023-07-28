// ignore_for_file: use_build_context_synchronously

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'package:ifeelefine/Page/PreviewActivitiesFilteredByDate/PageView/previewActivitiesByDate_page.dart';

import 'package:ifeelefine/Page/UserRest/Controller/userRestController.dart';
import 'package:ifeelefine/Page/UserRest/Widgets/rowSelectTimer.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/listDayweekCustom.dart';
import 'package:collection/collection.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class PreviewRestTimePage extends StatefulWidget {
  const PreviewRestTimePage({super.key, required this.isMenu});
  final bool isMenu;
  @override
  State<PreviewRestTimePage> createState() => _PreviewRestTimePageState();
}

class _PreviewRestTimePageState extends State<PreviewRestTimePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final UserRestController restVC = Get.put(UserRestController());
  final PreferenceUser _prefs = PreferenceUser();
  late String timeLblAM = "00:00"; //AM
  late String timeLblPM = "00:00"; //PM

  List<RestDayBD> selecDicActivity = <RestDayBD>[];
  List<RestDayBD> selecDicActivityTemp = <RestDayBD>[];
  Map<String, List<RestDayBD>> groupedProducts = {};
  List<RestDayBD> tempSave = <RestDayBD>[];

  List<RestDayBD> lista = [];
  int indexFile = -1;
  // var indexSelect = -1;

  @override
  void initState() {
    getInactivity();
    if (!widget.isMenu) _prefs.saveLastScreenRoute("previewRestDay");
    super.initState();
  }

  Future<void> getInactivity() async {
    groupedProducts = {};
    selecDicActivity = [];
    selecDicActivityTemp = [];
    lista = [];
    selecDicActivity = await restVC.getUserRest();

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

  Future updateRestDay(BuildContext context) async {
    int id = await restVC.saveUserListRestTime(context, selecDicActivity);

    if (id != -1) {
      if (widget.isMenu) {
        showSaveAlert(context, Constant.info, Constant.saveCorrectly);
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PreviewActivitiesByDate(isMenu: false),
        ),
      );
    }
  }

  Future processSelectedInfo() async {
    if (indexFile == -1) {
      return;
    }
    for (int i = 0; i < selecDicActivity.length; i++) {
      if (selecDicActivity[i].selection == indexFile) {
        var restDay = selecDicActivity[i];
        restDay.timeSleep = timeLblPM;
        restDay.timeWakeup = timeLblAM;

        selecDicActivity.removeAt(i);
        selecDicActivity.insert(i, restDay);
      }
    }
  }

  Future<bool> validateAllDaySelect() async {
    bool isNotSelectedAllWeek = false;
    for (var i = 0; i < selecDicActivity.length; i++) {
      if (selecDicActivity[i].isSelect == false) {
        isNotSelectedAllWeek = true;
        var temp = selecDicActivity[i];
        temp.isSelect = false;
        temp.selection = groupedProducts.length;

        selecDicActivity.removeAt(i);
        selecDicActivity.insert(i, temp);
        await restVC.saveUserListRestTime(context, selecDicActivity);
        getInactivity();
        continue;
      }
    }

    return isNotSelectedAllWeek;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: widget.isMenu
          ? AppBar(
              backgroundColor: ColorPalette.secondView,
              title: const Text('Horas de sueño'),
            )
          : null,
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: ListView(
          children: [
            Column(
              children: const [
                WidgetLogoApp(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            for (var i = 0; i <= groupedProducts.length - 1; i++)
              Container(
                key: Key(i.toString()),
                color: Colors.transparent,
                width: size.width,
                height: 210,
                child: ListView.builder(
                  key: Key(i.toString()),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      key: Key(index.toString()),
                      children: [
                        ListDayWeek(
                          listRest: selecDicActivity,
                          newIndex: i,
                          onChanged: (value) async {
                            indexFile = value;
                            var temp = selecDicActivity[value];
                            temp.isSelect =
                                (temp.isSelect == false) ? true : false;
                            temp.selection = i;

                            selecDicActivity.removeAt(value);
                            selecDicActivity.insert(value, temp);

                            setState(() {});
                          },
                        ),
                        RowSelectTimer(
                          index: i,
                          timeLblAM: selecDicActivityTemp[i].timeWakeup, //AM
                          timeLblPM: selecDicActivityTemp[i].timeSleep, //PM
                          onChanged: (value) {
                            timeLblAM = value.timeWakeup;
                            timeLblPM = value.timeSleep;
                            indexFile = i;
                            var listgroup = groupedProducts[i.toString()];
                            for (var ic = 0; ic < listgroup!.length; ic++) {
                              var temp = listgroup[ic];
                              if (temp.selection == indexFile) {
                                selecDicActivity.remove(temp);
                                temp.timeSleep = timeLblPM;
                                temp.timeWakeup = timeLblAM;
                                selecDicActivity.add(temp);
                              }
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            Row(
              children: [
                Container(
                  color: Colors.transparent,
                  height: 50,
                  width: size.width / 2,
                  child: SizedBox(
                    width: size.width,
                    child: Center(
                      child: ElevateButtonCustomBorder(
                        onChanged: (value) async {
                          int id = await restVC.saveUserListRestTime(
                              context, tempSave);

                          if (id == -1) {
                            showSaveAlert(
                                context, Constant.info, Constant.errorGeneric);
                            return;
                          }
                          setState(() {});
                        },
                        mensaje: "Cancelar",
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: 50,
                  width: size.width / 2,
                  child: SizedBox(
                    width: size.width,
                    child: Center(
                      child: ElevateButtonCustomBorder(
                        onChanged: (value) async {
                          if (await validateAllDaySelect()) {
                            showSaveAlert(context, Constant.info,
                                "Debes seleccionar los días restantes antes de continuar");
                            return;
                          } else {
                            await processSelectedInfo();
                            updateRestDay(context);
                          }

                          if (widget.isMenu) return;
                        },
                        mensaje: Constant.saveBtn,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

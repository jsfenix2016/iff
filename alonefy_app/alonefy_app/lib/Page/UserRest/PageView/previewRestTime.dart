import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Model/restday.dart';
import 'package:ifeelefine/Model/restdaybd.dart';

import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';
import 'package:ifeelefine/Page/UserRest/Controller/userRestController.dart';
import 'package:ifeelefine/Page/UserRest/Widgets/rowSelectTimer.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/listDayweekCustom.dart';
import 'package:collection/collection.dart';

class PreviewRestTimePage extends StatefulWidget {
  const PreviewRestTimePage({super.key, required this.isMenu});
  final bool isMenu;
  @override
  State<PreviewRestTimePage> createState() => _PreviewRestTimePageState();
}

class _PreviewRestTimePageState extends State<PreviewRestTimePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final UserRestController restVC = Get.put(UserRestController());

  late String timeLblAM = "00:00"; //AM
  late String timeLblPM = "00:00"; //PM

  List<RestDayBD> selecDicActivity = <RestDayBD>[];
  List<RestDayBD> selecDicActivityTemp = <RestDayBD>[];
  Map<String, List<RestDayBD>> groupedProducts = {};

  final List<String> tempListDay = <String>[];
  List<RestDayBD> lista = [];

  var indexSelect = -1;
  @override
  void initState() {
    getInactivity();
    super.initState();
  }

  Future<void> getInactivity() async {
    groupedProducts = {};
    selecDicActivity = await restVC.getUserRest();
    List<RestDayBD> sortedWeekdays = sortWeekdays(selecDicActivity);
    selecDicActivity = sortedWeekdays;

    groupedProducts =
        groupBy(selecDicActivity, (product) => product.selection.toString());
    groupedProducts.forEach((key, value) {
      selecDicActivityTemp.add(value.first);
    });

    groupedProducts.forEach((key, value) {
      for (int i = 0; i < value.length; i++) {
        lista.add(value[i]);
      }
    });

    setState(() {});
  }

// deleteTimeRest
  // int countInser = 0;
  // Future processSelectedInfo() async {
  //   for (var element in selecDicActivity) {
  //     tempNoSelectListDay.remove(element);
  //   }
  //   for (var element in selecDicActivity) {
  //     restDay = RestDayBD(
  //       day: diaConvert(element),
  //       timeSleep: timeLblPM,
  //       timeWakeup: timeLblAM,
  //       selection: countInser,
  //     );

  //     tempDicRest.add(restDay);
  //   }
  //   timeLblAM = "00:00";
  //   timeLblPM = "00:00";
  //   _selectedDays.clear();
  //   countInser++;
  // }

  List<RestDayBD> sortWeekdays(List<RestDayBD> weekdays) {
    return weekdays
      ..sort((a, b) => LinkedHashMap.from({
            'Lunes': 1,
            'Martes': 2,
            'Miercoles': 3,
            'Jueves': 4,
            'Viernes': 5,
            'Sabado': 6,
            'Domingo': 7,
          })[a.day]
              .compareTo(LinkedHashMap.from({
            'Lunes': 1,
            'Martes': 2,
            'Miercoles': 3,
            'Jueves': 4,
            'Viernes': 5,
            'Sabado': 6,
            'Domingo': 7,
          })[b.day]));
  }

  void updateRestDay(RestDayBD restDay) {
    // ignore: use_build_context_synchronously
    restVC.updateUserRestTime(context, restDay);
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
            const SizedBox(
              height: 10,
            ),
            for (var i = 0; i <= groupedProducts.length - 1; i++)
              Positioned(
                key: Key(i.toString()),
                top: (i * 150),
                child: Container(
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
                            selectedDays: tempListDay,
                            listRest: selecDicActivity,
                            newIndex: i,
                            onChanged: (value) async {
                              print(value);
                              tempListDay.remove(value);

                              RestDayBD restDay = RestDayBD(
                                day: selecDicActivityTemp[value.selection].day,
                                timeSleep: selecDicActivityTemp[value.selection]
                                    .timeSleep,
                                timeWakeup:
                                    selecDicActivityTemp[value.selection]
                                        .timeWakeup,
                                selection: index,
                              );
                              selecDicActivity.remove(value);
                              // updateRestDay(restDay);

                              await restVC.deleteUserRestDay(context, restDay);
                              getInactivity();
                              setState(() {});
                            },
                          ),
                          RowSelectTimer(
                            index: index,
                            timeLblAM: selecDicActivityTemp[i].timeWakeup, //AM
                            timeLblPM: selecDicActivityTemp[i].timeSleep, //PM
                            onChanged: (value) {
                              timeLblAM = value.timeWakeup;
                              timeLblPM = value.timeSleep;

                              print(timeLblAM);
                              print(timeLblPM);

                              RestDayBD restDay = RestDayBD(
                                day: selecDicActivityTemp[value.id].day,
                                timeSleep: value.timeSleep,
                                timeWakeup: value.timeWakeup,
                                selection: index,
                              );
                              updateRestDay(restDay);
                              // ignore: use_build_context_synchronously
                              // restVC.updateUserRestTime(context, restDay);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            Row(
              children: [
                Container(
                  color: Colors.red,
                  height: 50,
                  width: size.width / 2,
                  child: Positioned(
                    bottom: 10,
                    child: SizedBox(
                      width: size.width,
                      child: Center(
                        child: ElevateButtonCustomBorder(
                          onChanged: (value) {
                            print(widget.isMenu);

                            if (lista.length == 7 &&
                                selecDicActivityTemp.length == 7) {
                              return;
                            }
                            if (widget.isMenu) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const UserInactivityPage(),
                              ),
                            );
                          },
                          mensaje: "Cancelar",
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.green,
                  height: 50,
                  width: size.width / 2,
                  child: Positioned(
                    bottom: 10,
                    child: SizedBox(
                      width: size.width,
                      child: Center(
                        child: ElevateButtonCustomBorder(
                          onChanged: (value) {
                            print(widget.isMenu);

                            if (lista.length == 7 &&
                                selecDicActivityTemp.length == 7) {
                              return;
                            }
                            if (widget.isMenu) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const UserInactivityPage(),
                              ),
                            );
                          },
                          mensaje: Constant.saveBtn,
                        ),
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

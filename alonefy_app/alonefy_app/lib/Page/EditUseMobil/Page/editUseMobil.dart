import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ifeelefine/Model/useMobilbd.dart';
import 'package:ifeelefine/Page/EditUseMobil/Controller/editUseController.dart';
import 'package:ifeelefine/Page/EditUseMobil/Page/Widget/listWeekDayCustom.dart';

import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';

import 'package:collection/collection.dart';

import '../../../Provider/prefencesUser.dart';
import '../../Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class EditUseMobilPage extends StatefulWidget {
  const EditUseMobilPage({super.key});

  @override
  State<EditUseMobilPage> createState() => _EditUseMobilPageState();
}

class _EditUseMobilPageState extends State<EditUseMobilPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final EditUseMobilController editUseMobilVC =
      Get.put(EditUseMobilController());
  late FixedExtentScrollController scrollController;
  late String timeLblPM = ""; //PM

  List<UseMobilBD> selecListUseMobilDays = <UseMobilBD>[];

  Map<String, List<UseMobilBD>> groupedProducts = {};
  List<UseMobilBD> selecDicActivityCancel = <UseMobilBD>[];

  int indexFile = 0;
  var indexSelect = -1;
  int noSelectDay = 1;
  List<UseMobilBD> tempUseMobilBDDays = [];

  Map<String, String> timeDic = <String, String>{};

  final _prefs = PreferenceUser();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    await Hive.close();
    var habits = _prefs.getHabitsTime;
    timeDic = editUseMobilVC.getMapWithHabitsTime(habits);
    getListUseMobilForDay();
    scrollController = FixedExtentScrollController(initialItem: 0);
    if (tempUseMobilBDDays.isEmpty) {
      for (var element in Constant.tempListShortDay) {
        var useMobilBD = UseMobilBD(
            day: element, time: '5 min', selection: 0, isSelect: true);

        tempUseMobilBDDays.add(useMobilBD);
      }
    }
  }

  Future<void> getListUseMobilForDay() async {
    groupedProducts = {};
    selecListUseMobilDays = [];

    selecListUseMobilDays = await editUseMobilVC.getTimeUseMobilBD();
    if (selecDicActivityCancel.isEmpty) {
      selecDicActivityCancel = selecListUseMobilDays;
    }
    if (groupedProducts.isEmpty && selecListUseMobilDays.isEmpty) {
      selecListUseMobilDays = tempUseMobilBDDays;
    }

    List<UseMobilBD> sortedWeekdays = sortWeekdays(selecListUseMobilDays);
    selecListUseMobilDays = sortedWeekdays;

    groupedProducts = groupBy(
        selecListUseMobilDays, (product) => product.selection.toString());

// convierte el mapa a una lista de MapEntry
    final entries = groupedProducts.entries.toList();

// ordena la lista de MapEntry por la clave (String)
    entries.sort((a, b) => a.key.compareTo(b.key));

// convierte la lista ordenada de MapEntry en un nuevo Map
    final sortedMap = Map.fromEntries(entries);

// usa el mapa ordenado
    print(sortedMap);
    groupedProducts = sortedMap;

    setState(() {});
  }

  List<UseMobilBD> sortWeekdays(List<UseMobilBD> weekdays) {
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

  Future processSelectedInfo() async {
    for (int i = 0; i < selecListUseMobilDays.length; i++) {
      if (selecListUseMobilDays[i].selection == indexSelect &&
          selecListUseMobilDays[i].isSelect == true) {
        var useMobilDay = selecListUseMobilDays[i];
        useMobilDay.time = timeLblPM;
        useMobilDay.selection = indexSelect;
        useMobilDay.isSelect = true;
        selecListUseMobilDays.removeAt(i);
        selecListUseMobilDays.insert(i, useMobilDay);
      }
    }
  }

  Future<bool> validateAllDaySelect() async {
    bool isNotSelectedAllWeek = true;
    for (var i = 0; i < selecListUseMobilDays.length; i++) {
      if (selecListUseMobilDays[i].isSelect == false) {
        isNotSelectedAllWeek = false;
        continue;
      }
    }

    return isNotSelectedAllWeek;
  }

  void btnCancel() async {
    await editUseMobilVC.saveTimeUseMobil(context, selecDicActivityCancel);
    // showAlert(context, "Se ha cancelado los cambios");
    showSaveAlert(context, Constant.info, Constant.cancelChange);
  }

  void btnAdd() async {
    var val = await validateAllDaySelect();
    if (val == false) {
      noSelectDay++;
      List<UseMobilBD> newRestDays = [];
      for (var element in Constant.tempListShortDay) {
        var useMobilDay = UseMobilBD(
            day: element,
            time: timeLblPM,
            selection: noSelectDay - 1,
            isSelect: false);

        newRestDays.add(useMobilDay);
      }
      var a = {"${noSelectDay - 1}": sortWeekdays(newRestDays)};
      groupedProducts.addAll(a);

      setState(() {});
    } else {
      await editUseMobilVC.saveTimeUseMobil(
          context, sortWeekdays(selecListUseMobilDays));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: ColorPalette.secondView,
        title: const Text('Tiempo de uso'),
      ),
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            for (var indexGroup = 0;
                indexGroup <= groupedProducts.length - 1;
                indexGroup++)
              Positioned(
                key: Key(indexGroup.toString()),
                top: (indexGroup * 150),
                child: Container(
                  key: Key(indexGroup.toString()),
                  color: Colors.transparent,
                  width: size.width,
                  height: 210,
                  child: ListView.builder(
                    key: Key(indexGroup.toString()),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (context, indexList) {
                      final scrollController = FixedExtentScrollController(
                        initialItem: timeDic.values.toList().indexOf(
                              groupedProducts.entries
                                  .toList()[indexGroup]
                                  .value
                                  .first
                                  .time,
                            ),
                      );

                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        key: Key(indexList.toString()),
                        children: [
                          ListWeekDayCustom(
                            listRest: selecListUseMobilDays,
                            newIndex: indexGroup,
                            onChanged: (value) async {
                              indexFile = value;
                              var temp = selecListUseMobilDays[value];
                              temp.isSelect =
                                  (selecListUseMobilDays[value].isSelect ==
                                          true)
                                      ? false
                                      : true;
                              temp.selection = indexGroup;
                              indexSelect = indexGroup;
                              selecListUseMobilDays.removeAt(value);
                              selecListUseMobilDays.insert(value, temp);
                            },
                            model: selecListUseMobilDays[indexList],
                          ),
                          Container(
                            height: 200,
                            color: Colors.transparent,
                            child: SizedBox(
                                width: 200,
                                height: 90,
                                child: Stack(
                                  children: [
                                    if (_prefs.getUserPremium ||
                                        _prefs.getDemoActive) ...[
                                      _getCupertinoPicker(indexList, indexGroup,
                                          scrollController),
                                    ] else ...[
                                      GestureDetector(
                                        child: AbsorbPointer(
                                            absorbing: !_prefs.getUserPremium ||
                                                _prefs.getDemoActive,
                                            child: _getCupertinoPicker(
                                                indexList,
                                                indexGroup,
                                                scrollController)),
                                        onVerticalDragEnd: (drag) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const PremiumPage(
                                                        isFreeTrial: false,
                                                        img: 'pantalla3.png',
                                                        title: Constant
                                                            .premiumUseTimeTitle,
                                                        subtitle: '')),
                                          );
                                        },
                                      )
                                    ]
                                  ],
                                )),
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
                  color: Colors.transparent,
                  height: 50,
                  width: size.width / 2,
                  child: Positioned(
                    bottom: 10,
                    child: SizedBox(
                      width: size.width,
                      child: Center(
                        child: ElevateButtonCustomBorder(
                          onChanged: (value) async {
                            //btnCancel();
                          },
                          mensaje: "Cancelar",
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: 50,
                  width: size.width / 2,
                  child: Positioned(
                    bottom: 10,
                    child: SizedBox(
                      width: size.width,
                      child: Center(
                        child: ElevateButtonCustomBorder(
                          onChanged: (value) async {
                            btnAdd();
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

  Widget _getCupertinoPicker(int indexList, int indexGroup,
      FixedExtentScrollController scrollController) {
    return CupertinoPicker(
      key: Key(indexList.toString()),
      scrollController: scrollController,
      backgroundColor: Colors.transparent,
      onSelectedItemChanged: (int value) {
        indexSelect = indexGroup;
        timeLblPM = timeDic[value.toString()].toString();
        processSelectedInfo();
      },
      itemExtent: 56.0,
      children: List.generate(timeDic.length, (index) {
        return Container(
          key: Key(indexList.toString()),
          height: 64,
          width: 125,
          color: Colors.transparent,
          child: Column(
            key: Key(indexList.toString()),
            children: [
              Text(
                key: Key(indexList.toString()),
                timeDic.values.toList()[index],
                textAlign: TextAlign.center,
                style: GoogleFonts.barlow(
                  fontSize: 36.0,
                  wordSpacing: 1,
                  letterSpacing: 0.001,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                height: 2,
                width: 100,
                color: Colors.white,
              ),
            ],
          ),
        );
      }),
    );
  }
}

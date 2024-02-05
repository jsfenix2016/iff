import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:ifeelefine/Model/useMobilbd.dart';
import 'package:ifeelefine/Page/EditUseMobil/Controller/editUseController.dart';
import 'package:ifeelefine/Page/EditUseMobil/Page/Widget/listWeekDayCustom.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
import 'package:ifeelefine/Page/UserRest/Widgets/row_buttons_when_menu.dart';

import 'package:collection/collection.dart';
import 'package:ifeelefine/main.dart';

import 'package:jiffy/jiffy.dart';
import 'package:slidable_button/slidable_button.dart';

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
    starTap();
    super.initState();
  }

  Future<void> _init() async {
    await Hive.close();
    var habits = _prefs.getHabitsTime;
    timeDic = editUseMobilVC.getMapWithHabitsTime(habits);
    getListUseMobilForDay();
    scrollController = FixedExtentScrollController(initialItem: 4);
    if (tempUseMobilBDDays.isEmpty) {
      for (var element in Constant.tempListShortDay) {
        var useMobilBD = UseMobilBD(
            day: element, time: '10 min', selection: 0, isSelect: true);

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
    await editUseMobilVC.saveTimeUseMobil(selecDicActivityCancel);
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
      Future.sync(() => {
            showSaveAlert(context, Constant.info, "Faltan días por seleccionar")
          });
    } else {
      if (_prefs.getUserFree && !_prefs.getUserPremium) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PremiumPage(
                isFreeTrial: false,
                img: 'pantalla1.jpg',
                title: Constant.premiumChangeTimeTitle,
                subtitle: ''),
          ),
        ).then((value) {
          if (value != null && value) {
            _prefs.setUserPremium = true;
            _prefs.setUserFree = false;
            var premiumController = Get.put(PremiumController());
            premiumController.updatePremiumAPI(true);

            saveChange();
          }
        });
      } else {
        saveChange();
      }
    }
  }

  Future<void> saveChange() async {
    var save = await editUseMobilVC
        .saveTimeUseMobil(sortWeekdays(selecListUseMobilDays));
    if (save) {
      Future.sync(() =>
          {showSaveAlert(context, Constant.info, Constant.saveCorrectly)});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    RedirectViewNotifier.setStoredContext(context);
    return Scaffold(
      backgroundColor: Colors.black,
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.brown,
        title: Text(
          Constant.titleNavBar,
          style: textForTitleApp(),
        ),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: SafeArea(
            child: Stack(
              children: [
                ListView(
                  children: [
                    const SizedBox(
                      height: 90,
                    ),
                    Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          "Tiempo de uso",
                          style: GoogleFonts.barlow(
                            fontSize: 24.0,
                            wordSpacing: 1,
                            letterSpacing: 0.001,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    for (var indexGroup = 0;
                        indexGroup <= groupedProducts.length - 1;
                        indexGroup++)
                      Container(
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
                            final scrollController =
                                FixedExtentScrollController(
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
                                        (selecListUseMobilDays[value]
                                                    .isSelect ==
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
                                        if (_prefs.getUserPremium) ...[
                                          _getCupertinoPicker(indexList,
                                              indexGroup, scrollController),
                                        ] else ...[
                                          GestureDetector(
                                            child: AbsorbPointer(
                                                absorbing:
                                                    !_prefs.getUserPremium,
                                                child: _getCupertinoPicker(
                                                    indexList,
                                                    indexGroup,
                                                    FixedExtentScrollController(
                                                        initialItem: 1))),
                                            onVerticalDragEnd: (drag) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PremiumPage(
                                                            isFreeTrial: false,
                                                            img:
                                                                'pantalla1.jpg',
                                                            title: Constant
                                                                .premiumUseTimeTitle,
                                                            subtitle: '')),
                                              ).then(
                                                (value) {
                                                  if (value != null && value) {
                                                    _prefs.setUserPremium =
                                                        true;
                                                    _prefs.setUserFree = false;
                                                    var premiumController =
                                                        Get.put(
                                                            PremiumController());
                                                    premiumController
                                                        .updatePremiumAPI(true);
                                                    setState(() {});
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                  ],
                ),
                Positioned(
                  bottom: 50,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(
                                    0xFFCA9D0B), // El color #CA9D0B en formato ARGB (Alpha, Rojo, Verde, Azul)
                                Color(
                                    0xFFDBB12A), // El color #DBB12A en formato ARGB (Alpha, Rojo, Verde, Azul)
                              ],
                              stops: [
                                0.1425,
                                0.9594
                              ], // Puedes ajustar estos valores para cambiar la ubicación de los colores en el gradiente
                              transform: GradientRotation(92.66 *
                                  (3.14159265359 /
                                      180)), // Convierte el ángulo a radianes para Flutter
                            ),
                          ),
                          child: HorizontalSlidableButton(
                            isRestart: true,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(2)),
                            height: 55,
                            width: 296,
                            buttonWidth: 60.0,
                            // color: ColorPalette.principal,
                            buttonColor: const Color.fromRGBO(157, 123, 13, 1),
                            dismissible: false,
                            label: Image.asset(
                              scale: 1,
                              fit: BoxFit.fill,
                              'assets/images/Group 969.png',
                              height: 13,
                              width: 21,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 40.0),
                                    child: Center(
                                      child: Text(
                                        _prefs.getHabitsEnable
                                            ? Constant.habitsDisamble
                                            : Constant.habitsEnable,
                                        textAlign: TextAlign.center,
                                        style: textBold16Black(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onChanged: (position) async {
                              await Jiffy.locale('es');
                              var datetime = DateTime.now();
                              var strDatetime =
                                  Jiffy(datetime).format(getDefaultPattern());

                              if (position == SlidableButtonPosition.end) {
                                if (_prefs.getUserFree &&
                                    !_prefs.getUserPremium) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PremiumPage(
                                          isFreeTrial: false,
                                          img: 'Pantalla5.jpg',
                                          title:
                                              'Protege tu Seguridad Personal las 24h:\n\n',
                                          subtitle:
                                              'Activa detección de hábitos'),
                                    ),
                                  ).then(
                                    (value) {
                                      if (value != null && value) {
                                        _prefs.setUserFree = false;
                                        _prefs.setUserPremium = true;
                                        _prefs.setHabitsEnable = true;
                                        _prefs.setHabitsRefresh = strDatetime;
                                        var premiumController =
                                            Get.put(PremiumController());
                                        premiumController
                                            .updatePremiumAPI(true);
                                        setState(() {});
                                      }
                                    },
                                  );
                                } else {
                                  _prefs.getHabitsEnable
                                      ? _prefs.setHabitsEnable = false
                                      : _prefs.setHabitsEnable = true;
                                  setState(() {});
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      RowButtonsWhenMenu(
                        onCancel: (bool bool) {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                        onSave: (bool bool) {
                          btnAdd();
                        },
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

  Widget _getCupertinoPicker(int indexList, int indexGroup,
      FixedExtentScrollController scrollController) {
    return CupertinoPicker(
      selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
          background: Colors.transparent),
      key: Key(indexList.toString()),
      scrollController: scrollController,
      backgroundColor: Colors.transparent,
      onSelectedItemChanged: (int value) {
        indexSelect = indexGroup;
        timeLblPM = timeDic[value.toString()].toString();
        processSelectedInfo();
      },
      itemExtent: 60.0,
      children: List.generate(timeDic.length, (index) {
        return Container(
          key: Key(indexList.toString()),
          height: 65,
          width: 150,
          color: Colors.transparent,
          child: Column(
            key: Key(indexList.toString()),
            children: [
              Text(
                key: Key(indexList.toString()),
                timeDic.values.toList()[index],
                textAlign: TextAlign.center,
                style: GoogleFonts.barlow(
                  fontSize: 30.0,
                  wordSpacing: 1,
                  letterSpacing: 0.001,
                  fontWeight: FontWeight.w700,
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

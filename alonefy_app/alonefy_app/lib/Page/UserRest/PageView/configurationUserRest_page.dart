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

class UserRestPage extends StatefulWidget {
  const UserRestPage({super.key});

  @override
  State<UserRestPage> createState() => _UserRestPageState();
}

class _UserRestPageState extends State<UserRestPage> {
  final UserRestController userRestVC = Get.put(UserRestController());

  late String timeLblAM = "00:00"; //AM
  late String timeLblPM = "00:00"; //PM
  var indexSelect = -1;

  var isSelect = false;
  int noSelectDay = 1;
  late RestDay restDay;
  final List<RestDayBD> tempDicRest = [];
  final List<int> tempList = <int>[];
  final List<int> tempListConfig = <int>[];
  final List<String> tempListDay = <String>[
    "L",
    "M",
    "X",
    "J",
    "V",
    "S",
    "D",
  ];
  final List<String> tempNoSelectListDay = <String>[
    "L",
    "M",
    "X",
    "J",
    "V",
    "S",
    "D",
  ];

  final List<String> _selectedDays = [];
  @override
  void initState() {
    tempList.add(noSelectDay);
    super.initState();
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
              ListView(
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
                  for (var i = 0; i < 1; i++)
                    Positioned(
                      top: (tempList[i] * 150),
                      child: Container(
                        color: Colors.transparent,
                        width: size.width,
                        height: 155,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              key: Key(index.toString()),
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    for (var i = 0;
                                        i < tempNoSelectListDay.length;
                                        i++)
                                      GestureDetector(
                                        key: Key(i.toString()),
                                        onTap: () {
                                          if (_selectedDays.contains(
                                              tempNoSelectListDay[i])) {
                                            _selectedDays
                                                .remove(tempNoSelectListDay[i]);
                                          } else {
                                            _selectedDays
                                                .add(tempNoSelectListDay[i]);
                                          }
                                          setState(
                                            () {},
                                          );
                                        },
                                        child: Container(
                                          width: size.width / 7,
                                          height: 50,
                                          color: Colors.transparent,
                                          child: Center(
                                            child: Stack(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: _selectedDays.contains(
                                                            tempNoSelectListDay[
                                                                i])
                                                        ? null
                                                        : Border.all(
                                                            color: _selectedDays
                                                                    .contains(
                                                                        tempNoSelectListDay[
                                                                            i])
                                                                ? ColorPalette
                                                                    .principal
                                                                : Colors.white,
                                                            width: 1,
                                                          ),
                                                    color: _selectedDays.contains(
                                                            tempNoSelectListDay[
                                                                i])
                                                        ? ColorPalette.principal
                                                        : null,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  height: 38,
                                                  width: 38.59,
                                                  child: Center(
                                                    child: Text(
                                                      tempNoSelectListDay[i],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.barlow(
                                                        fontSize: 20.0,
                                                        wordSpacing: 1,
                                                        letterSpacing: 1,
                                                        fontWeight: _selectedDays
                                                                .contains(
                                                                    tempNoSelectListDay[
                                                                        i])
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        color: _selectedDays
                                                                .contains(
                                                                    tempNoSelectListDay[
                                                                        i])
                                                            ? Colors.black
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                RowSelectTimer(
                                  index: index,
                                  timeLblAM: timeLblAM, //AM
                                  timeLblPM: timeLblPM, //PM
                                  onChanged: (value) {
                                    timeLblAM = value.timeWakeup;
                                    timeLblPM = value.timeSleep;
                                    setState(() {});
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                ],
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

  void btnContinue() async {
    noSelectDay++;
    tempList.add(noSelectDay);

    if (tempDicRest.length == 7) {
      SaveAndContinueScreen();
      return;
    }
    if (tempDicRest.isEmpty && _selectedDays.length == 7) {
      await processSelectedInfo();
      SaveAndContinueScreen();
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
    int id = await userRestVC.saveUserRestTime(context, tempDicRest);

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

  Future processSelectedInfo() async {
    for (var element in _selectedDays) {
      tempNoSelectListDay.remove(element);
    }
    for (var element in _selectedDays) {
      RestDayBD restDay = RestDayBD(
          day: diaConvert(element),
          timeSleep: timeLblPM,
          timeWakeup: timeLblAM);

      tempDicRest.add(restDay);
    }
    _selectedDays.clear();
  }
}

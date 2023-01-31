import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

import 'package:ifeelefine/Model/restday.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'package:ifeelefine/Page/UseMobil/PageView/configurationUseMobile_page.dart';
import 'package:ifeelefine/Page/UserRest/Controller/userRestController.dart';
import 'package:collection/collection.dart';

class PreviewRestTimePage extends StatefulWidget {
  const PreviewRestTimePage({super.key});

  @override
  State<PreviewRestTimePage> createState() => _PreviewRestTimePageState();
}

class _PreviewRestTimePageState extends State<PreviewRestTimePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final UserRestController restVC = Get.put(UserRestController());

  late String timeLblAM = "00:00"; //AM
  late String timeLblPM = "00:00"; //PM
  List<RestDayBD> tempDicRest = [];
  List<RestDayBD> selecDicActivity = <RestDayBD>[];
  List<RestDayBD> selecDicActivityTemp = <RestDayBD>[];
  Map<String, List<RestDayBD>> groupedProducts = {};

  final List<int> tempListConfig = <int>[];
  late RestDay temp;
  final List<String> tempListDay = <String>[];
  List<RestDayBD> lista = [];

  var indexSelect = -1;
  @override
  void initState() {
    getInactivity();
    super.initState();
  }

  Future<void> getInactivity() async {
    selecDicActivity = await restVC.getUserRest();
    List<RestDayBD> sortedWeekdays = sortWeekdays(selecDicActivity);
    selecDicActivity = sortedWeekdays;
    setState(() {});
  }

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: _createBottom(context),
      key: scaffoldKey,
      extendBodyBehindAppBar: true,

      // appBar: AppBar(
      //   // surfaceTintColor: Colors.transparent,
      //   // foregroundColor: Colors.transparent,
      //   // shadowColor: Colors.transparent,
      //   backgroundColor: const Color.fromARGB(255, 76, 52, 22),
      //   title: const Center(child: Text("Horas de descanzo")),
      // ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: const Alignment(0, 1),
            colors: <Color>[
              ColorPalette.principal,
              ColorPalette.second,
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        width: size.width,
        height: size.height,
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: selecDicActivity.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      color: Colors.black.withAlpha(100),
                      width: size.width,
                      child: Text(
                        selecDicActivity[index].day,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 30.0,
                          wordSpacing: 1,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            indexSelect = index;
                            displayTimePicker(context);
                          },
                          child: Container(
                            key: Key(selecDicActivity[index].day),
                            width: size.width / 2,
                            height: 70,
                            color: Colors.transparent,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  child: Image.asset(
                                    scale: 1,
                                    fit: BoxFit.fill,
                                    'assets/images/Group 979.png',
                                    height: 24,
                                    width: 44,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: size.width,
                                  child: Text(
                                    selecDicActivity[index].timeSleep,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.barlow(
                                      fontSize: 30.0,
                                      wordSpacing: 1,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            indexSelect = index;
                            displayTimePickerPM(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: size.width / 2.5,
                              height: 83,
                              color: Colors.transparent,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    child: Image.asset(
                                      scale: 1,
                                      fit: BoxFit.fill,
                                      'assets/images/Ellipse 185.png',
                                      height: 30,
                                      width: 29,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: size.width,
                                    child: Text(
                                      selecDicActivity[index].timeWakeup,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.barlow(
                                        fontSize: 30.0,
                                        wordSpacing: 1,
                                        letterSpacing: 1.2,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
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
                  ],
                );
              },
            ),
            Positioned(
              bottom: 10,
              child: SizedBox(
                width: size.width,
                child: Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                    ),
                    onPressed: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserMobilePage()),
                      );
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(219, 177, 42, 1),
                        border: Border.all(
                          color: const Color.fromRGBO(219, 177, 42, 1),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                      ),
                      height: 42,
                      width: 200,
                      child: const Center(
                        child: Text(
                          'Continuar',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future displayTimePickerPM(BuildContext context) async {
    var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child: childWidget!);
        });
    if (time != null) {
      // ignore: use_build_context_synchronously
      timeLblPM = time.format(context);
      RestDayBD restDay = RestDayBD(
          day: selecDicActivity[indexSelect].day,
          timeSleep: selecDicActivity[indexSelect].timeSleep,
          timeWakeup: timeLblPM);
      var update = restVC.updateUserDate(context, restDay);
      getInactivity();
    }
  }

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child: childWidget!);
        });
    if (time != null) {
      // ignore: use_build_context_synchronously
      timeLblAM = time.format(context);
      // selecDicActivity[indexSelect].timeWakeup = timeLblAM;
      RestDayBD restDay = RestDayBD(
          day: selecDicActivity[indexSelect].day,
          timeSleep: timeLblAM,
          timeWakeup: selecDicActivity[indexSelect].timeWakeup);
      var update = restVC.updateUserDate(context, restDay);

      getInactivity();
    }
  }
}

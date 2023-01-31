import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/restday.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'package:ifeelefine/Page/UserInactivityPage/PageView/previewInactivityPage.dart';

import 'package:ifeelefine/Page/UserRest/Controller/userRestController.dart';

import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/UserRest/PageView/previewRestTime.dart';

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

    var rowTimeSelectorRest = Row(
      children: [
        GestureDetector(
          onTap: () {
            displayTimePicker(context);
          },
          child: Container(
            width: size.width / 2,
            height: 70,
            color: Colors.transparent,
            child: Column(
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
                  width: double.infinity,
                  child: Text(
                    timeLblAM,
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
        GestureDetector(
          onTap: () {
            displayTimePickerPM(context);
          },
          child: Container(
            width: size.width / 2,
            height: 83,
            color: Colors.transparent,
            child: Column(
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
                  width: double.infinity,
                  child: Text(
                    timeLblPM,
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
      ],
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment(0, 1),
            colors: <Color>[
              Color.fromRGBO(21, 14, 3, 1),
              Color.fromRGBO(115, 75, 24, 1),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        width: size.width,
        height: size.height,
        child: SizedBox(
          child: Stack(
            children: <Widget>[
              ListView(
                children: [
                  Positioned(
                    top: 100,
                    child: Container(
                      color: Colors.transparent,
                      width: size.width,
                      child: Text(
                        '¿A qué hora te acuestas y te levantas?',
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
                                            // tempNoSelectListDay
                                            // .add(tempListDay[i]);
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
                                          color: Colors.transparent,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                tempNoSelectListDay[i],
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.barlow(
                                                  fontSize: 20.0,
                                                  wordSpacing: 1,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.normal,
                                                  color: _selectedDays.contains(
                                                          tempNoSelectListDay[
                                                              i])
                                                      ? Colors.amber
                                                      : Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                color: _selectedDays.contains(
                                                        tempNoSelectListDay[i])
                                                    ? Colors.amber
                                                    : Colors.white,
                                                height: _selectedDays.contains(
                                                        tempNoSelectListDay[i])
                                                    ? 3
                                                    : 1,
                                                width: 50,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Positioned(
                                  top: (250),
                                  child: rowTimeSelectorRest,
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
                        noSelectDay++;
                        tempList.add(noSelectDay);
                        if (tempDicRest.length == 7) {
                          userRestVC.saveUserRestTime(context, tempDicRest);
                          // mostrarAlerta(
                          // context, "Seguardaron los datos correctamente");

                          //TODO: Colocar navegacion al preview de las horas de descanzo
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PreviewRestTimePage()),
                          );
                          setState(() {});
                          return;
                        } else if (tempDicRest.isEmpty &&
                            _selectedDays.length == 7) {
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
                          userRestVC.saveUserRestTime(context, tempDicRest);
                          mostrarAlerta(
                              context, "Se guardaron los datos correctamente");

                          //TODO: Colocar navegacion al preview de las horas de descanzo
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PreviewRestTimePage()),
                          );
                          setState(() {});
                          return;
                        }
                        if (_selectedDays.length < 7) {
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

                          mostrarAlerta(context,
                              "debes seleccionar los dias restantes antes de continuar");
                          setState(() {});
                        }
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
      // if (time.hour <= 11) {
      //   TimeOfDay timeOfDay = const TimeOfDay(hour: 12, minute: 00);
      //   // ignore: use_build_context_synchronously
      //   timeLblPM = timeOfDay.format(context);
      // } else {
      //   // ignore: use_build_context_synchronously
      //   timeLblPM = time.format(context);
      // }

      // "${time.hour}:${time.minute}";
      setState(() {});
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
      // if (time.hour > 11) {
      //   TimeOfDay timeOfDay = const TimeOfDay(hour: 13, minute: 0);
      //   // ignore: use_build_context_synchronously

      //   // timeLblAM = _timeC.text;
      // } else {
      //   // ignore: use_build_context_synchronously
      //   timeLblAM = time.format(context);
      //   // timeLblAM = _timeC.text;
      // }
      setState(() {});
    }
  }

  // Widget _createButtonNext() {
  //   return ElevatedButton.icon(
  //     style: ButtonStyle(
  //         backgroundColor:
  //             MaterialStateProperty.all<Color>(ColorPalette.principal)),
  //     label: const Text(Constant.nextTxt),
  //     icon: const Icon(
  //       Icons.next_plan,
  //     ),
  //     onPressed: (() {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const UserInactivityPage()),
  //       );
  //     }),
  //   );
  // }
}

// class ScheduleSelector extends StatefulWidget {
//   @override
//   _ScheduleSelectorState createState() => _ScheduleSelectorState();
// }

// class _ScheduleSelectorState extends State<ScheduleSelector> {
//   List<String> _selectedDays = [];
//   List<String> _days = [
//     'Lunes',
//     'Martes',
//     'Miercoles',
//     'Jueves',
//     'Viernes',
//     'Sabado',
//     'Domingo'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         for (var i = 0; i < _days.length; i++)
//           CheckboxListTile(
//             value: _selectedDays.contains(_days[i]),
//             onChanged: (value) {
//               setState(() {
//                 if (_selectedDays.contains(_days[i])) {
//                   _selectedDays.remove(_days[i]);
//                 } else {
//                   _selectedDays.add(_days[i]);
//                 }
//               });
//             },
//             title: Text(_days[i]),
//           ),
//         if (_selectedDays.length < 7)
//           ElevatedButton(
//             style: ButtonStyle(
//               shadowColor: MaterialStateProperty.all<Color>(
//                 Colors.transparent,
//               ),
//               backgroundColor: MaterialStateProperty.all<Color>(
//                 Colors.transparent,
//               ),
//             ),
//             child: Container(
//                 decoration: const BoxDecoration(
//                   color: Color.fromRGBO(219, 177, 42, 1),
//                   borderRadius: BorderRadius.all(Radius.circular(100)),
//                 ),
//                 height: 42,
//                 width: 200,
//                 child: const Center(child: Text('Seleccionar dias restantes'))),
//             onPressed: () {},
//           ),
//         if (_selectedDays.length == 7)
//           ElevatedButton(
//             style: ButtonStyle(
//               shadowColor: MaterialStateProperty.all<Color>(
//                 Colors.transparent,
//               ),
//               backgroundColor: MaterialStateProperty.all<Color>(
//                 Colors.transparent,
//               ),
//             ),
//             child: Container(
//                 decoration: const BoxDecoration(
//                   color: Color.fromRGBO(219, 177, 42, 1),
//                   borderRadius: BorderRadius.all(Radius.circular(100)),
//                 ),
//                 height: 42,
//                 width: 200,
//                 child: const Center(child: Text('Continuar'))),
//             onPressed: () {},
//           ),
//       ],
//     );
//   }
// }

// var children2 = [
//   GestureDetector(
//     onTap: () {
//       print("object");
//       setState(() {
//         if (_selectedDays.contains(tempListDay[0])) {
//           _selectedDays.remove(tempListDay[0]);
//           tempNoSelectListDay.add(tempListDay[0]);
//         } else {
//           _selectedDays.add(tempListDay[0]);
//           tempNoSelectListDay.remove(tempListDay[0]);
//         }
//       });
//     },
//     child: Container(
//       width: size.width / 7,
//       color: Colors.transparent,
//       child: Column(
//         children: [
//           Text(
//             'L',
//             textAlign: TextAlign.center,
//             style: GoogleFonts.barlow(
//               fontSize: 20.0,
//               wordSpacing: 1,
//               letterSpacing: 1,
//               fontWeight: FontWeight.normal,
//               color: _selectedDays.contains(tempListDay[0])
//                   ? Colors.amber
//                   : Colors.white,
//             ),
//           ),
//           Container(
//             color: _selectedDays.contains(tempListDay[0])
//                 ? Colors.amber
//                 : Colors.white,
//             height: _selectedDays.contains(tempListDay[0]) ? 3 : 1,
//             width: 50,
//           ),
//         ],
//       ),
//     ),
//   ),
//   GestureDetector(
//     onTap: () {
//       print("object");
//       setState(() {
//         if (_selectedDays.contains(tempListDay[1])) {
//           _selectedDays.remove(tempListDay[1]);
//           tempNoSelectListDay.add(tempListDay[1]);
//         } else {
//           _selectedDays.add(tempListDay[1]);
//           tempNoSelectListDay.remove(tempListDay[1]);
//         }
//       });
//     },
//     child: Container(
//       width: size.width / 7,
//       color: Colors.transparent,
//       child: Column(
//         children: [
//           Text(
//             'M',
//             textAlign: TextAlign.center,
//             style: GoogleFonts.barlow(
//               fontSize: 20.0,
//               wordSpacing: 1,
//               letterSpacing: 1,
//               fontWeight: FontWeight.normal,
//               color: _selectedDays.contains(tempListDay[1])
//                   ? Colors.amber
//                   : Colors.white,
//             ),
//           ),
//           Container(
//             color: _selectedDays.contains(tempListDay[1])
//                 ? Colors.amber
//                 : Colors.white,
//             height: _selectedDays.contains(tempListDay[1]) ? 3 : 1,
//             width: 50,
//           ),
//         ],
//       ),
//     ),
//   ),
//   GestureDetector(
//     onTap: () {
//       print("object");
//       setState(() {
//         if (_selectedDays.contains(tempListDay[2])) {
//           _selectedDays.remove(tempListDay[2]);
//           tempNoSelectListDay.add(tempListDay[2]);
//         } else {
//           _selectedDays.add(tempListDay[2]);
//           tempNoSelectListDay.remove(tempListDay[2]);
//         }
//       });
//     },
//     child: Container(
//       width: size.width / 7,
//       color: Colors.transparent,
//       child: Column(
//         children: [
//           Text(
//             'X',
//             textAlign: TextAlign.center,
//             style: GoogleFonts.barlow(
//               fontSize: 20.0,
//               wordSpacing: 1,
//               letterSpacing: 1,
//               fontWeight: FontWeight.normal,
//               color: _selectedDays.contains(tempListDay[2])
//                   ? Colors.amber
//                   : Colors.white,
//             ),
//           ),
//           Container(
//             color: _selectedDays.contains(tempListDay[2])
//                 ? Colors.amber
//                 : Colors.white,
//             height: _selectedDays.contains(tempListDay[2]) ? 3 : 1,
//             width: 50,
//           ),
//         ],
//       ),
//     ),
//   ),
//   GestureDetector(
//     onTap: () {
//       print("object");
//       setState(() {
//         if (_selectedDays.contains(tempListDay[3])) {
//           _selectedDays.remove(tempListDay[3]);
//           tempNoSelectListDay.add(tempListDay[3]);
//         } else {
//           _selectedDays.add(tempListDay[3]);
//           tempNoSelectListDay.remove(tempListDay[3]);
//         }
//       });
//     },
//     child: Container(
//       width: size.width / 7,
//       color: Colors.transparent,
//       child: Column(
//         children: [
//           Text(
//             'J',
//             textAlign: TextAlign.center,
//             style: GoogleFonts.barlow(
//               fontSize: 20.0,
//               wordSpacing: 1,
//               letterSpacing: 1,
//               fontWeight: FontWeight.normal,
//               color: _selectedDays.contains(tempListDay[3])
//                   ? Colors.amber
//                   : Colors.white,
//             ),
//           ),
//           Container(
//             color: _selectedDays.contains(tempListDay[3])
//                 ? Colors.amber
//                 : Colors.white,
//             height: _selectedDays.contains(tempListDay[3]) ? 3 : 1,
//             width: 50,
//           ),
//         ],
//       ),
//     ),
//   ),
//   GestureDetector(
//     onTap: () {
//       print("object");
//       setState(() {
//         if (_selectedDays.contains(tempListDay[4])) {
//           _selectedDays.remove(tempListDay[4]);
//           tempNoSelectListDay.add(tempListDay[4]);
//         } else {
//           _selectedDays.add(tempListDay[4]);
//           tempNoSelectListDay.remove(tempListDay[4]);
//         }
//       });
//     },
//     child: Container(
//       width: size.width / 7,
//       color: Colors.transparent,
//       child: Column(
//         children: [
//           Text(
//             'V',
//             textAlign: TextAlign.center,
//             style: GoogleFonts.barlow(
//               fontSize: 20.0,
//               wordSpacing: 1,
//               letterSpacing: 1,
//               fontWeight: FontWeight.normal,
//               color: _selectedDays.contains(tempListDay[4])
//                   ? Colors.amber
//                   : Colors.white,
//             ),
//           ),
//           Container(
//             color: _selectedDays.contains(tempListDay[4])
//                 ? Colors.amber
//                 : Colors.white,
//             height: _selectedDays.contains(tempListDay[4]) ? 3 : 1,
//             width: 50,
//           ),
//         ],
//       ),
//     ),
//   ),
//   GestureDetector(
//     onTap: () {
//       print("object");
//       setState(() {
//         if (_selectedDays.contains(tempListDay[5])) {
//           _selectedDays.remove(tempListDay[5]);
//           tempNoSelectListDay.add(tempListDay[5]);
//         } else {
//           _selectedDays.add(tempListDay[5]);
//           tempNoSelectListDay.remove(tempListDay[5]);
//         }
//       });
//     },
//     child: Container(
//       width: size.width / 7,
//       color: Colors.transparent,
//       child: Column(
//         children: [
//           Text(
//             'S',
//             textAlign: TextAlign.center,
//             style: GoogleFonts.barlow(
//               fontSize: 20.0,
//               wordSpacing: 1,
//               letterSpacing: 1,
//               fontWeight: FontWeight.normal,
//               color: _selectedDays.contains(tempListDay[5])
//                   ? Colors.amber
//                   : Colors.white,
//             ),
//           ),
//           Container(
//             color: _selectedDays.contains(tempListDay[5])
//                 ? Colors.amber
//                 : Colors.white,
//             height: _selectedDays.contains(tempListDay[5]) ? 3 : 1,
//             width: 50,
//           ),
//         ],
//       ),
//     ),
//   ),
//   GestureDetector(
//     onTap: () {
//       print("object");
//       setState(() {
//         if (_selectedDays.contains(tempListDay[6])) {
//           _selectedDays.remove(tempListDay[6]);
//           tempNoSelectListDay.add(tempListDay[6]);
//         } else {
//           _selectedDays.add(tempListDay[6]);
//           tempNoSelectListDay.remove(tempListDay[6]);
//         }
//       });
//     },
//     child: Container(
//       width: size.width / 7,
//       color: Colors.transparent,
//       child: Center(
//         child: Column(
//           children: [
//             Text(
//               'D',
//               textAlign: TextAlign.center,
//               style: GoogleFonts.barlow(
//                 fontSize: 20.0,
//                 wordSpacing: 1,
//                 letterSpacing: 1,
//                 fontWeight: FontWeight.normal,
//                 color: _selectedDays.contains(tempListDay[6])
//                     ? Colors.amber
//                     : Colors.white,
//               ),
//             ),
//             Container(
//               color: _selectedDays.contains(tempListDay[6])
//                   ? Colors.amber
//                   : Colors.white,
//               height: _selectedDays.contains(tempListDay[6]) ? 3 : 1,
//               width: 50,
//             )
//           ],
//         ),
//       ),
//     ),
//   ),
// ];

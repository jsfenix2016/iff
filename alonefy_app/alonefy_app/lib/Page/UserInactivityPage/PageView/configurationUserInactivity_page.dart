import 'dart:collection';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/activityDay.dart';
import 'package:ifeelefine/Model/activitydaybd.dart';
import 'package:ifeelefine/Page/FallDetected/Pageview/fall_activation_page.dart';
import 'package:ifeelefine/Page/UserInactivityPage/Controller/inactivityViewController.dart';
import 'package:ifeelefine/Page/UserInactivityPage/PageView/previewInactivityPage.dart';
import 'package:ifeelefine/Utils/Widgets/containerTextEditAndTime.dart';
import 'package:ifeelefine/Utils/Widgets/customDropDown.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

class UserInactivityPage extends StatefulWidget {
  const UserInactivityPage({super.key});

  @override
  State<UserInactivityPage> createState() => _UserInactivityPageState();
}

class _UserInactivityPageState extends State<UserInactivityPage> {
  final InactivityViewController inactVC = Get.put(InactivityViewController());

  var isVisible = false;
  var expandHeigth = 120.0;
  var expandHeigthDaySelect = 210.0;
  var indexSelect = -1;
  var indexInsert = 0;
  var daySelect = "";

  List<ActivityDayBD> tempDicRest = [];
  List<ActivityDay> selecDicActivity = <ActivityDay>[];
  List<ActivityDayBD> selecDicActivityTemp = <ActivityDayBD>[];
  Map<String, List<ActivityDayBD>> groupedProducts = {};
  final List<int> tempListConfig = <int>[];
  late ActivityDay temp;
  final List<String> tempListDay = <String>[];

  @override
  void initState() {
    temp = ActivityDay();
    temp.day = "";
    temp.activity = "";
    getInactivity();
    super.initState();
  }

  List<ActivityDayBD> lista = [];

  Future<void> removeActivity(
      BuildContext cont, ActivityDay act, int index) async {
    var a = await inactVC.deleteInactivity(cont, act);

    if (a == 0) {
      setState(() {});
    }
  }

  List<ActivityDayBD> sortWeekdays(List<ActivityDayBD> weekdays) {
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

  Future<void> getInactivity() async {
    var listA = await inactVC.getInactivity();

    groupedProducts = groupBy(listA, (product) => product.day);
    groupedProducts.forEach((key, value) {
      selecDicActivityTemp.add(value.first);
    });

    groupedProducts.forEach((key, value) {
      for (int i = 0; i < value.length; i++) {
        lista.add(value[i]);
        var select = ActivityDay();
        select.activity = value[i].activity;
        select.timeSleep = value[i].timeSleep;
        select.timeWakeup = value[i].timeWakeup;
        select.day = value[i].day;
        select.id = value[i].id;
        selecDicActivity.add(select);
      }
    });

    if (selecDicActivity.isNotEmpty) {
      isVisible = true;
    }

    setState(() {});
  }

  void _selectOption(ActivityDay value) {
    selecDicActivity.removeAt(value.id);
    selecDicActivity.insert(value.id, value);
    setState(() {});
  }

  void addItemToList() {
    var select = ActivityDay();
    select.activity = "Actividad";
    select.timeSleep = "00:00 PM";
    select.timeWakeup = "00:00 AM";
    select.day = daySelect;
    select.id = 0;
    selecDicActivity.insert(0, select);

    if (isVisible) {
      expandHeigth = expandHeigth + 50;
    } else {
      isVisible = true;
      expandHeigth = 120;
    }
    indexInsert += 1;
    setState(() {});
  }

  Widget _createButtonAddActivity() {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.principal)),
      label: const Text("Agregar actividad"),
      icon: const Icon(
        Icons.add,
      ),
      onPressed: (() {
        addItemToList();
      }),
    );
  }

  Widget _createButtonNext() {
    return ElevateButtonFilling(
      onChanged: (value) async {
        if (selecDicActivity.isEmpty) {
          mostrarAlertaTwoButton(context,
              'No has agregado ninguna actividad,  ¿deseas continuar?');
        } else {
          var id = await inactVC.saveInactivity(context, selecDicActivity);
          if (id != -1) {
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PreviewInactivityPage()),
            );
          }
        }
      },
      mensaje: Constant.nextTxt,
    );
  }

  void mostrarAlertaTwoButton(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Información"),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              child: const Text("cerrar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(Constant.continueTxt),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FallActivationPage(),
                  ),
                ),
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Actividades en la semana',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 60.0, left: 8.0, right: 8.0),
                    child: Text(
                      '¿Tienes actividades culturales en la semana?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.barlow(
                        fontSize: 22.0,
                        wordSpacing: 1,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(219, 177, 42, 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: CustomDropdownButtonWidgetWithDictionary(
                      instance: Constant.weekend,
                      mensaje: "Seleccionar dia de la actividad",
                      isVisible: true,
                      onChanged: (value) {
                        daySelect = value.day;
                      },
                    ),
                  ),
                  _createButtonAddActivity(),
                  Visibility(
                    visible: isVisible,
                    child: Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: selecDicActivity.length,
                        itemBuilder: (BuildContext context, int index) {
                          selecDicActivity[index].id = index;
                          selecDicActivity[index].activity == ""
                              ? "Actividad"
                              : selecDicActivity[index].activity;

                          selecDicActivity[index].timeSleep == "00: 00 PM"
                              ? "00: 00 PM"
                              : selecDicActivity[index].timeSleep;

                          selecDicActivity[index].timeWakeup == "00: 00 AM"
                              ? "00: 00 AM"
                              : selecDicActivity[index].timeWakeup;
                          return InkWell(
                            onTap: () {},
                            child: Dismissible(
                              onDismissed: ((direction) => {
                                    setState(() {
                                      indexInsert -= 1;
                                      expandHeigth = expandHeigth - 70;
                                      var act = selecDicActivity[index];
                                      selecDicActivity.removeAt(index);
                                      removeActivity(context, act, index);
                                    })
                                  }),
                              key: Key(selecDicActivity.length.toString()),
                              child: ContainerTextEditTime(
                                day: selecDicActivity[index].day,
                                acti: selecDicActivity[index],
                                onChanged: (value) {
                                  value.id = index;
                                  selecDicActivity[index].id = index;
                                  selecDicActivity[index].day = value.day;
                                  selecDicActivity[index].activity =
                                      value.activity;
                                  selecDicActivity[index].timeSleep =
                                      value.timeSleep;
                                  selecDicActivity[index].timeWakeup =
                                      value.timeWakeup;

                                  _selectOption(value);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 20,
                child: _createButtonNext(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

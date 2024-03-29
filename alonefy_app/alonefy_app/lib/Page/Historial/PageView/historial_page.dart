import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/historialbd.dart';

import 'package:ifeelefine/Model/logActivityBd.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Historial/Controller/historial_controller.dart';
import 'package:ifeelefine/Page/Historial/Widgets/cell_date_risk.dart';

import 'package:ifeelefine/Page/Historial/Widgets/cell_log_alert.dart';
import 'package:ifeelefine/Page/Historial/Widgets/cell_zone_risk.dart';
import 'package:ifeelefine/Utils/Widgets/loading_page.dart';

import 'package:ifeelefine/Common/decoration_custom.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  final HistorialController alertsVC = Get.put(HistorialController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic> listAlerts = [];
  Map<String, List<LogAlertsBD>> groupedProducts = {};
  Map<String, List<dynamic>> groupedAlert = {};
  // late LogAlertsBD listLog;
  // late LogActivityBD listLogActive;
  bool isLoading = true;

  Future<void> getLog() async {
    // listLog = LogAlertsBD(
    //     id: 0, type: "no hay alertas", time: DateTime.now(), groupBy: "-1");
    // listLogActive = LogActivityBD(
    //     movementType: "no hay actividad", time: DateTime.now(), groupBy: "-1");
    groupedProducts = {};
    groupedAlert = {};
    groupedAlert = await alertsVC.getAllAlerts();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteForDayMov(
      BuildContext context, List<HistorialBD> time) async {
    groupedProducts = {};

    // var req = await alertsVC.deleteAlerts(context, time);
    // if (req == 0) {
    //   getLog();
    // }
  }

  @override
  void initState() {
    // getLog();
    starTap();
    super.initState();
  }

  Widget alertDate(HistorialBD logAlert) {
    return LimitedBox(
      maxHeight: 160,
      child: GestureDetector(
        onTap: () {},
        child: ListTile(
          title: CellDateRisk(logAlert: logAlert),
        ),
      ),
    );
  }

  Widget alertZone(HistorialBD logAlert) {
    return LimitedBox(
      maxHeight: 170,
      child: GestureDetector(
        onTap: () {},
        child: ListTile(
          title: Center(
            child: CellZoneRisk(logAlert: logAlert),
          ),
        ),
      ),
    );
  }

  Widget alertLogWidget(HistorialBD logAlert) {
    return LimitedBox(
      maxHeight: 100,
      child: GestureDetector(
        onTap: () {},
        child: ListTile(
          title: Center(
            child: CellLogAlerts(logAlert: logAlert),
          ),
        ),
      ),
    );
  }

  Widget generic(dynamic alert) {
    var alertLog = (alert as HistorialBD);
    if (alertLog.type.contains("Cita")) {
      return alertDate((alert));
    }

    if (alertLog.type == ("Zona - Cancelada") ||
        alertLog.type == ("Zona - Iniciada")) {
      return alertLogWidget((alert));
    }

    if (alertLog.type.contains("Zona")) {
      if ((alertLog.video == null && alertLog.listVideosPresigned == null)) {
        return alertLogWidget((alert));
      }
      return alertZone((alert));
    }

    if (alertLog.type.contains("Inactividad") ||
        alertLog.type.contains("normal") ||
        alertLog.type.contains("rudo") ||
        alertLog.type.contains("Caida") ||
        alertLog.type.contains("inactividad") ||
        alertLog.type.contains("SMS")) {
      return alertLogWidget((alert));
    }
    Widget temp = SizedBox.shrink();
    return temp;
  }

  Future<List<MapEntry<String, List<dynamic>>>> getList() async {
    groupedProducts = {};
    groupedAlert = {};
    groupedAlert = await alertsVC.getAllAlerts();
    return groupedAlert.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    RedirectViewNotifier.setStoredContext(context);
    return LoadingIndicator(
      isLoading: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.brown,
          title: Text(
            "Historial",
            style: textForTitleApp(),
          ),
        ),
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
            decoration: decorationCustom2(),
            width: size.width,
            height: size.height,
            child: GetBuilder<HistorialController>(builder: (contextVC) {
              return FutureBuilder<List<MapEntry<String, List<dynamic>>>>(
                  future: getList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final listData = snapshot.data!;
                      return ListView.separated(
                        physics:
                            const ClampingScrollPhysics(), // Agrega esta línea
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: listData.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(11, 11, 10, 0.6),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              width: size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 18.0),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Container(
                                        width: size.width,
                                        color: Colors.transparent,
                                        child: ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              height: 5,
                                              child: Divider(
                                                height: 1,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              listData[i].value.toList().length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            listAlerts =
                                                listData[i].value.toList();

                                            return generic(listAlerts[index]);
                                          },
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: false,
                                      child: Positioned(
                                        right: 10,
                                        child: IconButton(
                                          iconSize: 35,
                                          onPressed: () {
                                            List key = listData[i].value;

                                            groupedAlert
                                                .remove(listData[i].key);
                                            var temp = key;
                                            print(temp);
                                            // deleteForDayMov(context, temp);
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Text("");
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorPalette.calendarNumber,
                        ),
                      );
                    }
                  });
            }),
          ),
        ),
      ),
    );
  }
}

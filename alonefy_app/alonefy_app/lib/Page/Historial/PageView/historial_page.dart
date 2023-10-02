import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logActivity.dart';
import 'package:ifeelefine/Model/logActivityBd.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Historial/Controller/historial_controller.dart';
import 'package:ifeelefine/Page/Historial/Widgets/cell_date_risk.dart';
import 'package:ifeelefine/Page/Historial/Widgets/cell_log_activity.dart';
import 'package:ifeelefine/Page/Historial/Widgets/cell_log_alert.dart';
import 'package:ifeelefine/Page/Historial/Widgets/cell_zone_risk.dart';
import 'package:ifeelefine/main.dart';

import 'package:notification_center/notification_center.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  final HistorialController alertsVC = Get.put(HistorialController());

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, List<LogAlertsBD>> groupedProducts = {};
  Map<String, List<dynamic>> groupedAlert = {};
  late LogAlertsBD listLog;
  late LogActivityBD listLogActive;

  Future<void> getLog() async {
    listLog = LogAlertsBD(
      id: 0,
      type: "no hay alertas",
      time: DateTime.now(),
    );
    listLogActive = LogActivityBD(
      movementType: "no hay actividad",
      time: DateTime.now(),
    );
    groupedProducts = {};
    groupedAlert = {};
    groupedAlert = await alertsVC.getAllAlerts();

    setState(() {});
  }

  Future<void> deleteForDayMov(
      BuildContext context, List<LogAlertsBD> time) async {
    groupedProducts = {};

    var req = await alertsVC.deleteAlerts(context, time);
    if (req == 0) {
      NotificationCenter().notify('getAlerts');
      getLog();
    }
  }

  @override
  void initState() {
    getLog();
    starTap();
    super.initState();
  }

  Widget alertDate(LogAlertsBD logAlert) {
    return LimitedBox(
      maxHeight: 130,
      child: GestureDetector(
        onTap: () {},
        child: ListTile(
          title: CellDateRisk(logAlert: logAlert),
        ),
      ),
    );
  }

  Widget alertZone(LogAlertsBD logAlert) {
    return LimitedBox(
      maxHeight: 190,
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

  Widget alertLogWidget(LogAlertsBD logAlert) {
    return LimitedBox(
      maxHeight: 110,
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
    var alertLog = (alert as LogAlertsBD);
    if (alertLog.type.contains("Cita")) {
      return alertDate((alert));
    }

    if (alertLog.type.contains("Zona")) {
      return alertZone((alert));
    }

    if (alertLog.type.contains("Inactividad") ||
        alertLog.type.contains("normal") ||
        alertLog.type.contains("rudo") ||
        alertLog.type.contains("inactividad") ||
        alertLog.type.contains("SMS")) {
      return alertLogWidget((alert));
    }
    Widget temp = Container();
    return temp;
  }

  List<dynamic> listAlerts = [];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<MapEntry<String, List<dynamic>>> listData =
        groupedAlert.entries.toList();
    RedirectViewNotifier.setStoredContext(context);
    return Scaffold(
      backgroundColor: Colors.black,
      key: scaffoldKey,
      appBar: AppBar(
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
          child: ListView.separated(
            physics: const ClampingScrollPhysics(), // Agrega esta línea
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: listData.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.only(left: 36.0, right: 36.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(11, 11, 10, 0.6),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Container(
                            width: 300,
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
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: listData[i].value.toList().length,
                              itemBuilder: (BuildContext context, int index) {
                                listAlerts = listData[i].value.toList();

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
                                var a = listData[i];
                                // int index = listData
                                //     .indexWhere((entry) => entry.key == key);
                                // if (index != -1) {
                                //   listData[index] = MapEntry(key,
                                //       listData[index].value..remove(listData[i]));
                                // }
                                // List<LogAlertsBD> listaLogAlertsBD =
                                //     listData[i].value.map((dynamic item) {
                                //   return LogAlertsBD(
                                //     id: item["id"],
                                //     type: item["type"],
                                //     time: item["time"],
                                //     photoDate:
                                //   );
                                // }).toList();
                                // var a = listaLogAlertsBD;
                                groupedAlert.remove(listData[i].key);
                                var temp = key;
                                print(temp);
                                // deleteForDayMov(context, temp);
                                print("object");
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
          ),
        ),
      ),
    );
  }
}

// class LinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = ColorPalette.principal
//       ..strokeWidth = 1.5;

//     canvas.drawLine(
//         const Offset(0.0, 70 / 2), Offset(size.width, size.height / 2), paint);
//   }

//   @override
//   bool shouldRepaint(LinePainter oldDelegate) => false;
// }

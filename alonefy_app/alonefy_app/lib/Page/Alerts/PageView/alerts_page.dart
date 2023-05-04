import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Alerts/Controller/alertsController.dart';

import 'package:notification_center/notification_center.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final AlertsController alertsVC = Get.put(AlertsController());

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, List<LogAlertsBD>> groupedProducts = {};
  late List<LogAlertsBD> listLog;
  final _group = ValueNotifier<Map<String, List<LogAlertsBD>>>({});

  Future<void> getLog() async {
    groupedProducts = {};

    groupedProducts = await alertsVC.getAllMov();
    _group.value = groupedProducts;
    setState(() {});
  }

  Future<void> deleteForDayMov(
      BuildContext context, List<LogAlertsBD> listLog) async {
    groupedProducts = {};

    var req = await alertsVC.deleteAlerts(context, listLog);
    if (req == 0) {
      NotificationCenter().notify('getAlerts');
      getLog();
    }
  }

  Container searchImageForIcon(String typeAction) {
    AssetImage name = const AssetImage('assets/images/Email.png');
    if (typeAction.contains("SMS")) {
      name = const AssetImage('assets/images/Email.png');
    } else if (typeAction.contains("inactividad")) {
      name = const AssetImage('assets/images/Warning.png');
    } else if (typeAction.contains("Notificación")) {
      name = const AssetImage('assets/images/Group 1283.png');
    }

    return Container(
      height: 32,
      width: 31.2,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: name,
        ),
        color: Colors.transparent,
      ),
    );
  }

  @override
  void initState() {
    getLog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final listData = groupedProducts.entries.toList();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Center(child: Text("Alertas")),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: 2,
            colors: [
              ColorPalette.secondView,
              ColorPalette.principalView,
            ],
          ),
        ),
        width: size.width,
        height: size.height,
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            for (var i = 0; i <= listData.length - 1; i++)
              Positioned(
                top: (150),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Expanded(
                      flex: 2,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(11, 11, 10, 0.6),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        width: size.width,
                        child: Stack(
                          children: [
                            Positioned(
                              right: 10,
                              child: IconButton(
                                iconSize: 35,
                                onPressed: () {
                                  var a = listData[i];
                                  deleteForDayMov(context, a.value);
                                  print("object");
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                width: 310,
                                color: Colors.transparent,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemExtent: 70.0,
                                    itemCount:
                                        listData[i].value.toList().length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var listAlerts =
                                          listData[i].value.toList();
                                      listLog = listAlerts;
                                      return ListTile(
                                        title: Container(
                                          color: Colors.transparent,
                                          height: 70,
                                          width: 300,
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: 300,
                                                color: Colors.transparent,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      iconSize: 35,
                                                      color: ColorPalette
                                                          .principal,
                                                      onPressed: () {},
                                                      icon: searchImageForIcon(
                                                          listAlerts[index]
                                                              .typeAction),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      height: 70,
                                                      width: size.width - 166,
                                                      child: Stack(children: [
                                                        Positioned(
                                                          top: 10,
                                                          child: Text(
                                                            listAlerts[index]
                                                                .typeAction,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: GoogleFonts
                                                                .barlow(
                                                              fontSize: 16.0,
                                                              wordSpacing: 1,
                                                              letterSpacing:
                                                                  0.001,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 40,
                                                          child: Text(
                                                            '${listAlerts[index].time.day}-${listAlerts[index].time.month}-${listAlerts[index].time.year} | ${listAlerts[index].time.hour}:${listAlerts[index].time.minute}',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: GoogleFonts
                                                                .barlow(
                                                              fontSize: 16.0,
                                                              wordSpacing: 1,
                                                              letterSpacing:
                                                                  0.001,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              index >= 0 &&
                                                      index <
                                                          listAlerts.length - 1
                                                  ? Positioned(
                                                      left: 25,
                                                      top: 100 /
                                                          2, // La posición horizontal de la línea
                                                      child: CustomPaint(
                                                        painter: _LinePainter(),
                                                      ),
                                                    )
                                                  : const SizedBox(
                                                      height: 0,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
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
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorPalette.principal
      ..strokeWidth = 1.5;

    canvas.drawLine(
        const Offset(0.0, 70 / 2), Offset(size.width, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(_LinePainter oldDelegate) => false;
}

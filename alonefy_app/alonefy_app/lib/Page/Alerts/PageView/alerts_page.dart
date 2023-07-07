import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/button_style_custom.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Alerts/Controller/alertsController.dart';
import 'package:ifeelefine/Page/Alerts/Widget/list_alert.dart';
import 'package:ifeelefine/Page/Disamble/Pageview/disambleIfeelfine_page.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

import 'package:notification_center/notification_center.dart';

class AlertsPage extends StatefulWidget {
  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final AlertsController alertsVC = Get.put(AlertsController());

  final scaffoldKey = GlobalKey<ScaffoldState>();

  RxMap<String, List<LogAlertsBD>> groupedProducts =
      RxMap<String, List<LogAlertsBD>>();
  late List<LogAlertsBD> listLog;
  final _group = ValueNotifier<RxMap<String, List<LogAlertsBD>>>(
      RxMap<String, List<LogAlertsBD>>());

  Future<void> getLog() async {
    groupedProducts.value = {};

    groupedProducts.value = await alertsVC.getAllMov();
    _group.value = groupedProducts;
    setState(() {});
  }

  Future<void> deleteForDayMov(
      BuildContext context, List<LogAlertsBD> listLog) async {
    groupedProducts.value = {};

    var req = await alertsVC.deleteAlerts(context, listLog);
    if (req == 0) {
      NotificationCenter().notify('getAlerts');
      getLog();
    }
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
        title: const Text("Alertas"),
      ),
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: ListView.builder(
          itemCount: listData.length,
          itemBuilder: (BuildContext context, int i) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    width: size.width,
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
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemExtent: 130.0,
                                itemCount: listData[i].value.toList().length,
                                itemBuilder: (BuildContext context, int index) {
                                  var listAlerts = listData[i].value.toList();
                                  listLog = listAlerts;
                                  return ListTile(
                                    title: Container(
                                      color: Colors.transparent,
                                      height: 130,
                                      width: 300,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 300,
                                            color: Colors.transparent,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  iconSize: 35,
                                                  color: ColorPalette.principal,
                                                  onPressed: () {},
                                                  icon: searchImageForIcon(
                                                      listAlerts[index].type),
                                                ),
                                                Container(
                                                  color: Colors.transparent,
                                                  height: 70,
                                                  width: size.width - 166,
                                                  child: Stack(children: [
                                                    Positioned(
                                                      top: 10,
                                                      child: Text(
                                                        listAlerts[index].type,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style:
                                                            textNormal16White(),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 40,
                                                      child: Text(
                                                        '${listAlerts[index].time.day}-${listAlerts[index].time.month}-${listAlerts[index].time.year} | ${listAlerts[index].time.hour}:${listAlerts[index].time.minute}',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style:
                                                            textNormal16White(),
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          index >= 0 &&
                                                  index < listAlerts.length - 1
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
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: ElevateButtonFilling(
                        onChanged: (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DesactivePage(
                                isMenu: false,
                              ),
                            ),
                          );
                        },
                        mensaje: "Desactivar",
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
        const Offset(0.0, 170 / 2), Offset(size.width, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(_LinePainter oldDelegate) => false;
}

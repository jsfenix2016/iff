import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:notification_center/notification_center.dart';

import '../Controller/alertsController.dart';

class ListAlert extends StatefulWidget {
  ListAlert({super.key, required this.list});
  List<LogAlertsBD> list;
  @override
  State<ListAlert> createState() => _ListAlertState();
}

class _ListAlertState extends State<ListAlert> {
  final AlertsController alertsVC = Get.find<AlertsController>();

  // Map<String, List<LogAlertsBD>> groupedProducts = {};
  // late List<LogAlertsBD> listLog;
  // final _group = ValueNotifier<Map<String, List<LogAlertsBD>>>({});

  // Future<Map<String, List<LogAlertsBD>>> getLog() async {
  //   groupedProducts = {};

  //   groupedProducts = await alertsVC.getAllMov();
  //   _group.value = groupedProducts;

  //   return groupedProducts;
  // }

  // Future<void> deleteForDayMov(
  //     BuildContext context, List<LogAlertsBD> listLog) async {
  //   groupedProducts = {};

  //   var req = await alertsVC.deleteAlerts(context, listLog);
  //   if (req == 0) {
  //     NotificationCenter().notify('getAlerts');
  //     // getLog();
  //   }
  // }

  @override
  void initState() {
    // getLog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        width: 310,
        color: Colors.transparent,
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemExtent: 70.0,
            itemCount: widget.list.length,
            itemBuilder: (BuildContext context, int index) {
              var listAlerts = widget.list.toList();
              // listLog = listAlerts;
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              iconSize: 35,
                              color: ColorPalette.principal,
                              onPressed: () {},
                              icon: searchImageForIcon(listAlerts[index].type),
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
                                    textAlign: TextAlign.left,
                                    style: textNormal16White(),
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  child: Text(
                                    '${listAlerts[index].time.day}-${listAlerts[index].time.month}-${listAlerts[index].time.year} | ${listAlerts[index].time.hour}:${listAlerts[index].time.minute}',
                                    textAlign: TextAlign.left,
                                    style: textNormal16White(),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      index >= 0 && index < listAlerts.length - 1
                          ? Positioned(
                              left: 25,
                              top:
                                  100 / 2, // La posición horizontal de la línea
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Disamble/Pageview/disambleIfeelfine_page.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:notification_center/notification_center.dart';

import '../Controller/alertsController.dart';

class ListAlert extends StatefulWidget {
  ListAlert({super.key, required this.listData, required this.onChangedDelete});
  List<MapEntry<String, List<LogAlertsBD>>> listData;
  final ValueChanged<List<LogAlertsBD>> onChangedDelete;
  @override
  State<ListAlert> createState() => _ListAlertState();
}

class _ListAlertState extends State<ListAlert> {
  final AlertsController alertsVC = Get.find<AlertsController>();
  late List<LogAlertsBD> listLog;
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.listData.length,
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
                            var a = widget.listData[i];
                            // deleteForDayMov(context, a.value);
                            widget.onChangedDelete(a.value);
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
                          width: 290,
                          color: Colors.transparent,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemExtent: 115.0,
                            itemCount: widget.listData[i].value.toList().length,
                            itemBuilder: (BuildContext context, int index) {
                              var listAlerts =
                                  widget.listData[i].value.toList();
                              listLog = listAlerts;
                              return ListTile(
                                title: Container(
                                  color: Colors.transparent,
                                  height: 130,
                                  width: 290,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 290,
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
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                color: Colors.transparent,
                                                height: 70,
                                                child: Stack(children: [
                                                  Positioned(
                                                    top: 10,
                                                    child: Text(
                                                      listAlerts[index].type,
                                                      textAlign: TextAlign.left,
                                                      style:
                                                          textNormal16White(),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 40,
                                                    child: Text(
                                                      '${listAlerts[index].time.day}-${listAlerts[index].time.month}-${listAlerts[index].time.year} | ${listAlerts[index].time.hour}:${listAlerts[index].time.minute}',
                                                      textAlign: TextAlign.left,
                                                      style:
                                                          textNormal16White(),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      index >= 0 &&
                                              index < listAlerts.length - 1
                                          ? Positioned(
                                              left: 25,
                                              top: 140 /
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
                    showIcon: false,
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
                    img: '',
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

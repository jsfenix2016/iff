import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Alerts/Controller/alertsController.dart';
import 'package:ifeelefine/Page/Alerts/Widget/alert_list_group_widget.dart';

import 'package:ifeelefine/Utils/Widgets/loading_page.dart';

import 'package:notification_center/notification_center.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final AlertsController alertsVC = Get.put(AlertsController());

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late List<LogAlertsBD> listLog;
  bool _isLoading = true;

  RxMap<String, Map<String, List<LogAlertsBD>>> newGroup =
      RxMap<String, Map<String, List<LogAlertsBD>>>();
  Future<void> getLog() async {
    newGroup = await alertsVC.getAllMov2();
    newGroup.values;

    _isLoading = false;
    setState(() {});
  }

  Future<void> deleteForDayMov(
      BuildContext context, List<LogAlertsBD> listLog) async {
    // groupedProducts.value = {};

    var req = await alertsVC.deleteAlerts(context, listLog);
    if (req == 0) {
      // NotificationCenter().notify('getAlerts');
      setState(() {});
      getLog();
    }
  }

  @override
  void initState() {
    getLog();
    starTap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    RedirectViewNotifier.setStoredContext(context);
    return LoadingIndicator(
      isLoading: _isLoading,
      child: WillPopScope(
        onWillPop: () async {
          // Aquí puedes ejecutar acciones personalizadas antes de volver atrás
          // Por ejemplo, mostrar un diálogo de confirmación
          starTap();
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          key: scaffoldKey,
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            backgroundColor: Colors.brown,
            title: Text(
              "Alertas",
              style: textForTitleApp(),
            ),
          ),
          body: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Container(
              decoration: decorationCustom2(),
              width: size.width,
              height: size.height,
              child: GetBuilder<AlertsController>(builder: (contextVC) {
                return AlertListWidget(
                  groupedAlerts: newGroup,
                  onChangedDelete: (List<LogAlertsBD> value) {
                    deleteForDayMov(context, value);
                  },
                  onRefresh: (bool value) {
                    alertsVC.update();
                    NotificationCenter().notify('refreshView');
                    setState(() {});
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  ListView listAlertGroup(
      List<MapEntry<String, List<LogAlertsBD>>> listData, Size size) {
    return ListView.builder(
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
                              listAlerts.sort((a, b) {
                                //sorting in descending order
                                return b.time.compareTo(a.time);
                              });
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
              // Positioned(
              //   bottom: 0,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 50.0),
              //     child: ElevateButtonFilling(
              //       showIcon: false,
              //       onChanged: (value) {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => const DesactivePage(
              //               isMenu: false,
              //             ),
              //           ),
              //         );
              //       },
              //       mensaje: "Desactivar",
              //       img: '',
              //     ),
              //   ),
              // ),
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
        const Offset(0.0, 170 / 2), Offset(size.width, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(_LinePainter oldDelegate) => false;
}

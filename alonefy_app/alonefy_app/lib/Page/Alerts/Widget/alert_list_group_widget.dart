import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Disamble/Pageview/disambleIfeelfine_page.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

class AlertListWidget extends StatefulWidget {
  const AlertListWidget(
      {super.key, required this.groupedAlerts, required this.onChangedDelete});
  final Map<String, Map<String, List<LogAlertsBD>>> groupedAlerts;
  final ValueChanged<List<LogAlertsBD>> onChangedDelete;

  @override
  State<AlertListWidget> createState() => _AlertListWidgetState();
}

class _AlertListWidgetState extends State<AlertListWidget> {
  // late List<LogAlertsBD> listLog;
  int selectedCellIndex = -1; // -1 indica que ninguna celda está seleccionada
  bool isExpanded = false;
  String dateRow = "";
  // Map<int, bool> isCellExpandedMap = {};

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
      reverse: false,
      itemCount: widget.groupedAlerts.keys.length,
      itemBuilder: (context, indexGroup) {
        final date = widget.groupedAlerts.keys.elementAt(indexGroup);
        final alertTypes = widget.groupedAlerts[date]!;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          width: 290,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(11, 11, 10, 0.6),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              width: size.width,
              child: Column(
                children: [
                  ListTile(
                    title: Container(
                      color: Colors.transparent,
                      height: 50,
                      child: Stack(
                        children: [
                          Container(
                            width: 320,
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                Container(
                                  color: Colors.transparent,
                                  height: 60,
                                  child: Stack(children: [
                                    Positioned(
                                      top: 20,
                                      child: Text(
                                        date.split(" ").first,
                                        textAlign: TextAlign.left,
                                        style: textNormal16White(),
                                      ),
                                    ),
                                  ]),
                                ),
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    iconSize: 35,
                                    onPressed: () {
                                      final date = widget.groupedAlerts.keys
                                          .elementAt(indexGroup);
                                      final alertTypes =
                                          widget.groupedAlerts[date]!;
                                      print(alertTypes.values.first);
                                      // deleteForDayMov(context, a.value);
                                      widget.onChangedDelete(
                                          alertTypes.values.first);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  for (var alertType in alertTypes.keys.toList()) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          print(
                              "tap: ${widget.groupedAlerts.keys.elementAt(indexGroup)}");
                          final date = widget.groupedAlerts.entries
                              .elementAt(indexGroup);
                          final alertTypes = widget.groupedAlerts[date.key]!;
                          final indexTemp =
                              alertTypes.keys.toList().indexOf(alertType);

                          if (isExpanded && selectedCellIndex == indexTemp) {
                            isExpanded = false;
                          } else {
                            isExpanded = true;
                            selectedCellIndex = indexTemp;
                            dateRow = date.key;
                          }

                          setState(() {});
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: isExpanded &&
                                  selectedCellIndex ==
                                      alertTypes.keys
                                          .toList()
                                          .indexOf(alertType) &&
                                  dateRow ==
                                      widget.groupedAlerts.keys
                                          .elementAt(indexGroup)
                              ? alertTypes[alertType]!.length * 121
                              : 101,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(153, 50, 50, 45),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Container(
                            width: 320,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(153, 50, 50, 45),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    iconSize: 35,
                                    onPressed: () {
                                      print("TAP");
                                    },
                                    icon: isExpanded &&
                                            selectedCellIndex ==
                                                alertTypes.keys
                                                    .toList()
                                                    .indexOf(alertType) &&
                                            dateRow ==
                                                widget.groupedAlerts.keys
                                                    .elementAt(indexGroup)
                                        ? const Icon(
                                            Icons.arrow_drop_up,
                                            color: Colors.white,
                                          )
                                        : const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  reverse: true,
                                  scrollDirection: Axis.vertical,
                                  itemExtent: 120.0,
                                  itemCount: alertTypes[alertType]!.length,
                                  itemBuilder:
                                      (BuildContext context, int indexAlert) {
                                    var listAlerts = alertTypes[alertType]!;
                                    listAlerts.sort((a, b) {
                                      //sorting in descending order
                                      return b.time.compareTo(a.time);
                                    });
                                    return GestureDetector(
                                      onTap: () {
                                        print(
                                            "tap: ${widget.groupedAlerts.keys.elementAt(indexGroup)}");
                                        var a = widget.groupedAlerts.keys
                                            .elementAt(indexGroup);
                                        final date = widget
                                            .groupedAlerts.entries
                                            .elementAt(indexGroup);
                                        final alertTypes =
                                            widget.groupedAlerts[date.key]!;
                                        final indexTemp = alertTypes.keys
                                            .toList()
                                            .indexOf(alertType);

                                        if (isExpanded &&
                                            selectedCellIndex == indexTemp) {
                                          isExpanded = false;
                                        } else {
                                          isExpanded = true;
                                          selectedCellIndex = indexTemp;
                                          dateRow = date.key;
                                        }

                                        setState(() {});
                                      },
                                      child: ListTile(
                                        title: Center(
                                          child: Container(
                                            color: Colors.transparent,
                                            height: listAlerts[indexAlert]
                                                    .type
                                                    .toString()
                                                    .contains('-')
                                                ? 80
                                                : 60,
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
                                                            listAlerts[
                                                                    indexAlert]
                                                                .type),
                                                      ),
                                                      Container(
                                                        width: 220,
                                                        height: listAlerts[
                                                                    indexAlert]
                                                                .type
                                                                .toString()
                                                                .contains('-')
                                                            ? 70
                                                            : 50,
                                                        color:
                                                            Colors.transparent,
                                                        child: Stack(children: [
                                                          Text(
                                                            listAlerts[
                                                                    indexAlert]
                                                                .type
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.left,
                                                            maxLines: 2,
                                                            style:
                                                                textNormal16White(),
                                                          ),
                                                          Positioned(
                                                            bottom: 0,
                                                            child: Text(
                                                              '${listAlerts[indexAlert].time.day}-${listAlerts[indexAlert].time.month}-${listAlerts[indexAlert].time.year} | ${listAlerts[indexAlert].time.hour.toString().padLeft(2, '0')}:${listAlerts[indexAlert].time.minute.toString().padLeft(2, '0')}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style:
                                                                  textNormal16White(),
                                                            ),
                                                          ),
                                                        ]),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                indexAlert > 0 &&
                                                        indexAlert <
                                                            listAlerts.length
                                                    ? Positioned(
                                                        left: 25,
                                                        top: 140 /
                                                            2, // La posición horizontal de la línea
                                                        child: CustomPaint(
                                                          painter:
                                                              _LinePainter(),
                                                        ),
                                                      )
                                                    : const SizedBox(
                                                        height: 0,
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Positioned(
                                //   bottom: 0,
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(left: 0.0),
                                //     child: ElevateButtonFilling(
                                //       showIcon: false,
                                //       onChanged: (value) {
                                //         Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //             builder: (context) =>
                                //                 const DesactivePage(
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
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
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
// ListView.builder(
//                                   itemCount: listLog.length,
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     return ListTile(
//                                       title: Container(
//                                         color: Colors.transparent,
//                                         height: 130,
//                                         width: 290,
//                                         child: Stack(
//                                           children: [
//                                             Container(
//                                               width: 290,
//                                               color: Colors.transparent,
//                                               child: Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   IconButton(
//                                                     iconSize: 35,
//                                                     color:
//                                                         ColorPalette.principal,
//                                                     onPressed: () {},
//                                                     icon: searchImageForIcon(
//                                                         listLog[index].type),
//                                                   ),
//                                                   Expanded(
//                                                     flex: 1,
//                                                     child: Container(
//                                                       color: Colors.transparent,
//                                                       height: 70,
//                                                       child: Stack(children: [
//                                                         Positioned(
//                                                           top: 10,
//                                                           child: Text(
//                                                             listLog[index].type,
//                                                             textAlign:
//                                                                 TextAlign.left,
//                                                             style:
//                                                                 textNormal16White(),
//                                                           ),
//                                                         ),
//                                                         Positioned(
//                                                           top: 40,
//                                                           child: Text(
//                                                             '${listLog[index].time.day}-${listLog[index].time.month}-${listLog[index].time.year} | ${listLog[index].time.hour}:${listLog[index].time.minute}',
//                                                             textAlign:
//                                                                 TextAlign.left,
//                                                             style:
//                                                                 textNormal16White(),
//                                                           ),
//                                                         ),
//                                                       ]),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             index >= 0 &&
//                                                     index < listLog.length - 1
//                                                 ? Positioned(
//                                                     left: 25,
//                                                     top: 140 /
//                                                         2, // La posición horizontal de la línea
//                                                     child: CustomPaint(
//                                                       painter: _LinePainter(),
//                                                     ),
//                                                   )
//                                                 : const SizedBox(
//                                                     height: 0,
//                                                   ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   });
//                             }

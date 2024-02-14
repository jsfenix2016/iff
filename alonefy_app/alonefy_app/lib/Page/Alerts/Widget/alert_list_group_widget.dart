import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';

import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Services/mainService.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/line_paint.dart';
import 'package:ifeelefine/main.dart';

class AlertListWidget extends StatefulWidget {
  const AlertListWidget(
      {super.key,
      required this.groupedAlerts,
      required this.onChangedDelete,
      required this.onRefresh});
  final Map<String, Map<String, List<LogAlertsBD>>> groupedAlerts;
  final ValueChanged<List<LogAlertsBD>> onChangedDelete;
  final ValueChanged<bool> onRefresh;
  @override
  State<AlertListWidget> createState() => _AlertListWidgetState();
}

class _AlertListWidgetState extends State<AlertListWidget> {
  // late List<LogAlertsBD> listLog;
  int selectedCellIndex = -1; // -1 indica que ninguna celda está seleccionada
  bool isExpanded = false;
  String dateRow = "";
  final PreferenceUser _prefs = PreferenceUser();
  String typeNotify = "";
  String typeNotifyList = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(_prefs.getNotificationType);

    typeNotify = _prefs.getNotificationType;
    print("object");
  }

  void cancelNotify() async {
    List<String> a = _prefs.getlistTaskIdsCancel;
    var taskIdList = getTaskIdList(a.first);
    if (_prefs.getNotificationType.toString().contains('Date')) {
      var contactRisk = await const HiveDataRisk().getcontactRiskbd;
      if (taskIdList.isEmpty) {
        EditRiskController erisk = Get.put(EditRiskController());
        RiskController risk = Get.put(RiskController());
        var resp = await risk.getContactsRisk();
        ContactRiskBD tempcontact = initContactRisk();
        for (var temp in resp) {
          DateTime starTime = parseContactRiskDate(temp.timeinit);
          bool isafter = DateTime.now().isAfter(starTime);
          if (!temp.isActived &&
              temp.isprogrammed &&
              isafter &&
              temp.isFinishTime == false) {
            tempcontact = temp;
          }
        }

        var contactRiskTemp = tempcontact;

        if (contactRiskTemp.id != -1) {
          await erisk.updateContactRisk(contactRiskTemp);
        }

        return;
      }
      _prefs.saveLastScreenRoute("cancelDate");
      for (var element in contactRisk) {
        if (element.isActived || element.isFinishTime) {
          RedirectViewNotifier.onTapNotification(taskIdList, (element.id));
        }
      }
      return;
    }
    if (_prefs.getNotificationType.toString().contains('Inactividad')) {
      mainController.saveUserLog("Inactividad - Actividad detectada ",
          DateTime.now(), _prefs.getIdInactiveGroup);
    }
    if (_prefs.getNotificationType.toString().contains('Caida')) {
      mainController.saveUserLog("Caida - Actividad detectada ", DateTime.now(),
          _prefs.getIdDropGroup);
    }
    _prefs.setEnableTimer = false;
    _prefs.setEnableTimerDrop = false;
    MainService().cancelAllNotifications(taskIdList);
    _prefs.setNotificationType = "";
    typeNotify = "";
    await flutterLocalNotificationsPlugin.cancel(_prefs.getNotificationId!);
    _prefs.setNotificationId = -1;
    widget.onRefresh(true);
  }

  void expandedCell(int indexGroup, String alertType) {
    final date = widget.groupedAlerts.entries.elementAt(indexGroup);
    final alertTypes = widget.groupedAlerts[date.key]!;
    final indexTemp = alertTypes.keys.toList().indexOf(alertType);

    if (isExpanded && selectedCellIndex == indexTemp) {
      isExpanded = false;
    } else {
      isExpanded = true;
      selectedCellIndex = indexTemp;
      dateRow = date.key;
    }

    setState(() {});
  }

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
                          expandedCell(indexGroup, alertType);
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
                              : _prefs.getNotificationType != ""
                                  ? 141
                                  : 120,
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
                                  reverse: false,
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
                                    typeNotifyList =
                                        listAlerts[indexAlert].type;
                                    return GestureDetector(
                                      onTap: () {
                                        expandedCell(indexGroup, alertType);
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
                                                : _prefs.getNotificationType !=
                                                        ""
                                                    ? 100
                                                    : 60,
                                            width: 300,
                                            child: Stack(
                                              children: [
                                                Visibility(
                                                  visible: typeNotifyList ==
                                                          _prefs
                                                              .getNotificationType
                                                      ? true
                                                      : false,
                                                  child: Positioned(
                                                    bottom: 0,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0.0),
                                                      child: Container(
                                                        height: 50,
                                                        width: 300,
                                                        color:
                                                            Colors.transparent,
                                                        child:
                                                            ElevateButtonFilling(
                                                          showIcon: false,
                                                          onChanged: (value) {
                                                            cancelNotify();
                                                          },
                                                          mensaje: "Desactivar",
                                                          img: '',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                                                if (isExpanded == true &&
                                                    indexAlert >= 0 &&
                                                    alertTypes.keys
                                                            .toList()[
                                                                selectedCellIndex]
                                                            .length >
                                                        indexAlert &&
                                                    (selectedCellIndex ==
                                                        alertTypes.keys
                                                            .toList()
                                                            .indexOf(
                                                                alertType)) &&
                                                    dateRow ==
                                                        widget
                                                            .groupedAlerts.keys
                                                            .elementAt(
                                                                indexGroup)) ...[
                                                  Positioned(
                                                    left: 20,
                                                    top: 130 /
                                                        2, // La posición horizontal de la línea
                                                    child: CustomPaint(
                                                      painter: LinePainter(),
                                                    ),
                                                  )
                                                ]
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
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

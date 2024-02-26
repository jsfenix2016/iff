import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/notificationService.dart';

import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Alerts/Widget/cell_expanded.dart';
import 'package:ifeelefine/Page/Alerts/Widget/header_group.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';

import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Services/mainService.dart';

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
  int selectedCellIndex = -1;
  bool isExpanded = false;
  String dateRow = "";
  final PreferenceUser _prefs = PreferenceUser();
  String typeNotify = ""; // Se utiliza para identificar el tipo de notificación
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
    List<String> listTaskIds = _prefs.getlistTaskIdsCancel;
    print(prefs.getCancelIdDate.toString());
    if (listTaskIds.isEmpty) {
      listTaskIds = getTaskIdList(prefs.getCancelIdDate.toString());
    } else {
      listTaskIds = getTaskIdList(listTaskIds.first);
    }

    if (_prefs.getNotificationType.toString().contains('Cita')) {
      var contactRisk = await const HiveDataRisk().getcontactRiskbd;
      if (listTaskIds.isEmpty) {
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
          RedirectViewNotifier.onTapNotification(listTaskIds, (element.id));
        }
      }
      widget.onRefresh(true);
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
    MainService().cancelAllNotifications(listTaskIds);
    _prefs.setNotificationType = "";
    typeNotify = "";
    await flutterLocalNotificationsPlugin.cancel(_prefs.getNotificationId!);
    _prefs.setNotificationId = -1;
    widget.onRefresh(true);
  }

  void toggleExpansion(int indexGroup, String alertType) {
    final date = widget.groupedAlerts.entries.elementAt(indexGroup);
    final indexTemp = date.value.keys.toList().indexOf(alertType);

    setState(() {
      if (selectedCellIndex == indexTemp && isExpanded) {
        // Si la celda ya está expandida, ciérrala
        isExpanded = false;
        selectedCellIndex = -1;
        dateRow = "";
      } else {
        // Si la celda no está expandida, ábrela y cierra las demás
        isExpanded = true;
        selectedCellIndex = indexTemp;
        dateRow = date.key;
      }
    });
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
                  HeaderGroup(
                    date: date.split(" ").first,
                    onDelete: (bool) {
                      final date =
                          widget.groupedAlerts.keys.elementAt(indexGroup);
                      final alertTypes = widget.groupedAlerts[date]!;

                      widget.onChangedDelete(alertTypes.values.first);
                    },
                  ),
                  for (var alertType in alertTypes.keys.toList()) ...[
                    CellExpand(
                      listalertTypes: alertTypes[alertType]!,
                      onCancel: (bool) {
                        cancelNotify();
                      },
                      onExpand: (bool) =>
                          toggleExpansion(indexGroup, alertType),
                      isExpand: isExpanded &&
                          selectedCellIndex ==
                              alertTypes.keys.toList().indexOf(alertType) &&
                          dateRow == date,
                      showLine: isExpanded &&
                          selectedCellIndex ==
                              alertTypes.keys.toList().indexOf(alertType) &&
                          dateRow == date,
                    ),
                  ],
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

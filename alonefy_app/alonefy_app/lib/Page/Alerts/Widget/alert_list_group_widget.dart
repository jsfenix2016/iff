import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Alerts/Widget/cell_expanded.dart';
import 'package:ifeelefine/Page/Alerts/Widget/header_group.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

class AlertListWidget extends StatefulWidget {
  const AlertListWidget(
      {super.key,
      required this.groupedAlerts,
      required this.onChangedDelete,
      required this.onCancelNotification});
  final Map<String, Map<String, List<LogAlertsBD>>> groupedAlerts;
  final ValueChanged<List<LogAlertsBD>> onChangedDelete;
  final ValueChanged<bool> onCancelNotification;
  @override
  State<AlertListWidget> createState() => _AlertListWidgetState();
}

class _AlertListWidgetState extends State<AlertListWidget> {
  // late List<LogAlertsBD> listLog;
  Map<String, List<int>> expandedCellIndicesMap = {};

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
    if (listTaskIds.isEmpty) {
      listTaskIds = getTaskIdList(prefs.getCancelIdDate.toString());
    } else {
      listTaskIds = getTaskIdList(listTaskIds.first);
    }

    if (_prefs.getNotificationType.toString().contains('Cita')) {
      if (listTaskIds.isEmpty) {
        return;
      }
      return;
    }
    typeNotify = "";
    widget.onCancelNotification(true);
  }

  void toggleExpansion(int indexGroup, String alertType) {
    final dateEntry = widget.groupedAlerts.entries.elementAt(indexGroup);
    final indexTemp = dateEntry.value.keys.toList().indexOf(alertType);
    final key = dateEntry.key;

    setState(() {
      if (expandedCellIndicesMap.containsKey(key)) {
        if (expandedCellIndicesMap[key]!.contains(indexTemp)) {
          expandedCellIndicesMap[key]!.remove(indexTemp);
        } else {
          expandedCellIndicesMap[key]!.add(indexTemp);
        }
      } else {
        expandedCellIndicesMap[key] = [indexTemp];
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
                      onCancel: (bool value) {
                        cancelNotify();
                      },
                      onExpand: (bool) =>
                          toggleExpansion(indexGroup, alertType),
                      isExpand: expandedCellIndicesMap.containsKey(date) &&
                          expandedCellIndicesMap[date]!.contains(
                              alertTypes.keys.toList().indexOf(alertType)),
                      showLine: expandedCellIndicesMap.containsKey(date) &&
                          expandedCellIndicesMap[date]!.contains(
                              alertTypes.keys.toList().indexOf(alertType)),
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

import 'package:flutter/material.dart';

import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Alerts/Widget/cell_list_alerts.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

// ignore: must_be_immutable
class CellExpand extends StatelessWidget {
  CellExpand(
      {super.key,
      required this.onExpand,
      required this.listalertTypes,
      required this.onCancel,
      required this.isExpand,
      required this.showLine});
  final void Function(bool) onExpand;
  final void Function(bool) onCancel;
  bool isExpand;
  bool showLine;
  List<LogAlertsBD> listalertTypes;
  final PreferenceUser _prefs = PreferenceUser();

  String typeNotifyList = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        onTap: () {
          onExpand(isExpand);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isExpand
              ? listalertTypes.length * 121
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
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: listalertTypes.length > 1
                      ? IconButton(
                          iconSize: 35,
                          onPressed: () {
                            onExpand(isExpand);
                          },
                          icon: Icon(
                            isExpand
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: Colors.white,
                          ))
                      : const SizedBox.shrink(),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  reverse: false,
                  scrollDirection: Axis.vertical,
                  itemExtent: 120.0,
                  itemCount: listalertTypes.length,
                  itemBuilder: (BuildContext context, int indexAlert) {
                    final listAlerts = listalertTypes
                      ..sort((a, b) => b.time.compareTo(a.time));
                    final typeNotifyList = listAlerts[indexAlert].type;
                    final typeTemp = typeNotifyList.split(" - ").first;

                    return GestureDetector(
                      onTap: () => onExpand(isExpand),
                      child: CellListAlerts(
                        alert: listAlerts[indexAlert],
                        onCancel: onCancel,
                        showLine: showLine &&
                            indexAlert >= 0 &&
                            indexAlert < listAlerts.length - 1,
                        visibilyButton:
                            typeTemp == _prefs.getNotificationType &&
                                indexAlert == listAlerts.length - 1,
                        heightCell: typeNotifyList.contains('-')
                            ? 80
                            : _prefs.getNotificationType.isNotEmpty
                                ? 100
                                : 60,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:notification_center/notification_center.dart';

import '../Controller/alertsController.dart';

class ListAlert extends StatefulWidget {
  const ListAlert({super.key});

  @override
  State<ListAlert> createState() => _ListAlertState();
}

class _ListAlertState extends State<ListAlert> {
  final AlertsController alertsVC = Get.find<AlertsController>();

  Map<String, List<LogAlertsBD>> groupedProducts = {};
  late List<LogAlertsBD> listLog;
  final _group = ValueNotifier<Map<String, List<LogAlertsBD>>>({});

  Future<List<LogAlertsBD>> getLog() async {
    groupedProducts = {};

    groupedProducts = await alertsVC.getAllMov();
    _group.value = groupedProducts;
    setState(() {});
    return listLog;
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
    return FutureBuilder<List<LogAlertsBD>>(
      future: getLog(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final listContact = snapshot.data!;
          return Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemExtent: 250.0,
              padding: const EdgeInsets.only(top: 0.0, bottom: 50),
              shrinkWrap: true,
              itemCount: listContact.length,
              itemBuilder: (context, index) {
                if (index >= 0 && index < listContact.length) {
                  var temp = listContact[index];
                  return Container();
                }
                return const CircularProgressIndicator();
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

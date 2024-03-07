import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/historialbd.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Alerts/Service/alerts_service.dart';
import 'package:intl/intl.dart';
import '../../../Model/ApiRest/AlertApi.dart';

class AlertsController extends GetxController {
  RxMap<String, List<LogAlertsBD>> contactList =
      <String, List<LogAlertsBD>>{}.obs;

  Future<int> deleteAlerts(
      BuildContext context, List<LogAlertsBD> listAlerts) async {
    for (var logAlert in listAlerts) {
      AlertsService().deleteAlert(logAlert.id);
    }

    return await const HiveData().deleteListAlerts(listAlerts);
  }

  Future<RxMap<String, Map<String, List<LogAlertsBD>>>> getAllMov2() async {
    Map<String, Map<String, List<LogAlertsBD>>> groupedProducts = {};

    RxMap<String, Map<String, List<LogAlertsBD>>> groupedAlerts =
        RxMap<String, Map<String, List<LogAlertsBD>>>();

    List<LogAlertsBD> temp = [];
    List<LogAlertsBD> box = await const HiveData().getAlerts();

    box.sort((a, b) {
      //sorting in descending order
      return b.time.compareTo(a.time);
    });
    temp = removeDuplicates(box);

    // Inicializa la estructura del mapa anidado
    for (var alert in temp) {
      var inputFormat = DateFormat('yyyy-MM-dd');
      var inputDate = inputFormat.parse(alert.time.toString());
      var outputFormat = DateFormat('dd-MM-yyyy');
      var ar = outputFormat.format(inputDate);
      var dateTime1 = DateFormat('dd-MM-yyyy').parse(ar);

      final dateKey = dateTime1.toString();
      final typeKey = alert.groupBy;

      if (alert.type.contains("Movimiento rudo") ||
          alert.type.contains("Caida")) {
        groupedProducts.putIfAbsent(dateKey, () => {});
        groupedProducts[dateKey]!.putIfAbsent(typeKey, () => []);
        groupedProducts[dateKey]![typeKey]!.add(alert);
      } else {
        groupedProducts.putIfAbsent(dateKey, () => {});
        groupedProducts[dateKey]!.putIfAbsent(typeKey, () => []);
        groupedProducts[dateKey]![typeKey]!.add(alert);
      }
    }
    groupedAlerts.value = groupedProducts;

    return groupedAlerts;
  }

  List<LogAlertsBD> removeDuplicates(List<LogAlertsBD> originalList) {
    Set<String> auxList = {};
    originalList.removeWhere((element) {
      final key = '${element.id}_${element.time}';
      return !auxList.add(key);
    });
    return originalList;
  }

  Future<void> saveFromApi(List<AlertApi> alerts) async {
    if (alerts != null && alerts.isNotEmpty) {
      for (var alert in alerts) {
        var alertBD = LogAlertsBD(
            id: alert.id,
            type: alert.typeaction,
            photoDate: [],
            time: alert.startdate,
            groupBy: alert.groupBy);

        await const HiveData().saveUserPositionBD(alertBD);
        HistorialBD hist = HistorialBD(
            id: alertBD.id,
            type: alertBD.type,
            time: alertBD.time,
            photoDate: [],
            groupBy: alertBD.groupBy);

        const HiveData().saveLogsHistorialBD(hist);
      }
    }
  }
}

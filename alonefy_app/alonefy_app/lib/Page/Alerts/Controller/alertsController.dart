import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Alerts/Service/alerts_service.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

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

  Future<Map<String, List<LogAlertsBD>>> getAllMov() async {
    Map<String, List<LogAlertsBD>> groupedProducts = {};
    late final List<LogAlertsBD> allMovTime = [];
    late final List<LogAlertsBD> allMov = [];
    List<LogAlertsBD> temp = [];
    List<LogAlertsBD> box = await const HiveData().getAlerts();
    for (var element in box) {
      if (!element.type.contains("Cita")) {
        allMovTime.add(element);
      }
    }

    allMovTime.sort((a, b) {
      //sorting in descending order
      return b.time.compareTo(a.time);
    });

    for (var element in allMovTime) {
      allMov.add(element);
    }

    temp = removeDuplicates(allMov);
    var format = DateFormat('dd-MM-yyyy');
    temp.sort((a, b) {
      //sorting in descending order
      return a.time.compareTo(b.time);
    });
    groupedProducts = groupBy(
        temp, (product) => format.parse(product.time.toString()).toString());
    contactList.value = groupedProducts;

    return groupedProducts;
  }

  Future<RxMap<String, Map<String, List<LogAlertsBD>>>> getAllMov2() async {
    Map<String, Map<String, List<LogAlertsBD>>> groupedProducts = {};

    RxMap<String, Map<String, List<LogAlertsBD>>> groupedAlerts =
        RxMap<String, Map<String, List<LogAlertsBD>>>();
    late final List<LogAlertsBD> allMovTime = [];
    late final List<LogAlertsBD> allMov = [];
    List<LogAlertsBD> temp = [];
    List<LogAlertsBD> box = await const HiveData().getAlerts();

    for (var element in box) {
      // if (element.type.contains("Inactividad")) {
      allMovTime.add(element);
      // }
    }

    allMovTime.sort((a, b) {
      //sorting in descending order
      return b.time.compareTo(a.time);
    });

    for (var element in allMovTime) {
      allMov.add(element);
    }

    temp = removeDuplicates(allMov);
    // var format = DateFormat('dd-MM-yyyy');

    // Inicializa la estructura del mapa anidado
    for (var alert in temp) {
      var inputFormat = DateFormat('yyyy-MM-dd');
      var inputDate = inputFormat.parse(alert.time.toString());
      var outputFormat = DateFormat('dd-MM-yyyy');
      var ar = outputFormat.format(inputDate);
      var dateTime1 = DateFormat('dd-MM-yyyy').parse(ar);

      final dateKey = dateTime1.toString();
      final typeKey = alert.groupBy;
      print(typeKey);
      print('idGroup: ${alert.id}');
      print('type: ${alert.type}');

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
    // contactList.value = groupedProducts;
    return groupedAlerts;
  }

  List<LogAlertsBD> removeDuplicates(List<LogAlertsBD> originalList) {
    return originalList.toSet().toList();
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
      }
    }
  }
}

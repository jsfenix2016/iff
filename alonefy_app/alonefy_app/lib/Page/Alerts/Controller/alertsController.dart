import 'dart:convert';

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

      groupedProducts.putIfAbsent(dateKey, () => {});
      groupedProducts[dateKey]!.putIfAbsent(typeKey, () => []);
      groupedProducts[dateKey]![typeKey]!.add(alert);
    }

    // Crear un nuevo mapa ordenado
    RxMap<String, Map<String, List<LogAlertsBD>>> sortedGroupedAlerts =
        RxMap<String, Map<String, List<LogAlertsBD>>>();

// Iterar sobre cada grupo
    groupedProducts.forEach((dateKey, value) {
      // Crear un nuevo mapa para este grupo
      Map<String, List<LogAlertsBD>> sortedGroup = {};

      // Iterar sobre cada identificador en el grupo
      value.forEach((key, alerts) {
        // Ordenar las alertas en orden descendente por fecha y hora
        // alerts.sort((a, b) => b.time.compareTo(a.time));
        alerts.sort((a, b) {
          if (a.time.hour != b.time.hour) {
            return b.time.hour.compareTo(a.time.hour);
          } else {
            return b.time.minute.compareTo(a.time.minute);
          }
        });
        // Agregar el identificador con las alertas ordenadas al nuevo mapa
        sortedGroup[key] = alerts;
      });

      // Ordenar los identificadores en el grupo según la alerta más reciente
      var sortedKeys = sortedGroup.keys.toList()
        ..sort((a, b) {
          var latestTimeA = sortedGroup[a]!.isEmpty
              ? DateTime(1900)
              : sortedGroup[a]!.first.time;
          var latestTimeB = sortedGroup[b]!.isEmpty
              ? DateTime(1900)
              : sortedGroup[b]!.first.time;

          if (latestTimeA.hour != latestTimeB.hour) {
            return latestTimeB.hour.compareTo(latestTimeA.hour);
          } else {
            return latestTimeB.minute.compareTo(latestTimeA.minute);
          } // Orden descendente
        });

      // Crear un nuevo mapa ordenado para este grupo
      Map<String, List<LogAlertsBD>> sortedGroupOrdered = {};

      // Iterar sobre los identificadores ordenados y agregarlos al nuevo mapa ordenado
      for (var key in sortedKeys) {
        sortedGroupOrdered[key] = sortedGroup[key]!;
      }

      // Agregar el grupo ordenado al nuevo mapa principal ordenado
      sortedGroupedAlerts[dateKey] = sortedGroupOrdered;
    });

    return sortedGroupedAlerts;
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

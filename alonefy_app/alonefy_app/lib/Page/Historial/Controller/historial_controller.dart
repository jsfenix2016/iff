import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/logActivity.dart';
import 'package:ifeelefine/Model/logActivityBd.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:jiffy/jiffy.dart';

class HistorialController extends GetxController {
  List<LogActivity> _activities = [];
  List<String> datetimes = [];

  Future<int> deleteAlerts(BuildContext context, List<LogAlertsBD> time) async {
    return await const HiveData().deleteListLogHistorial(time);
  }

  Future<Map<String, List<LogAlertsBD>>> getAllMov() async {
    Map<String, List<LogAlertsBD>> groupedProducts = {};

    late final List<LogAlertsBD> allMovTime = [];
    late final List<LogAlertsBD> allMov = [];
    List<LogAlertsBD> temp = [];
    List<dynamic> tempDynamic = [];
    List<LogAlertsBD> box = await const HiveData().getAlerts();

    var activities = await const HiveData().listLogActivitybd;

    for (var _activity in activities) {
      convertDateTimeToString(_activity.time);
    }
    for (var element in box) {
      allMovTime.add(element);
    }

    allMovTime.sort((a, b) {
      //sorting in descending order
      return b.time.compareTo(a.time);
    });

    for (var element in allMovTime) {
      allMov.add(element);
      tempDynamic.add(element);
    }

    temp = removeDuplicates(allMov);
    temp.forEach((element) {
      tempDynamic.add(element);
    });
    print(tempDynamic);
    var format = DateFormat('dd-MM-yyyy');

    groupedProducts = groupBy(
        temp, (product) => format.parse(product.time.toString()).toString());

    return groupedProducts;
  }

  getFormatedDate(DateTime date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(date.toString());
    var outputFormat = DateFormat('dd-MM-yyyy');
    var a = outputFormat.format(inputDate);
    return a;
  }

  Future<Map<String, List<dynamic>>> getAllAlerts() async {
    Map<String, List<dynamic>> groupedAlerts = {};
    late final List<LogAlertsBD> allMovTime = [];
    late final List<LogAlertsBD> allMov = [];
    List<LogAlertsBD> temp = [];
    List<dynamic> tempDynamic = [];
    List<LogAlertsBD> box = await const HiveData().getAlerts();

    var activities = await const HiveData().listLogActivitybd;

    var dateRisk = await const HiveDataRisk().getcontactRiskbd;
    var zoneRisk = await const HiveDataRisk().getcontactZoneRiskbd;

    var format = DateFormat('dd-MM-yyyy');
    if (dateRisk.isNotEmpty) {
      for (var dateTem in dateRisk) {
        var ar = getFormatedDate(dateTem.createDate);
        var dateTime1 = DateFormat('dd-MM-yyyy').parse(ar);

        var tempAct = LogAlertsBD(
            id: 0, time: dateTime1, type: "Cita", photoDate: dateTem.photoDate);
        tempDynamic.add(tempAct);
      }
    }
    if (zoneRisk.isNotEmpty) {
      for (var date in zoneRisk) {
        convertDateTimeToString(date.createDate);
        var ar = getFormatedDate(date.createDate);
        var dateTime1 = DateFormat('dd-MM-yyyy').parse(ar);
        // var datenew = DateFormat('dd-MM-yyyy HH:mm:ss').format(date.createDate);
        var tempAct = LogAlertsBD(
            id: 0, time: (dateTime1), type: "Zona", video: date.video);
        tempDynamic.add(tempAct);
      }
    }
    if (activities.isNotEmpty) {
      for (var activityItem in activities) {
        convertDateTimeToString(activityItem.time);

        var tempAct = LogAlertsBD(
            id: 0, time: activityItem.time, type: activityItem.movementType);
        tempDynamic.add(tempAct);
      }
    }
    if (activities.isNotEmpty) {
      for (var element in box) {
        allMovTime.add(element);
      }

      allMovTime.sort((a, b) {
        return b.time.compareTo(a.time);
      });

      for (var element in allMovTime) {
        allMov.add(element);
        // tempDynamic.add(element);
      }

      temp = removeDuplicates(allMov);
      temp.forEach((element) {
        tempDynamic.add(element);
      });
      print(tempDynamic);
    }

// Formatea las fechas para que coincidan con el formato de agrupación
    groupedAlerts = groupBy(
      tempDynamic,
      (product) => DateFormat('dd-MM-yyyy').format(product.time),
    );

    groupedAlerts.forEach((key, group) {
      group.sort((a, b) {
        return b.time.compareTo(a.time);
      });
    });

    // Ordena los grupos por fecha en orden descendente
    final sortedKeys = groupedAlerts.keys.toList()
      ..sort((a, b) {
        final dateTimeA = DateFormat('dd-MM-yyyy').parse(a);
        final dateTimeB = DateFormat('dd-MM-yyyy').parse(b);
        return dateTimeB.compareTo(dateTimeA);
      });

    final sortedGroupedAlerts = Map<String, List<dynamic>>.fromEntries(
      sortedKeys.map((key) => MapEntry(key, groupedAlerts[key]!)),
    );

    return sortedGroupedAlerts;
  }

  Future<void> convertDateTimeToString(DateTime time) async {
    var datetime = await dateTimeToString(time);
    datetimes.add(datetime);
  }

  List<LogAlertsBD> removeDuplicates(List<LogAlertsBD> originalList) {
    return originalList.toSet().toList();
  }
}

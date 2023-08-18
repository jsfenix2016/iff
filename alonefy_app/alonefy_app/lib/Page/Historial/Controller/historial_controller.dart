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

class HistorialController extends GetxController {
  List<LogActivity> _activities = [];
  List<String> datetimes = [];

  Future<int> deleteAlerts(BuildContext context, List<LogAlertsBD> time) async {
    return await const HiveData().deleteListLogHistorial(time);
  }

  Future<Map<String, List<LogAlertsBD>>> getAllMov() async {
    Map<String, List<LogAlertsBD>> groupedProducts = {};
    Map<String, List<dynamic>> groupedAlerts = {};
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

    groupedAlerts = groupBy(tempDynamic,
        (product) => format.parse(product.time.toString()).toString());

    return groupedProducts;
  }

  Future<Map<String, List<dynamic>>> getAllAlerts() async {
    Map<String, List<LogAlertsBD>> groupedProducts = {};
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
        var formatter = DateFormat('yMd');

        // var datetime = formatter.parse(date.createDate.toIso8601String());

        // var dateNew = DateTime(datetime.year, datetime.month,
        //     datetime.day); // Reordenar año, mes y día

        DateTime originalDateTime = DateTime(dateTem.createDate.year,
            dateTem.createDate.month, dateTem.createDate.day);
        // CustomDateTime customDateTime = CustomDateTime(originalDateTime);

        // print(originalDateTime); // Imprime: 2023-08-10 00:00:00.000
        // print(customDateTime); // Imprime: 10-08-2023

        var formattedDate = DateFormat('yMd').format(dateTem.createDate);
        print(formattedDate); // Imprimirá: 10-08-2023

        DateTime fss = DateFormat('yMd').parse(formattedDate);
        var tempAct = LogAlertsBD(
            id: 0, time: fss, type: "Cita", photoDate: dateTem.photoDate);
        tempDynamic.add(tempAct);
      }
    }
    if (zoneRisk.isNotEmpty) {
      for (var date in zoneRisk) {
        convertDateTimeToString(date.createDate);

        var tempAct = LogAlertsBD(
            id: 0,
            time: format.parse(date.createDate.toString()),
            type: "Zona",
            video: date.video);
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
        //sorting in descending order
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

    groupedAlerts = groupBy(tempDynamic,
        (product) => format.parse(product.time.toString()).toString());

    return groupedAlerts;
  }

  Future<void> convertDateTimeToString(DateTime time) async {
    var datetime = await dateTimeToString(time);
    datetimes.add(datetime);
  }

  List<LogAlertsBD> removeDuplicates(List<LogAlertsBD> originalList) {
    return originalList.toSet().toList();
  }
}

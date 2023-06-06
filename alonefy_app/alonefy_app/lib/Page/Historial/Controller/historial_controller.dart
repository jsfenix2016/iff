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

final _prefs = PreferenceUser();

class HistorialController extends GetxController {
  List<LogActivity> _activities = [];
  List<String> datetimes = [];

  Future<int> deleteAlerts(
      BuildContext context, List<LogAlertsBD> listAlerts) async {
    return await const HiveData().deleteListAlerts(listAlerts);
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
    if (dateRisk.isNotEmpty) {
      for (var date in dateRisk) {
        convertDateTimeToString(date.createDate);
        // tempDynamic.add(_activity);
        var tempAct = LogAlertsBD(
            time: date.createDate, type: "Cita", photoDate: date.photoDate);
        tempDynamic.add(tempAct);
      }
    }
    if (zoneRisk.isNotEmpty) {
      for (var date in zoneRisk) {
        convertDateTimeToString(date.createDate);

        var tempAct =
            LogAlertsBD(time: date.createDate, type: "Zona", video: date.video);
        tempDynamic.add(tempAct);
      }
    }
    if (activities.isNotEmpty) {
      for (var activityItem in activities) {
        convertDateTimeToString(activityItem.time);

        var tempAct = LogAlertsBD(
            time: activityItem.time, type: activityItem.movementType);
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

    var format = DateFormat('dd-MM-yyyy');

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

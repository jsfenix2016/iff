import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Model/logActivity.dart';

import 'package:ifeelefine/Model/logAlertsBD.dart';

import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class HistorialController extends GetxController {
  List<LogActivity> activities = [];
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
    final Map<String, List<dynamic>> groupedAlerts = {};

    final List<dynamic> tempDynamic = [];
    final List<LogAlertsBD> box = await const HiveData().getAlerts();

    List<ContactRiskBD> dateRisk = await const HiveDataRisk().getcontactRiskbd;
    List<ContactZoneRiskBD> zoneRisk =
        await const HiveDataRisk().getcontactZoneRiskbd;

    void addTempDynamic(LogAlertsBD alert) {
      tempDynamic.add(alert);
    }

    void addDateRisk(DateTime dateTime, int id, String type) {
      final tempAct =
          LogAlertsBD(id: id, time: dateTime, type: type, groupBy: '2');
      addTempDynamic(tempAct);
    }

    void addZoneRisk(DateTime dateTime, ContactZoneRiskBD contact) {
      final tempAct = LogAlertsBD(
          id: (contact.id),
          time: dateTime,
          type: "Zona",
          video: null,
          groupBy: "3",
          listVideosPresigned: contact.listVideosPresigned);
      addTempDynamic(tempAct);
    }

    void convertAndAddZoneRisk(ContactZoneRiskBD contact) {
      final inputFormat = DateFormat('yyyy-MM-dd HH:mm');
      final inputDate = inputFormat.parse(contact.createDate.toString());
      final outputFormat = DateFormat('dd-MM-yyyy HH:mm');
      final ar = outputFormat.format(inputDate);
      final dateTime1 = DateFormat('dd-MM-yyyy HH:mm').parse(ar);
      addZoneRisk(dateTime1, contact);
    }

    void convertAndAddDateRisk(String createDate, int id) {
      final inputFormat = DateFormat('yyyy-MM-dd HH:mm');
      final inputDate = inputFormat.parse(createDate);
      final outputFormat = DateFormat('dd-MM-yyyy HH:mm');
      final ar = outputFormat.format(inputDate);
      final dateTime1 = DateFormat('dd-MM-yyyy HH:mm').parse(ar);
      addDateRisk(dateTime1, id, "Cita");
    }

    if (dateRisk.isNotEmpty) {
      dateRisk.forEach((dateTem) {
        convertAndAddDateRisk(dateTem.createDate.toString(), dateTem.id);
      });
    }

    if (zoneRisk.isNotEmpty) {
      print("elementos en zoneRisk -> ${zoneRisk.length}");
      zoneRisk.forEach((date) {
        convertAndAddZoneRisk(date);
      });
    }

    final activities = await const HiveData().listLogActivitybd;

    if (activities.isNotEmpty) {
      for (var activityItem in activities) {
        final tempAct = LogAlertsBD(
          id: activityItem.key,
          time: activityItem.time,
          type: activityItem.movementType,
          groupBy: activityItem.groupBy,
        );

        if (activityItem.movementType != "Cita") {
          // No hacemos nada
        } else {
          addTempDynamic(tempAct);
        }
      }
    }

    if (box.isNotEmpty) {
      final List<LogAlertsBD> allMovTime = [];
      final List<LogAlertsBD> allMov = [];

      for (var element in box) {
        allMovTime.add(element);
      }

      allMovTime.sort((a, b) {
        return b.time.compareTo(a.time);
      });

      for (var element in allMovTime) {
        allMov.add(element);
      }

      final temp = removeDuplicates(allMov);
      temp.forEach((element) {
        addTempDynamic(element);
      });
    }

    // Formatea las fechas para que coincidan con el formato de agrupación
    groupedAlerts.addAll(groupBy(
      tempDynamic,
      (product) => DateFormat('dd-MM-yyyy').format(product.time),
    ));

    // Ordena los grupos por fecha en orden descendente
    groupedAlerts.forEach((key, group) {
      group.sort((a, b) => b.time.compareTo(a.time));
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

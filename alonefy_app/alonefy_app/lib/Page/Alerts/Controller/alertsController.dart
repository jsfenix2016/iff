import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Page/Alerts/Service/alerts_service.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

final _prefs = PreferenceUser();

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
      allMovTime.add(element);
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

    groupedProducts = groupBy(
        temp, (product) => format.parse(product.time.toString()).toString());
    contactList.value = groupedProducts;
    return groupedProducts;
  }

  List<LogAlertsBD> removeDuplicates(List<LogAlertsBD> originalList) {
    return originalList.toSet().toList();
  }
}

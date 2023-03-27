import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/userpositionbd.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

final _prefs = PreferenceUser();

class AlertsController extends GetxController {
  Future<int> deleteAlerts(
      BuildContext context, List<UserPositionBD> listAlerts) async {
    return await const HiveData().deleteListAlerts(listAlerts);
  }

  Future<Map<String, List<UserPositionBD>>> getAllMov() async {
    Map<String, List<UserPositionBD>> groupedProducts = {};
    late final List<UserPositionBD> allMovTime = [];
    late final List<UserPositionBD> allMov = [];
    List<UserPositionBD> temp = [];
    List<UserPositionBD> box = await const HiveData().getAlerts();
    for (var element in box) {
      allMovTime.add(element);
    }

    allMovTime.sort((a, b) {
      //sorting in descending order
      return b.movRureUser.compareTo(a.movRureUser);
    });

    for (var element in allMovTime) {
      allMov.add(element);
    }

    temp = removeDuplicates(allMov);
    var format = DateFormat('dd-MM-yyyy');

    groupedProducts = groupBy(
        temp, (product) => format.parse(product.time.toString()).toString());

    return groupedProducts;
  }

  List<UserPositionBD> removeDuplicates(List<UserPositionBD> originalList) {
    return originalList.toSet().toList();
  }
}

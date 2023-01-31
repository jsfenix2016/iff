import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/activityDay.dart';
import 'package:ifeelefine/Model/activitydaybd.dart';

class InactivityViewController extends GetxController {
  Future<int> saveInactivity(
      BuildContext context, List<ActivityDay> listActivity) async {
    List<ActivityDayBD> listActivitybd =
        await convertActivityDayToBD(listActivity);

    return await const HiveData().saveActivities(listActivitybd);
  }

  List<ActivityDayBD> removeDuplicates(List<ActivityDayBD> originalList) {
    return originalList.toSet().toList();
  }

  Future<List<ActivityDayBD>> convertActivityDayToBD(
      List<ActivityDay> listActivity) async {
    List<ActivityDayBD> listActivitybd = [];

    for (var element in listActivity) {
      ActivityDayBD temp = ActivityDayBD(
          day: element.day,
          activity: element.activity,
          timeSleep: element.timeSleep,
          timeWakeup: element.timeWakeup,
          id: element.id);
      listActivitybd.add(temp);
    }
    return listActivitybd;
  }

  Future<int> updateInactivity(
      BuildContext context, List<ActivityDay> listActivity) async {
    List<ActivityDayBD> listActivitybd =
        await convertActivityDayToBD(listActivity);

    return await const HiveData().updateActivities(listActivitybd);
  }

  Future<int> deleteInactivity(
      BuildContext context, ActivityDay activity) async {
    ActivityDayBD temp = ActivityDayBD(
        day: activity.day,
        activity: activity.activity,
        timeSleep: activity.timeSleep,
        timeWakeup: activity.timeWakeup,
        id: activity.id);
    await const HiveData().deleteActivities(temp);
    return 0;
  }

  Future<List<ActivityDayBD>> getInactivity() async {
    try {
      return await const HiveData().listUserActivitiesbd;
    } catch (error) {
      return [];
    }
  }
}

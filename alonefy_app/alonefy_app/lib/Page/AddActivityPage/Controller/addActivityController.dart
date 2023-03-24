import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../Data/hive_data.dart';
import '../../../Model/activityDay.dart';
import '../../../Model/activitydaybd.dart';

class AddActivityController extends GetxController {

  Future<List<ActivityDay>> getActivities() async {
    try {
      var activitiesBD = await const HiveData().listUserActivitiesbd;

      List<ActivityDay> activities = [];
      for (var activityBD in activitiesBD) {
        var activity = await convertActivityDayBDToActivityDat(activityBD);
        activities.add(activity);
      }

      return activities;
    } catch (error) {
      return [];
    }
  }

  Future<int> saveActivity(BuildContext context, ActivityDay activity) async {
    var activitiesDB = await getActivities();
    activity.id = activitiesDB.length;
    ActivityDayBD activitybd = await convertActivityDayToBD(activity);

    return await const HiveData().saveActivity(activitybd);
  }

  Future<ActivityDayBD> convertActivityDayToBD(ActivityDay activity) async {

    ActivityDayBD activitybd = ActivityDayBD(
      id: activity.id,
      activity: activity.activity,
      allDay: activity.allDay,
      day: activity.day,
      dayFinish: activity.dayFinish,
      timeStart: activity.timeStart,
      timeFinish: activity.timeFinish,
      days: activity.days ?? "",
      repeatType: activity.repeatType,
      isDeactivate: activity.isDeactivate,
      specificDaysDeactivated: activity.specificDaysDeactivated ?? "",
      specificDaysRemoved: activity.specificDaysRemoved ?? ""
    );

    return activitybd;
  }

  Future<ActivityDay> convertActivityDayBDToActivityDat(ActivityDayBD activityBD) async {

    ActivityDay activity = ActivityDay();

    activity.id = activityBD.id;
    activity.activity= activityBD.activity;
    activity.allDay= activityBD.allDay;
    activity.day= activityBD.day;
    activity.dayFinish= activityBD.dayFinish;
    activity.timeStart = activityBD.timeStart;
    activity.timeFinish = activityBD.timeFinish;
    activity.days = activityBD.days;
    activity.repeatType= activityBD.repeatType;
    activity.isDeactivate= activityBD.isDeactivate;
    activity.specificDaysDeactivated= activityBD.specificDaysDeactivated;
    activity.specificDaysRemoved= activityBD.specificDaysRemoved;

    return activity;
  }

  void updateActivity(ActivityDay activityDay) async {
    var activitybd = await convertActivityDayToBD(activityDay);

    await HiveData().updateActivity(activitybd);
  }

  ActivityDay clone(ActivityDay activityDay) {
    ActivityDay activity = ActivityDay();

    activity.id = activityDay.id;
    activity.activity= activityDay.activity;
    activity.allDay= activityDay.allDay;
    activity.day= activityDay.day;
    activity.dayFinish= activityDay.dayFinish;
    activity.timeStart = activityDay.timeStart;
    activity.timeFinish = activityDay.timeFinish;
    activity.days = activityDay.days;
    activity.repeatType= activityDay.repeatType;
    activity.isDeactivate= activityDay.isDeactivate;
    activity.specificDaysDeactivated= activityDay.specificDaysDeactivated;
    activity.specificDaysRemoved= activityDay.specificDaysRemoved;

    return activity;
  }
}
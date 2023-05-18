import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ifeelefine/Model/ApiRest/activityDayApi.dart';
import 'package:ifeelefine/Page/AddActivityPage/Service/activityService.dart';
import 'package:jiffy/jiffy.dart';
import '../../../Common/utils.dart';
import '../../../Controllers/mainController.dart';
import '../../../Data/hive_data.dart';
import '../../../Model/ApiRest/activityDayApiResponse.dart';
import '../../../Model/activityDay.dart';
import '../../../Model/activitydaybd.dart';

class AddActivityController extends GetxController {
  Future<List<ActivityDay>> getActivities() async {
    try {
      var activitiesBD = await const HiveData().listUserActivitiesbd;

      List<ActivityDay> activities = [];
      for (var activityBD in activitiesBD) {
        var activity = await convertActivityDayBDToActivityDay(activityBD);
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
        specificDaysRemoved: activity.specificDaysRemoved ?? "");

    return activitybd;
  }

  Future<ActivityDay> convertActivityDayBDToActivityDay(
      ActivityDayBD activityBD) async {
    ActivityDay activity = ActivityDay();

    activity.id = activityBD.id;
    activity.activity = activityBD.activity;
    activity.allDay = activityBD.allDay;
    activity.day = activityBD.day;
    activity.dayFinish = activityBD.dayFinish;
    activity.timeStart = activityBD.timeStart;
    activity.timeFinish = activityBD.timeFinish;
    activity.days = activityBD.days;
    activity.repeatType = activityBD.repeatType;
    activity.isDeactivate = activityBD.isDeactivate;
    activity.specificDaysDeactivated = activityBD.specificDaysDeactivated;
    activity.specificDaysRemoved = activityBD.specificDaysRemoved;

    return activity;
  }

  void updateActivity(ActivityDay activityDay) async {
    var activitybd = await convertActivityDayToBD(activityDay);

    await const HiveData().updateActivity(activitybd);
  }

  Future<ActivityDayApiResponse?> saveActivityApi(ActivityDay activity) async {
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();
    var activityApi = await _convertToApi(activity, user.telephone);
    return ActivityService().saveData(activityApi);
  }

  Future<void> updateActivityApi(ActivityDay activity) async {
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();
    var activityApi = await _convertToApi(activity, user.telephone);
    ActivityService().updateData(activityApi);
  }

  Future<ActivityDayApi> _convertToApi(ActivityDay activity, String phoneNumber) async {

    var startDate = await _convertDayToApi(activity.day);
    var startTime = await _convertTimeToApi(activity.timeStart);
    var endTime = await _convertTimeToApi(activity.timeFinish);
    var endDate = await _convertDayToApi(activity.dayFinish);
    var disabledDates = await _convertSpecificDaysToList(activity.specificDaysDeactivated);
    var removedDates = await _convertSpecificDaysToList(activity.specificDaysRemoved);

    ActivityDayApi activityDayApi = ActivityDayApi(
      phoneNumber,
      startDate,
      endDate,
      startTime,
      activity.activity,
      activity.allDay,
      endTime,
      _convertDaysToList(activity.days!),
      activity.repeatType,
      activity.isDeactivate,
      disabledDates,
      removedDates
    );

    return activityDayApi;
  }

  Future<DateTime> _convertDayToApi(String day) async {
    await Jiffy.locale('es');

    var dateTime = Jiffy(day.toLowerCase(), getDefaultPattern()).dateTime;
    return dateTime;
  }

  Future<DateTime> _convertTimeToApi(String time) async {
    await Jiffy.locale('es');

    var dateTime = Jiffy(time.toLowerCase(), getTimePattern()).dateTime;
    return dateTime;
  }

  List<String> _convertDaysToList(String? days) {
    if (days != null && days.isNotEmpty) {
      var daysArray = days.split(';');
      return daysArray;
    } else {
      return [];
    }
  }

  Future<List<DateTime>> _convertSpecificDaysToList(
      String? specificDays) async {
    await Jiffy.locale('es');

    if (specificDays != null && specificDays.isNotEmpty) {
      List<DateTime> specificDaysDateTime = [];
      var specifyDays = specificDays.split(';');

      for (var specificDay in specifyDays) {
        var specificDateTime =
            Jiffy(specificDay.toLowerCase(), getDefaultPattern()).dateTime;

        specificDaysDateTime.add(specificDateTime);
      }

      return specificDaysDateTime;
    } else {
      return [];
    }
  }

  Future<List<ActivityDay>> convertToApk(
      List<ActivityDayApiResponse> activitiesApi) async {
    await Jiffy.locale("es");
    List<ActivityDay> activities = [];

    for (var activityApi in activitiesApi) {
      ActivityDay activityDay = ActivityDay();

      activityDay.id = activityApi.id;
      activityDay.day = await _convertDayToApk(activityApi.startDate);
      activityDay.timeStart = await _convertTimeToApk(activityApi.startTime);
      activityDay.timeFinish = await _convertTimeToApk(activityApi.endTime);
      activityDay.activity = activityApi.name;
      activityDay.allDay = activityApi.allDay;
      activityDay.dayFinish = await _convertDayToApk(activityApi.endDate);
      activityDay.days = _convertListToDays(activityApi.days);
      activityDay.repeatType = activityApi.repeatType;
      activityDay.isDeactivate = activityApi.enabled;
      activityDay.specificDaysDeactivated =
          await _convertListToSpecificDays(activityApi.disabledDates);
      activityDay.specificDaysRemoved =
          await _convertListToSpecificDays(activityApi.removedDates);

      activities.add(activityDay);
    }

    return activities;
  }

  Future<String> _convertDayToApk(DateTime day) async {
    await Jiffy.locale('es');

    var dateTime = Jiffy(day).format(getDefaultPattern());
    return dateTime;
  }

  Future<String> _convertTimeToApk(DateTime time) async {
    await Jiffy.locale('es');

    var hour = time.hour;
    var minutes = time.minute;

    var strHour = '$hour';
    var strMinutes = '$minutes';

    if (hour < 10) strHour = '0$hour';
    if (minutes < 10) strMinutes = '0$minutes';

    //var dateTime = Jiffy(time).format(getTimePattern());
    return '$strHour:$strMinutes';
  }

  String? _convertListToDays(List<String>? days) {
    if (days != null && days.isNotEmpty) {
      String strDays = "";
      for (var day in days) {
        strDays += '${day};';
      }

      if (strDays.isNotEmpty)
        strDays = strDays.substring(0, strDays.length - 1);

      return strDays;
    } else {
      return null;
    }
  }

  Future<String?> _convertListToSpecificDays(
      List<DateTime>? specificDays) async {
    await Jiffy.locale('es');

    if (specificDays != null && specificDays.isNotEmpty) {
      String strSpecificDays = "";

      for (var specificDay in specificDays) {
        var day = Jiffy(specificDay).format(getDefaultPattern());

        strSpecificDays = '$day;';
      }

      if (strSpecificDays.isNotEmpty)
        strSpecificDays =
            strSpecificDays.substring(0, strSpecificDays.length - 1);

      return strSpecificDays;
    } else {
      return null;
    }
  }

  ActivityDay clone(ActivityDay activityDay) {
    ActivityDay activity = ActivityDay();

    activity.id = activityDay.id;
    activity.activity = activityDay.activity;
    activity.allDay = activityDay.allDay;
    activity.day = activityDay.day;
    activity.dayFinish = activityDay.dayFinish;
    activity.timeStart = activityDay.timeStart;
    activity.timeFinish = activityDay.timeFinish;
    activity.days = activityDay.days;
    activity.repeatType = activityDay.repeatType;
    activity.isDeactivate = activityDay.isDeactivate;
    activity.specificDaysDeactivated = activityDay.specificDaysDeactivated;
    activity.specificDaysRemoved = activityDay.specificDaysRemoved;

    return activity;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ifeelefine/Model/ApiRest/activityDayApi.dart';
import 'package:ifeelefine/Page/AddActivityPage/Service/activityService.dart';
import 'package:ifeelefine/main.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification_center/notification_center.dart';
import '../../../Common/Constant.dart';
import '../../../Common/utils.dart';
import '../../../Controllers/mainController.dart';
import '../../../Data/hive_data.dart';
import '../../../Model/ApiRest/activityDayApiResponse.dart';
import '../../../Model/activityDay.dart';
import '../../../Model/activitydaybd.dart';

class AddActivityController extends GetxController {
  ActivityService serviceActivity = Get.put(ActivityService());
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

  bool startTimeIsBeforeEndTime(
      String hour1, String hour2, String minutes1, String minutes2) {
    if (int.parse(hour1) < int.parse(hour2)) {
      return true;
    } else if (int.parse(hour1) == int.parse(hour2)) {
      return int.parse(minutes1) < int.parse(minutes2);
    } else if (int.parse(hour1) > int.parse(hour2)) {
      return false;
    }

    return false;
  }

  Future<int> saveActivity(BuildContext context, ActivityDay activity) async {
    ActivityDayBD activitybd = await convertActivityDayToBD(activity);
    int id = await const HiveData().saveActivity(activitybd);
    NotificationCenter().notify('refreshPreviewActivities');
    return id;
  }

  Future<void> saveFromApi(List<ActivityDayApiResponse> activitiesApi) async {
    var activities = await convertToApk(activitiesApi);

    for (var activity in activities) {
      var activityBD = await convertActivityDayToBD(activity);
      await const HiveData().saveActivity(activityBD);
    }
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

  void deleteActivity(ActivityDay activityDay) async {
    var activitybd = await convertActivityDayToBD(activityDay);
    bool isdelete =
        await serviceActivity.deleteActivities(activitybd.id.toString());
    if (isdelete) {
      await const HiveData().deleteActivities(activitybd);
    }
  }

  Future<ActivityDayApiResponse?> saveActivityApi(ActivityDay activity) async {
    final MainController mainController = Get.put(MainController());
    user = await mainController.getUserData();

    var activityApi = await _convertToApi(activity, user!.telephone);

    var activityApiResponse = await ActivityService().saveData(activityApi);
    if (activityApiResponse != null) {
      if (activityApiResponse.days != null &&
          activityApiResponse.days!.isNotEmpty) {
        activityApiResponse.days =
            _convertRepeatTypeDaysApi(activityApiResponse.days!);
      }
      activityApiResponse.repeatType =
          Constant.daysFromApi[activityApiResponse.repeatType]!;
    }

    return activityApiResponse;
  }

  Future<void> updateActivityApi(ActivityDay activity) async {
    final MainController mainController = Get.put(MainController());
    user = await mainController.getUserData();

    var activityApi = await _convertToApi(activity, user!.telephone);
    ActivityService().updateData(
        ActivityDayApiResponse.fromActivityDayApi(activityApi, activity.id));
  }

  Future<ActivityDayApi> _convertToApi(
      ActivityDay activity, String phoneNumber) async {
    var startDate = await _convertDayToApi(activity.day);
    // var startTime = await _convertTimeToApi(activity.timeStart);
    // var endTime = await _convertTimeToApi(activity.timeFinish);
    var startTime = (activity.timeStart);
    var endTime = (activity.timeFinish);
    var endDate = await _convertDayToApi(activity.dayFinish);
    var disabledDates = await _convertSpecificDaysToListString(
        activity.specificDaysDeactivated);
    var removedDates =
        await _convertSpecificDaysToListString(activity.specificDaysRemoved);

    var days = _convertDaysToList(activity.days!);
    days = _convertRepeatTypeDays(days);

    ActivityDayApi activityDayApi = ActivityDayApi(
        phoneNumber.replaceAll("+34", "").replaceAll(" ", ""),
        startDate.toString().split(' ')[0],
        endDate.toString().split(' ')[0],
        startTime,
        activity.activity,
        activity.allDay,
        endTime,
        days,
        Constant.daysToApi[activity.repeatType]!,
        activity.isDeactivate,
        disabledDates,
        removedDates);

    return activityDayApi;
  }

  Future<DateTime> _convertDayToApi(String day) async {
    await Jiffy.locale('es');
    var dayTemp = "";
    if (day.contains('-')) {
      dayTemp = Jiffy(day).format('EEEE, d MMMM yyyy');
    } else {
      dayTemp = day;
    }
    var dateTime = Jiffy(dayTemp, getDefaultPattern()).dateTime;
    return dateTime;
  }

  Future<DateTime> _convertTimeToApi(String time) async {
    await Jiffy.locale('es');

    var dateTime = Jiffy(time.toLowerCase(), getTimePattern()).dateTime;
    return dateTime;
  }

  List<String> _convertRepeatTypeDays(List<String> days) {
    List<String> repeatDays = [];
    for (var day in days) {
      repeatDays.add(Constant.tempMapDayApi[day]!);
    }
    return repeatDays;
  }

  List<String> _convertRepeatTypeDaysApi(List<String> days) {
    List<String> repeatDays = [];
    for (var day in days) {
      repeatDays.add(Constant.tempMapDayReverseApi[day]!);
    }
    return repeatDays;
  }

  List<String> _convertDaysToList(String? days) {
    if (days != null && days.isNotEmpty) {
      var daysArray = days.split(';');
      return daysArray;
    } else {
      return [];
    }
  }

  Future<List<String>> _convertSpecificDaysToListString(
      String? specificDays) async {
    await Jiffy.locale('es');

    if (specificDays != null && specificDays.isNotEmpty) {
      List<String> specificDaysDateTime = [];
      var specifyDays = specificDays.split(';');

      for (var specificDay in specifyDays) {
        if (specificDay.contains('[]')) {
          continue;
        }
        var dayTemp = "";
        if (specificDay.contains('-')) {
          dayTemp = Jiffy(specificDay).format('EEEE, d MMMM yyyy');
        } else {
          dayTemp = specificDay;
        }
        var specificDateTime =
            Jiffy(dayTemp.toLowerCase(), getDefaultPattern()).dateTime;

        specificDaysDateTime.add(specificDateTime.toString());
      }

      return specificDaysDateTime;
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
        var dayTemp = "";
        if (specificDay.contains('-')) {
          dayTemp = Jiffy(specificDay).format('EEEE, d MMMM yyyy');
        } else {
          dayTemp = specificDay;
        }
        var specificDateTime =
            Jiffy(dayTemp.toLowerCase(), getDefaultPattern()).dateTime;

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
      activityDay.day = activityApi.startDate;
      activityDay.timeStart = (activityApi.startTime);
      activityDay.timeFinish = (activityApi.endTime);
      // activityDay.timeStart = await _convertTimeToApk(activityApi.startTime);
      // activityDay.timeFinish = await _convertTimeToApk(activityApi.endTime);
      activityDay.activity = activityApi.name;
      activityDay.allDay = activityApi.allDay;
      activityDay.dayFinish = activityApi.endDate;
      activityDay.days = _convertListToDays(activityApi.days);
      activityDay.repeatType = Constant.daysFromApi[activityApi.repeatType]!;
      activityDay.isDeactivate = activityApi.enabled;
      activityDay.specificDaysDeactivated =
          activityApi.disabledDates.toString();
      activityDay.specificDaysRemoved = activityApi.removedDates.toString();

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
        var convertedDay = Constant.tempMapDayReverseApi[day];
        strDays += '${convertedDay};';
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

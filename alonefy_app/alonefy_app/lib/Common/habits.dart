import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/activityDay.dart';
import 'package:ifeelefine/Model/restday.dart';
import 'package:ifeelefine/Page/LogActivity/Controller/logActivity_controller.dart';
import 'package:ifeelefine/Page/UserRest/Controller/userRestController.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:jiffy/jiffy.dart';

import '../Model/logActivity.dart';
import '../Page/AddActivityPage/Controller/addActivityController.dart';
import '../Page/EditUseMobil/Controller/editUseController.dart';

class Habits {
  final _prefs = PreferenceUser();

  List<LogActivity> activities = [];
  List<RestDay> restDays = [];
  LogActivity? previousLogActivity = null;

  List<ActivityDay> activityDays = [];
  ActivityDay? currentActivityDay = null;

  final AddActivityController addActivityController =
      Get.put(AddActivityController());
  final LogActivityController logActivityController =
      Get.put(LogActivityController());
  final UserRestController userRestController = Get.put(UserRestController());

  DateTime start = DateTime(2023, 4, 12, 4, 0);

  static const int minMinutes = 3;
  static const int maxValidDays = 1;

  int result = 0;
  int movements = -1;

  Future<bool> canUpdateHabits() async {
    Jiffy.locale('es');

    var logActivities = await const HiveData().listLogActivitybd;

    DateTime validDate = DateTime.now();
    validDate = DateTime(validDate.year, validDate.month, validDate.day - 1);

    if (logActivities.isNotEmpty && logActivities[0].time.isBefore(validDate)) {
      return true;
    } else {
      return true;
    }
    //var refreshTime = _prefs.getHabitsRefresh;
    //var date = Jiffy(refreshTime, getDefaultPattern());
//
    //var offset = DateTime(date.year, date.month, date.day + 1);

    //return DateTime.now().isAfter(offset);
  }

  Future<void> fillHabits() async {
    // test
    //int added = 0;
    //for (var i=0;i<15;i++) {
    //  LogActivity logActivity = LogActivity();
    //  DateTime dateTime = DateTime(start.year, start.month, start.day, start.hour, added);
    //  //dateTime.add(Duration(minutes: added));
    //  logActivity.dateTime = dateTime;
    //  logActivity.movementType = "Movimiento normal";
//
    //  //if (i == 10 || i == 11 || i == 12) added += 30;
    //  //else if (i == 13 || i == 14 || i == 15) added += 5;
    //  //else added += 60;
    //  added += 60;
//
    //  activities.add(logActivity);
    //}

    // end test

    activities = await logActivityController.getActivities();
  }

  Future<void> fillRestDays() async {
    // test
    //for (var i=0;i<7;i++) {
    //  RestDay restDay = RestDay();
    //  restDay.day = Constant.weekend[i.toString()]!;
    //  restDay.timeWakeup = '08:00';
    //  restDay.timeSleep = '00:00';
//
    //  restDays.add(restDay);
    //}

    // end test

    restDays = await userRestController.getRestDays();
  }

  Future<void> fillActivityDays() async {
    activityDays = await addActivityController.getActivities();
  }

  Future<void> average() async {
    print("Activities: " + activityDays.length.toString());

    for (var activity in activities) {
      if (isValidDate(activity)) {
        if (isOutOfRestTime(activity) && await isOutOfActivityDay(activity)) {
          if (previousLogActivity != null &&
              isAfterWakeUp(activity) &&
              isPreviousBeforeSleep(activity, previousLogActivity!)) {
            addActivityTimeBetweenDays(activity);
          } else if (previousLogActivity != null &&
              isBeforeActivity(previousLogActivity!) &&
              isAfterActivity(activity)) {
            addActivityTimeBetweenActivity(activity);
          } else {
            addActivityTime(activity);
          }
          previousLogActivity = activity;
        }
      }
    }

    print('Result movements: ' + movements.toString());
    print('Result result: ' + result.toString());
    //print('Result average: ' + (result / movements).toString());
  }

  void updateUseTime(BuildContext context) {
    if (result > 0 && movements > 0) {
      var useMobile = result / movements;
      var useMobileInt = useMobile.toInt();
      print('Use time average: ' + (result / movements).toString());
      _prefs.setHabitsTime = '$useMobileInt min';

      updateUseTimeBD(context, '$useMobileInt min');

      print("Use time: " + _prefs.getHabitsTime);

      showAlert(context, Constant.habitsOk);
    } else {
      showAlert(context, Constant.habitsError);
    }
  }

  void updateUseTimeBD(BuildContext context, String time) {
    final EditUseMobilController editUseMobilVC =
        Get.put(EditUseMobilController());

    editUseMobilVC.saveTimeUseMobileFromHabits(context, time);
  }

  bool isValidDate(LogActivity logActivity) {
    return logActivity.dateTime.isAfter(validDate());
  }

  DateTime validDate() {
    DateTime now = DateTime.now();
    DateTime valid = DateTime(
        now.year, now.month, now.day - maxValidDays, now.hour, now.minute);
    return valid;
  }

  RestDay getRestDay(int weekDay) {
    String day = weekDayToString(weekDay);
    RestDay restWeekDay = RestDay();

    for (var restDay in restDays) {
      if (Constant.weekDays[restDay.day] == day) {
        restWeekDay = restDay;
        break;
      }
    }

    return restWeekDay;
  }

  bool isOutOfRestTime(LogActivity logActivity) {
    RestDay restDay = getRestDay(logActivity.dateTime.weekday);

    DateTime wakeUp = DateTime.now();
    DateTime sleep = DateTime.now();

    if (restDay.timeWakeup.length == 5) {
      wakeUp = parseTime(restDay.timeWakeup, logActivity.dateTime);
    } else {
      wakeUp = parseDurationRow(restDay.timeWakeup);
      wakeUp = DateTime(logActivity.dateTime.year, logActivity.dateTime.month,
          logActivity.dateTime.day, wakeUp.hour, wakeUp.minute);
    }

    if (restDay.timeSleep.length == 5) {
      sleep = parseTime(restDay.timeSleep, logActivity.dateTime);
    } else {
      sleep = parseDurationRow(restDay.timeSleep);
      sleep = DateTime(logActivity.dateTime.year, logActivity.dateTime.month,
          logActivity.dateTime.day, sleep.hour, sleep.minute);
    }

    if (sleep.hour < 5) {
      sleep = DateTime(sleep.year, sleep.month, sleep.day + 1);
    }

    return logActivity.dateTime.isAfter(wakeUp) &&
        logActivity.dateTime.isBefore(sleep);
  }

  Future<bool> isOutOfActivityDay(LogActivity logActivity) async {
    await Jiffy.locale("es");

    var outOfActivityDay = true;

    for (var activityDay in activityDays) {
      print("activityDay: " +
          activityDay.activity +
          "   " +
          activityDay.repeatType +
          activityDay.enabled.toString());
      if (!activityDay.enabled) {
        var startDate =
            Jiffy(activityDay.day.toLowerCase(), 'EEEE, d MMMM yyyy').dateTime;
        var endDate =
            Jiffy(activityDay.dayFinish.toLowerCase(), 'EEEE, d MMMM yyyy')
                .dateTime;

        startDate = parseTime(activityDay.timeStart, startDate);
        endDate = parseTime(activityDay.timeFinish, endDate);

        print("Activity log: " + logActivity.dateTime.toString());
        print("Activity log start: " + startDate.toString());
        print("Activity log end: " + endDate.toString());

        if (!logActivity.dateTime.isBefore(startDate) &&
            !logActivity.dateTime.isAfter(endDate)) {
          print("Activity in: " + logActivity.dateTime.toString());
          if (!isDayRemoved(activityDay, logActivity.dateTime) &&
              !isDayDeactivated(activityDay, logActivity.dateTime)) {
            if (isInSameDay(activityDay, logActivity.dateTime)) {
              var start =
                  parseTime(activityDay.timeStart, logActivity.dateTime);
              var end = parseTime(activityDay.timeFinish, logActivity.dateTime);
              print("isInActivityDayTime start: " + start.toString());
              print("isInActivityDayTime end: " + end.toString());
              print("isInActivityDayTime dateTime: " +
                  logActivity.dateTime.toString());
              if (isInActivityDayTime(start, end, logActivity.dateTime)) {
                print("isInActivityDayTime dateTime: ok");
                currentActivityDay = activityDay;
                currentActivityDay!.day =
                    Jiffy(start).format(getDefaultPattern());
                currentActivityDay!.dayFinish =
                    Jiffy(end).format(getDefaultPattern());

                outOfActivityDay = false;
                break;
              }

              //outOfActivityDay = false;
              //currentActivityDay = activityDay;
              //break;
            }
          }
        }
      }
    }

    return outOfActivityDay;
  }

  bool isBeforeActivity(LogActivity logActivity) {
    if (currentActivityDay != null) {
      var startDate =
          Jiffy(currentActivityDay!.day.toLowerCase(), 'EEEE, d MMMM yyyy')
              .dateTime;
      startDate = parseTime(currentActivityDay!.timeStart, startDate);

      print("Activity isBefore start: " + startDate.toString());
      print("Activity isBefore current: " + logActivity.dateTime.toString());

      if (logActivity.dateTime.isBefore(startDate)) {
        return true;
      }
    }

    return false;
  }

  bool isAfterActivity(LogActivity logActivity) {
    if (currentActivityDay != null) {
      var endDate = Jiffy(
              currentActivityDay!.dayFinish.toLowerCase(), 'EEEE, d MMMM yyyy')
          .dateTime;
      endDate = parseTime(currentActivityDay!.timeFinish, endDate);

      print("Activity isAfter end: " + endDate.toString());
      print("Activity isAfter current: " + logActivity.dateTime.toString());

      if (logActivity.dateTime.isAfter(endDate)) {
        return true;
      }
    }

    return false;
  }

  bool isDayRemoved(ActivityDay activityDay, DateTime dateTime) {
    if (activityDay.specificDaysRemoved != null &&
        activityDay.specificDaysRemoved!.isNotEmpty) {
      var daysRemoved = activityDay.specificDaysRemoved!.split(';');
      for (var dayRemoved in daysRemoved) {
        var dayRemovedDate =
            Jiffy(dayRemoved.toLowerCase(), 'EEEE, d MMMM yyyy').dateTime;
        if (dayRemovedDate.year == dateTime.year &&
            dayRemovedDate.month == dateTime.month &&
            dayRemovedDate.day == dateTime.day) {
          return true;
        }
      }
    }

    return false;
  }

  bool isDayDeactivated(ActivityDay activityDay, DateTime dateTime) {
    if (activityDay.specificDaysDeactivated != null &&
        activityDay.specificDaysDeactivated!.isNotEmpty) {
      var specifyDaysDeactivated =
          activityDay.specificDaysDeactivated!.split(';');

      for (var specifyDayDeactivated in specifyDaysDeactivated) {
        var specifyDayDateTime =
            Jiffy(specifyDayDeactivated.toLowerCase(), getDefaultPattern())
                .dateTime;

        if (specifyDayDateTime.year == dateTime.year &&
            specifyDayDateTime.month == dateTime.month &&
            specifyDayDateTime.day == dateTime.day) {
          return true;
        }
      }
    }

    return false;
  }

  bool isInSameDay(ActivityDay activityDay, DateTime dateTime) {
    switch (activityDay.repeatType) {
      case Constant.onceTime:
        var onceDate =
            Jiffy(activityDay.day.toLowerCase(), getDefaultPattern()).dateTime;
        if (onceDate.year == dateTime.year &&
            onceDate.month == dateTime.month &&
            onceDate.day == dateTime.day) {
          return true; //isInActivityDayTime(activityDay, onceDate, dateTime);
        }
        return false;
      case Constant.diary:
        //var diaryStartDate = Jiffy(activityDay.day.toLowerCase(), getDefaultPattern()).dateTime;
        //var diaryEndDate = Jiffy(activityDay.dayFinish.toLowerCase(), getDefaultPattern()).dateTime;
//
        //if (!diaryStartDate.isAfter(dateTime) &&
        //    !diaryEndDate.isBefore(dateTime)) {
        //  return true;//isInActivityDayTime(activityDay, dateTime, dateTime);
        //}
        return true;
      case Constant.weekly:
        if (activityDay.days != null && activityDay.days!.isNotEmpty) {
          var daysRepeated = activityDay.days!.split(';');
          for (var day in daysRepeated) {
            for (var index = 0;
                index < Constant.tempListShortDay.length;
                index++) {
              if (dateTime.weekday == (index + 1) &&
                  day == Constant.tempListShortDay[index]) {
                return true; //isInActivityDayTime(activityDay, dateTime, dateTime);
              }
            }
          }
        }
        return false;
      case Constant.monthly:
        var monthlyStartDate =
            Jiffy(activityDay.day.toLowerCase(), getDefaultPattern()).dateTime;

        if (monthlyStartDate.day == dateTime.day) {
          return true; //isInActivityDayTime(activityDay, dateTime, dateTime);
        }

        return false;
      case Constant.yearly:
        var yearlyStartDate =
            Jiffy(activityDay.day.toLowerCase(), getDefaultPattern()).dateTime;

        if (yearlyStartDate.month == dateTime.month &&
            yearlyStartDate.day == dateTime.day) {
          return true; //isInActivityDayTime(activityDay, dateTime, dateTime);
        }
        return false;
    }

    return false;
  }

  //bool isInActivityDayTime(ActivityDay activityDay, DateTime activityDayDateTime, DateTime dateTime) {
  //  var start = parseTime(activityDay.timeStart, activityDayDateTime);
  //  var end = parseTime(activityDay.timeFinish, activityDayDateTime);
//
  //  return start.isBefore(dateTime) && end.isAfter(dateTime);
  //}

  bool isInActivityDayTime(DateTime start, DateTime end, DateTime dateTime) {
    return !start.isAfter(dateTime) && !end.isBefore(dateTime);
  }

  bool isAfterWakeUp(LogActivity logActivity) {
    RestDay restDay = getRestDay(logActivity.dateTime.weekday);

    DateTime wakeUp = DateTime.now();

    if (restDay.timeWakeup.length == 5) {
      wakeUp = parseTime(restDay.timeWakeup, logActivity.dateTime);
    } else {
      wakeUp = parseDurationRow(restDay.timeWakeup);
      wakeUp = DateTime(logActivity.dateTime.year, logActivity.dateTime.month,
          logActivity.dateTime.day, wakeUp.hour, wakeUp.minute);
    }

    //DateTime wakeUp = parseTime(restDay.timeWakeup, logActivity.dateTime);

    print("Resultado wake: " + wakeUp.toString());

    return logActivity.dateTime.isAfter(wakeUp);
  }

  bool isPreviousBeforeSleep(
      LogActivity currentLogActivity, LogActivity logActivity) {
    RestDay restDay = getRestDay(logActivity.dateTime.weekday);

    DateTime sleep = DateTime.now();

    if (restDay.timeSleep.length == 5) {
      sleep = parseTime(restDay.timeSleep, logActivity.dateTime);
    } else {
      sleep = parseDurationRow(restDay.timeSleep);
      sleep = DateTime(logActivity.dateTime.year, logActivity.dateTime.month,
          logActivity.dateTime.day, sleep.hour, sleep.minute);
    }

    //DateTime sleep = parseTime(restDay.timeSleep, logActivity.dateTime);
    if (sleep.hour == 0 && sleep.minute == 0) {
      sleep = DateTime(sleep.year, sleep.month, sleep.day + 1);
    }

    if (currentLogActivity.dateTime.day == logActivity.dateTime.day) {
      return false;
    }

    print("Resultado sleep: " + sleep.toString());

    return logActivity.dateTime.isBefore(sleep);
  }

  int getTimeBetweenMovementAndRestSleep(LogActivity logActivity) {
    RestDay restSleep = getRestDay(logActivity.dateTime.weekday);

    DateTime sleep = DateTime.now();

    if (restSleep.timeSleep.length == 5) {
      sleep = parseTime(restSleep.timeSleep, logActivity.dateTime);
    } else {
      sleep = parseDurationRow(restSleep.timeSleep);
      sleep = DateTime(logActivity.dateTime.year, logActivity.dateTime.month,
          logActivity.dateTime.day, sleep.hour, sleep.minute);
    }

    //DateTime sleep = parseTime(restSleep.timeSleep, logActivity.dateTime);
    if (sleep.hour == 0 && sleep.minute == 0) {
      sleep = DateTime(sleep.year, sleep.month, sleep.day + 1);
    }
    return getTimeBetweenMovementAndRest(sleep, logActivity);
  }

  int getTimeBetweenMovementAndRestWakeUp(LogActivity logActivity) {
    RestDay restWakeUp = getRestDay(logActivity.dateTime.weekday);

    DateTime wakeUp = DateTime.now();

    if (restWakeUp.timeWakeup.length == 5) {
      wakeUp = parseTime(restWakeUp.timeWakeup, logActivity.dateTime);
    } else {
      wakeUp = parseDurationRow(restWakeUp.timeWakeup);
      wakeUp = DateTime(logActivity.dateTime.year, logActivity.dateTime.month,
          logActivity.dateTime.day, wakeUp.hour, wakeUp.minute);
    }
    //DateTime wakeUp = parseTime(restWakeUp.timeWakeup, logActivity.dateTime);
    return getTimeBetweenMovementAndRest(wakeUp, logActivity);
  }

  int getTimeBetweenMovementAndRest(DateTime rest, LogActivity logActivity) {
    var difference = rest.difference(logActivity.dateTime).inMinutes;

    return difference.abs();
  }

  void addActivityTimeBetweenDays(LogActivity activity) {
    int diffSleep = getTimeBetweenMovementAndRestSleep(previousLogActivity!);
    int diffWakeUp = getTimeBetweenMovementAndRestWakeUp(activity);

    int minutes = diffSleep + diffWakeUp;

    print("Result between sleep: " + diffSleep.toString());
    print("Result between wake: " + diffWakeUp.toString());
    print("Result between: " + minutes.toString());

    if (minutes >= minMinutes) {
      result = result + minutes;
      movements++;
      print("Result minutes added: " + minutes.toString());
    }
  }

  void addActivityTimeBetweenActivity(LogActivity activity) {
    int diffBefore =
        getTimeBetweenMovementAndStartActivity(previousLogActivity!);
    int diffAfter = getTimeBetweenMovementAndEndActivity(activity);

    int minutes = diffBefore + diffAfter;

    print("Activity time: " + minutes.toString());

    if (minutes >= minMinutes) {
      result = result + minutes;
      movements++;
    }
  }

  int getTimeBetweenMovementAndStartActivity(LogActivity activity) {
    var startDate =
        Jiffy(currentActivityDay!.day.toLowerCase(), 'EEEE, d MMMM yyyy')
            .dateTime;
    startDate = parseTime(currentActivityDay!.timeStart, startDate);

    var diff = startDate.difference(activity.dateTime).inMinutes;

    return diff.abs();
  }

  int getTimeBetweenMovementAndEndActivity(LogActivity activity) {
    var endDate =
        Jiffy(currentActivityDay!.dayFinish.toLowerCase(), 'EEEE, d MMMM yyyy')
            .dateTime;
    endDate = parseTime(currentActivityDay!.timeFinish, endDate);

    var diff = endDate.difference(activity.dateTime).inMinutes;

    return diff.abs();
  }

  void addActivityTime(LogActivity activity) {
    if (movements > -1) {
      if (activity.dateTime
              .difference(previousLogActivity!.dateTime)
              .inMinutes >=
          minMinutes) {
        var minutes = activity.dateTime
            .difference(previousLogActivity!.dateTime)
            .inMinutes;
        result += minutes;
        movements++;
        print("Result minutes added2: " + minutes.toString());
      }
    } else {
      movements++;
    }
  }
}

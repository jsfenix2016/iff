import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/ApiRest/activityDayApi.dart';

class ActivityDayApiResponse {
  late int id;
  late String phoneNumber;
  late DateTime startDate;
  late DateTime endDate;
  late DateTime startTime;
  late String name;
  late bool allDay;
  late DateTime endTime;
  List<String>? days = [];
  late String repeatType;
  late bool enabled;
  List<DateTime>? disabledDates = [];
  List<DateTime>? removedDates = [];

  ActivityDayApiResponse({
      required this.id,
      required this.phoneNumber,
      required this.startDate,
      required this.endDate,
      required this.startTime,
      required this.name,
      required this.allDay,
      required this.endTime,
      this.days,
      required this.repeatType,
      required this.enabled,
      this.disabledDates,
      this.removedDates});

  ActivityDayApiResponse.fromActivityDayApi(ActivityDayApi activityDayApi, int id) {
      this.id= id;
      phoneNumber= activityDayApi.phoneNumber;
      startDate= activityDayApi.startDate;
      endDate= activityDayApi.endDate;
      startTime= activityDayApi.startTime;
      name= activityDayApi.name;
      allDay= activityDayApi.allDay;
      endTime= activityDayApi.endTime;
      days= activityDayApi.days;
      repeatType= activityDayApi.repeatType;
      enabled= activityDayApi.enabled;
      disabledDates= activityDayApi.disabledDates;
      removedDates= activityDayApi.removedDates;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'phoneNumber': phoneNumber,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'startTime': startTime.toIso8601String(),
    'name': name,
    'allDay': allDay,
    'endTime': endTime.toIso8601String(),
    'days': days,
    'repeatType': repeatType,
    'enabled': enabled,
    'disabledDates': encodeDateTimeOfList(disabledDates!),
    'removedDates': encodeDateTimeOfList(removedDates!)
  };

  factory ActivityDayApiResponse.fromJson(Map<String, dynamic> json) {
    return ActivityDayApiResponse(
        id: json['id'],
        phoneNumber: json['phoneNumber'],
        startDate: jsonToDatetime(json['startDate'], getDefaultPattern()),
        endDate: jsonToDatetime(json['endDate'], getDefaultPattern()),
        startTime: jsonToDatetime(json['startTime'], getTimePattern()),
        name: json['name'],
        allDay: json['allDay'],
        endTime: jsonToDatetime(json['endTime'], getTimePattern()),
        days: dynamicToStringList(json['days']),
        repeatType: json['repeatType'],
        enabled: json['enabled'],
        disabledDates: dynamicToDateTimeList(json['disabledDates']),
        removedDates: dynamicToDateTimeList(json['removedDates'])
    );
  }

  dynamic encodeDateTimeOfList(List<DateTime> list) {
    List<String> datetimeList = [];

    for (var item in list) {
      datetimeList.add(item.toIso8601String());
    }
    return datetimeList;
  }


}

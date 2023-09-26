import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/ApiRest/activityDayApi.dart';

class ActivityDayApiResponse {
  late int id;
  late String phoneNumber;
  late String startDate;
  late String endDate;
  late String startTime;
  late String name;
  late bool allDay;
  late String endTime;
  List<String>? days = [];
  late String repeatType;
  late bool enabled;
  List<String>? disabledDates = [];
  List<String>? removedDates = [];

  ActivityDayApiResponse(
      {required this.id,
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

  ActivityDayApiResponse.fromActivityDayApi(
      ActivityDayApi activityDayApi, int id) {
    this.id = id;
    phoneNumber = activityDayApi.phoneNumber;
    startDate = activityDayApi.startDate;
    endDate = activityDayApi.endDate;
    startTime = activityDayApi.startTime;
    name = activityDayApi.name;
    allDay = activityDayApi.allDay;
    endTime = activityDayApi.endTime;
    days = activityDayApi.days;
    repeatType = activityDayApi.repeatType;
    enabled = activityDayApi.enabled;
    disabledDates = activityDayApi.disabledDates;
    removedDates = activityDayApi.removedDates;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'phoneNumber': phoneNumber,
        'startDate': startDate,
        'endDate': endDate,
        'startTime': startTime,
        'name': name,
        'allDay': allDay,
        'endTime': endTime,
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
        startDate: jsonToString(json['startDate'], getDefaultPattern()),
        endDate: jsonToString(json['endDate'], getDefaultPattern()),
        // startTime: jsonToDatetime(json['startTime'], getTimePattern()),
        startTime: json['startTime'],
        endTime: (json['endTime']),
        name: json['name'],
        allDay: json['allDay'],
        // endTime: jsonToDatetime(json['endTime'], getTimePattern()),
        days: dynamicToStringList(json['days']),
        repeatType: json['repeatType'],
        enabled: json['enabled'],
        disabledDates: dynamicToStringList(json['disabledDates']),
        removedDates: dynamicToStringList(json['removedDates']));
  }

  dynamic encodeDateTimeOfList(List<String> list) {
    List<String> datetimeList = [];

    for (var item in list) {
      if (item.contains(' ')) {
        datetimeList.add(item.split(' ')[0]);
      } else {
        datetimeList.add(item);
      }
    }
    return datetimeList;
  }
}

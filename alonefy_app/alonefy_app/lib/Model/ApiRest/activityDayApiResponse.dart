import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/utils.dart';

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


}

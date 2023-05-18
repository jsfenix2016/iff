class ActivityDayApi {
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

  ActivityDayApi(
      this.phoneNumber,
      this.startDate,
      this.endDate,
      this.startTime,
      this.name,
      this.allDay,
      this.endTime,
      this.days,
      this.repeatType,
      this.enabled,
      this.disabledDates,
      this.removedDates
    );

  Map<String, dynamic> toJson() => {
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

  dynamic encodeDateTimeOfList(List<DateTime> list) {
    List<String> datetimeList = [];

    for (var item in list) {
      datetimeList.add(item.toIso8601String());
    }
    return datetimeList;
  }
}

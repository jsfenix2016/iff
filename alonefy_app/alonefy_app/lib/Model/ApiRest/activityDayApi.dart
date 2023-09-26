class ActivityDayApi {
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
      this.removedDates);

  Map<String, dynamic> toJson() => {
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

  dynamic encodeDateTimeOfList(List<String> list) {
    List<String> datetimeList = [];

    for (var item in list) {
      datetimeList.add(item);
    }
    return datetimeList;
  }
}

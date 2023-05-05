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
}

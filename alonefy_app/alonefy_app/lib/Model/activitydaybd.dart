import 'package:hive_flutter/hive_flutter.dart';

import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';

part 'Adapters/activitydaybd.g.dart';

@HiveType(typeId: HiveConstantAdapterInit.idActivityDayDBAdapter)
class ActivityDayBD extends HiveObject {
  ActivityDayBD(
      {required this.id,
      required this.activity,
      this.allDay = false,
      required this.day,
      this.dayFinish = "",
      required this.timeStart,
      required this.timeFinish,
      this.days = "",
      this.repeatType = "",
      this.isDeactivate = false,
      this.specificDaysDeactivated = "",
      this.specificDaysRemoved = ""});

  @HiveField(0)
  final String day;

  @HiveField(1)
  final String timeStart;

  @HiveField(2)
  final String timeFinish;

  @HiveField(3)
  final String activity;

  @HiveField(4)
  final int id;

  @HiveField(5)
  final bool allDay;

  @HiveField(6)
  final String dayFinish;

  @HiveField(7)
  final String days;

  @HiveField(8)
  final String repeatType;

  @HiveField(9)
  final bool isDeactivate;

  @HiveField(10)
  final String specificDaysDeactivated;

  @HiveField(11)
  final String specificDaysRemoved;
}

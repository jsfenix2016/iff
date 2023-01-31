import 'package:hive_flutter/hive_flutter.dart';

part 'activitydaybd.g.dart';

@HiveType(typeId: 3)
class ActivityDayBD extends HiveObject {
  ActivityDayBD(
      {required this.day,
      required this.timeWakeup,
      required this.timeSleep,
      required this.activity,
      required this.id});

  @HiveField(0)
  final String day;

  @HiveField(1)
  final String timeWakeup;

  @HiveField(2)
  final String timeSleep;

  @HiveField(3)
  final String activity;

  @HiveField(4)
  final int id;
}

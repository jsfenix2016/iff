import 'package:hive_flutter/hive_flutter.dart';

part 'Adapters/activitydaybd.g.dart';

@HiveType(typeId: 3)
class ActivityDayBD extends HiveObject {
  ActivityDayBD(
      {required this.day,
      required this.timeStart,
      required this.timeFinish,
      required this.activity,
      required this.id,
      required this.selection});

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
  final int selection;
}

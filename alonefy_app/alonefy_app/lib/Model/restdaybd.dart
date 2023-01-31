import 'package:hive_flutter/hive_flutter.dart';

part 'Adapters/restdaybd.g.dart';

@HiveType(typeId: 1)
class RestDayBD extends HiveObject {
  RestDayBD({
    required this.day,
    required this.timeWakeup,
    required this.timeSleep,
  });

  @HiveField(0)
  final String day;

  @HiveField(1)
  late final String timeWakeup;

  @HiveField(2)
  late final String timeSleep;
}

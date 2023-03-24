import 'package:hive_flutter/hive_flutter.dart';

part 'Adapters/activitydaybd.g.dart';

const String onceTime = "Evento de una sola vez";
const String diary = "Diario";
const String weekly = "Semanal";
const String monthly = "Mensual";
const String yearly = "Anual";

@HiveType(typeId: 3)
class ActivityDayBD extends HiveObject {
  //ActivityDayBD(
  //    {required this.day,
  //    required this.timeStart,
  //    required this.timeFinish,
  //    required this.activity,
  //    required this.id});

  ActivityDayBD({
    required this.id,
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
    this.specificDaysRemoved = ""
  });

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

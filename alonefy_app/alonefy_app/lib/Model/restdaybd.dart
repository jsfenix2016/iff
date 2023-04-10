import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';

part 'restdaybd.g.dart';

@HiveType(typeId: HiveConstantAdapterInit.idRestDayDBAdapter)
class RestDayBD extends HiveObject {
  RestDayBD(
      {required this.day,
      required this.timeWakeup,
      required this.timeSleep,
      required this.selection,
      required this.isSelect});

  @HiveField(0)
  late String day;

  @HiveField(1)
  late String timeWakeup;

  @HiveField(2)
  late String timeSleep;

  @HiveField(3)
  late int selection;

  @HiveField(4)
  late bool isSelect;
}

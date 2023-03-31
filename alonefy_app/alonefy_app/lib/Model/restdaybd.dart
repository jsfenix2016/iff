import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';

part 'Adapters/restdaybd.g.dart';

@HiveType(typeId: HiveConstantAdapterInit.idRestDayDBAdapter)
class RestDayBD extends HiveObject {
  RestDayBD(
      {required this.day,
      required this.timeWakeup,
      required this.timeSleep,
      required this.selection});

  @HiveField(0)
  late final String day;

  @HiveField(1)
  late final String timeWakeup;

  @HiveField(2)
  late final String timeSleep;

  @HiveField(3)
  late final int selection;
}

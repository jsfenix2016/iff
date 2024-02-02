import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';

part 'Adapters/logActivityBd.g.dart';

@HiveType(typeId: 7)
class LogActivityBD extends HiveObject {
  LogActivityBD(
      {required this.time, required this.movementType, required this.groupBy});

  @HiveField(0)
  final DateTime time;

  @HiveField(1)
  final String movementType;

  @HiveField(2)
  final String groupBy;
}

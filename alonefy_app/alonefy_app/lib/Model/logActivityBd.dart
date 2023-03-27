import 'package:hive_flutter/hive_flutter.dart';

part 'Adapters/logActivityBd.g.dart';

@HiveType(typeId: 5)
class LogActivityBD extends HiveObject {

  LogActivityBD({
    required this.id,
    required this.dateTime,
    required this.movementType
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final DateTime dateTime;

  @HiveField(2)
  final String movementType;
}

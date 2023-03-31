import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';

part 'Adapters/logActivityBd.g.dart';

@HiveType(typeId: HiveConstantAdapterInit.idLogActivityBDAdapter)
class LogActivityBD extends HiveObject {
  LogActivityBD(
      {required this.id, required this.dateTime, required this.movementType});

  @HiveField(0)
  final int id;

  @HiveField(1)
  final DateTime dateTime;

  @HiveField(2)
  final String movementType;
}

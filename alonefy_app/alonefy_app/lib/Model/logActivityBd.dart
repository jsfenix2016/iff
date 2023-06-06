import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';

part 'Adapters/logActivityBd.g.dart';

@HiveType(typeId: HiveConstantAdapterInit.idLogActivityBDAdapter)
class LogActivityBD extends HiveObject {
  LogActivityBD({required this.time, required this.movementType});

  @HiveField(0)
  final DateTime time;

  @HiveField(1)
  final String movementType;
}

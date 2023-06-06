import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';

part 'logAlertsBD.g.dart';

@HiveType(typeId: 2)
class LogAlertsBD extends HiveObject {
  LogAlertsBD({required this.id, required this.typeAction, required this.time});

  @HiveField(0)
  late int id;

  @HiveField(1)
  late String typeAction;

  @HiveField(2)
  late DateTime time;

}

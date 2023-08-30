import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';

part 'Adapters/logAlertsBD.g.dart';

@HiveType(typeId: 2)
class LogAlertsBD extends HiveObject {
  LogAlertsBD(
      {required this.id,
      required this.type,
      required this.time,
      this.photoDate,
      this.video});

  @HiveField(0)
  late int id;

  @HiveField(1)
  late String type;

  @HiveField(2)
  late DateTime time;

  @HiveField(3)
  List<Uint8List>? photoDate;

  @HiveField(4)
  Uint8List? video;
}

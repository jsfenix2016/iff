import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Model/videopresignedbd.dart';

part 'Adapters/logAlertsBD.g.dart';

@HiveType(typeId: 2)
class LogAlertsBD extends HiveObject {
  LogAlertsBD(
      {required this.id,
      required this.type,
      required this.time,
      this.photoDate,
      this.video,
      required this.groupBy,
      this.listVideosPresigned});

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

  @HiveField(5)
  late String groupBy;

  @HiveField(6)
  List<VideoPresignedBD>? listVideosPresigned;
}

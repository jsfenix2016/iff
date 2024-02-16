import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';

part 'Adapters/videopresignedbd.g.dart';

@HiveType(typeId: 9)
class VideoPresignedBD extends HiveObject {
  VideoPresignedBD({required this.modified, required this.url, this.videoDown});

  @HiveField(0)
  final String modified;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final Uint8List? videoDown;
}

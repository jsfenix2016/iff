import 'package:hive_flutter/hive_flutter.dart';

part 'Adapters/userpositionbd.g.dart';

@HiveType(typeId: 2)
class UserPositionBD extends HiveObject {
  UserPositionBD(
      {required this.typeAction,
      required this.time,
      required this.movRureUser});

  @HiveField(0)
  late String typeAction;

  @HiveField(1)
  late DateTime time;

  @HiveField(2)
  late DateTime movRureUser;
}

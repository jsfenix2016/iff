import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';

part 'useMobilbd.g.dart';

@HiveType(typeId: HiveConstantAdapterInit.idUseMobilBDAdapter)
class UseMobilBD extends HiveObject {
  UseMobilBD(
      {required this.day,
      required this.time,
      required this.selection,
      required this.isSelect});

  @HiveField(0)
  late String day;

  @HiveField(1)
  late String time;

  @HiveField(2)
  late int selection;

  @HiveField(3)
  late bool isSelect;
}

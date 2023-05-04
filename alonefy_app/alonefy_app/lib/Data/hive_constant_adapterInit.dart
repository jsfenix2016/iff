import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Model/activitydaybd.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Model/logActivityBd.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'package:ifeelefine/Model/useMobilbd.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:path_provider/path_provider.dart';

class HiveConstantAdapterInit {
  static const int idUserDBAdapter = 0;
  static const int idRestDayDBAdapter = 1;
  static const int idUserPositionDBAdapter = 2;
  static const int idActivityDayDBAdapter = 3;
  static const int idContactBDAdapter = 4;
  static const int idContactRiskBDAdapter = 5;
  static const int idContactZoneRiskBDAdapter = 6;
  static const int idLogActivityBDAdapter = 7;
  static const int idUseMobilBDAdapter = 8;
}

Future inicializeHiveBD() async {
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDirectory.path);
  if (!Hive.isAdapterRegistered(LogAlertsBDAdapter().typeId)) {
    Hive.registerAdapter(LogAlertsBDAdapter());
  }

  if (!Hive.isAdapterRegistered(UserBDAdapter().typeId)) {
    Hive.registerAdapter(UserBDAdapter());
  }

  if (!Hive.isAdapterRegistered(ActivityDayBDAdapter().typeId)) {
    Hive.registerAdapter(ActivityDayBDAdapter());
  }

  if (!Hive.isAdapterRegistered(RestDayBDAdapter().typeId)) {
    Hive.registerAdapter(RestDayBDAdapter());
  }
  if (!Hive.isAdapterRegistered(ContactBDAdapter().typeId)) {
    Hive.registerAdapter(ContactBDAdapter());
  }
  if (!Hive.isAdapterRegistered(ContactRiskBDAdapter().typeId)) {
    Hive.registerAdapter(ContactRiskBDAdapter());
  }
  if (!Hive.isAdapterRegistered(ContactZoneRiskBDAdapter().typeId)) {
    Hive.registerAdapter(ContactZoneRiskBDAdapter());
  }
  if (!Hive.isAdapterRegistered(LogActivityBDAdapter().typeId)) {
    Hive.registerAdapter(LogActivityBDAdapter());
  }
  if (!Hive.isAdapterRegistered(UseMobilBDAdapter().typeId)) {
    Hive.registerAdapter(UseMobilBDAdapter());
  }
}

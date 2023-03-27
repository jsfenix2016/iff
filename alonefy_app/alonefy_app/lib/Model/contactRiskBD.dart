import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'contactRiskBD.g.dart';

@HiveType(typeId: 5)
class ContactRiskBD {
  ContactRiskBD(
      {required this.id,
      required this.photo,
      required this.name,
      required this.timeinit,
      required this.timefinish,
      required this.phones,
      required this.titleMessage,
      required this.messages,
      required this.sendLocation,
      required this.sendWhatsapp,
      required this.isInitTime,
      required this.isFinishTime,
      required this.code,
      required this.isActived,
      required this.isprogrammed});

  @HiveField(0)
  int id;

  @HiveField(1)
  Uint8List? photo;

  @HiveField(2)
  String name;

  @HiveField(3)
  String timeinit;

  @HiveField(4)
  String timefinish;

  @HiveField(5)
  String phones;

  @HiveField(6)
  String titleMessage;
  @HiveField(7)
  String messages;

  @HiveField(8)
  bool sendWhatsapp;

  @HiveField(9)
  bool sendLocation;

  @HiveField(10)
  bool isInitTime;

  @HiveField(11)
  bool isFinishTime;

  @HiveField(12)
  String code;

  @HiveField(13)
  bool isActived;

  @HiveField(14)
  bool isprogrammed;

  @HiveField(15)
  Uint8List? photoDate;
}

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';

part 'ApiRest/contactRiskBD.g.dart';

@HiveType(typeId: HiveConstantAdapterInit.idContactRiskBDAdapter)
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
      required this.isprogrammed,
      required this.photoDate,
      required this.saveContact,
      required this.createDate,
      required this.taskIds,
      required this.finish});

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
  List<Uint8List> photoDate;

  @HiveField(16)
  bool saveContact;

  @HiveField(17)
  DateTime createDate;

  @HiveField(18)
  List<String>? taskIds;

  @HiveField(19)
  bool finish;
}

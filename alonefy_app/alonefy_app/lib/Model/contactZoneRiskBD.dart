import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';

part 'Adapters/contactZoneRiskBD.g.dart';

@HiveType(typeId: HiveConstantAdapterInit.idContactZoneRiskBDAdapter)
class ContactZoneRiskBD {
  ContactZoneRiskBD(
      {required this.id,
      required this.photo,
      required this.name,
      required this.phones,
      required this.sendLocation,
      required this.sendWhatsapp,
      required this.code,
      required this.isActived,
      required this.sendWhatsappContact,
      required this.callme,
      required this.save,
      required this.createDate,
      this.video});

  @HiveField(0)
  int id;

  @HiveField(1)
  Uint8List? photo;

  @HiveField(2)
  String name;

  @HiveField(3)
  String phones;

  @HiveField(4)
  bool sendWhatsapp;

  @HiveField(5)
  bool sendLocation;

  @HiveField(6)
  String code;

  @HiveField(7)
  bool isActived;

  @HiveField(8)
  bool sendWhatsappContact;

  @HiveField(9)
  bool callme;

  @HiveField(10)
  bool save;

  @HiveField(11)
  DateTime createDate;

  @HiveField(12)
  Uint8List? video;
}

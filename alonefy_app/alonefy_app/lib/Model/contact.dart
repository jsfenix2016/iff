import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
part 'Adapters/contact.g.dart';

@HiveType(typeId: HiveConstantAdapterInit.idContactBDAdapter)
class ContactBD extends HiveObject {
  ContactBD(this.displayName, this.photo, this.name, this.timeSendSMS,
      this.timeCall, this.timeWhatsapp, this.phones, this.requestStatus);

  @HiveField(0)
  String displayName;

  @HiveField(1)
  Uint8List? photo;

  @HiveField(2)
  String name;

  @HiveField(3)
  String timeSendSMS;

  @HiveField(4)
  String timeCall;
  @HiveField(5)
  String timeWhatsapp;
  @HiveField(6)
  String phones;

  @HiveField(7)
  String requestStatus;
}

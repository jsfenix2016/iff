import 'package:ifeelefine/Model/contactRiskBD.dart';

import '../../Common/utils.dart';

class ContactRiskApi {
  late int id;
  late String phoneNumber;
  late String photo;
  late String name;
  late DateTime timeinit;
  late DateTime timefinish;
  late String phones;
  late String titlemessage;
  late String messages;
  late bool sendwhatsapp;
  late bool sendlocation;
  late bool isinittime;
  late bool isfinishtime;
  late String code;
  late bool isactived;
  late bool isprogrammed;
  late List<String> photodate;
  late bool savecontact;

  ContactRiskApi({
      required this.phoneNumber,
      required this.photo,
      required this.name,
      required this.timeinit,
      required this.timefinish,
      required this.phones,
      required this.titlemessage,
      required this.messages,
      required this.sendwhatsapp,
      required this.sendlocation,
      required this.isinittime,
      required this.isfinishtime,
      required this.code,
      required this.isactived,
      required this.isprogrammed,
      required this.photodate,
      required this.savecontact});

  ContactRiskApi.fromContact(ContactRiskBD contactRisk, this.phoneNumber) {
    photo = contactRisk.photo.toString();
    name = contactRisk.name;
    timeinit = parseDurationRow(contactRisk.timeinit);
    timefinish = parseDurationRow(contactRisk.timefinish);
    phones = contactRisk.phones;
    titlemessage = contactRisk.titleMessage;
    messages = contactRisk.messages;
    sendwhatsapp = contactRisk.sendWhatsapp;
    sendlocation = contactRisk.sendLocation;
    isinittime = contactRisk.isInitTime;
    isfinishtime = contactRisk.isFinishTime;
    code = contactRisk.code;
    isactived = contactRisk.isActived;
    isprogrammed = contactRisk.isprogrammed;
    photodate = [];
    savecontact = contactRisk.saveContact;
  }

  ContactRiskApi.fromApi({
    required this.id,
    required this.phoneNumber,
    required this.photo,
    required this.name,
    required this.timeinit,
    required this.timefinish,
    required this.phones,
    required this.titlemessage,
    required this.messages,
    required this.sendwhatsapp,
    required this.sendlocation,
    required this.isinittime,
    required this.isfinishtime,
    required this.code,
    required this.isactived,
    required this.isprogrammed,
    required this.photodate,
    required this.savecontact});

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'photo': photo,
    'name': name,
    'timeinit': timeinit.toIso8601String(),
    'timefinish': timefinish.toIso8601String(),
    'phones': phones,
    'titlemessage': titlemessage,
    'messages': messages,
    'sendwhatsapp': sendwhatsapp,
    'sendlocation': sendlocation,
    'isinittime': isinittime,
    'isfinishtime': isfinishtime,
    'code': code,
    'isactived': isactived,
    'isprogrammed': isprogrammed,
    'photodate': photodate,
    'savecontact': savecontact
  };

  factory ContactRiskApi.fromJson(Map<String, dynamic> json) {
    return ContactRiskApi.fromApi(
        id: json['id'],
        phoneNumber: json['phoneNumber'],
        photo: json['photo'],
        name: json['name'],
        timeinit: json['timeinit'],
        timefinish: json['timefinish'],
        phones: json['phones'],
        titlemessage: json['titlemessage'],
        messages: json['messages'],
        sendwhatsapp: json['sendwhatsapp'],
        sendlocation: json['sendlocation'],
        isinittime: json['isinittime'],
        isfinishtime: json['isfinishtime'],
        code: json['code'],
        isactived: json['isactived'],
        isprogrammed: json['isprogrammed'],
        photodate: json['photodate'],
        savecontact: json['savecontact']
    );
  }
}
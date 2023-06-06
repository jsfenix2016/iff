import 'package:ifeelefine/Model/contactZoneRiskBD.dart';

import '../../Common/utils.dart';

class ZoneRiskApi {
  late int id;
  late String phoneNumber;
  late String photo;
  late String name;
  late String phones;
  late bool sendwhatsapp;
  late bool sendlocation;
  late String code;
  late bool isactived;
  late bool sendwhatsappcontact;
  late bool callme;
  late bool save;

  ZoneRiskApi({
    required this.phoneNumber,
    required this.photo,
    required this.name,
    required this.phones,
    required this.sendwhatsapp,
    required this.sendlocation,
    required this.code,
    required this.isactived,
    required this.sendwhatsappcontact,
    required this.callme,
    required this.save});

  ZoneRiskApi.fromZoneRisk(ContactZoneRiskBD contactZoneRiskBD, this.phoneNumber) {
    photo = contactZoneRiskBD.photo.toString();
    name = contactZoneRiskBD.name;
    phones = contactZoneRiskBD.phones;
    sendwhatsapp = contactZoneRiskBD.sendWhatsapp;
    sendlocation = contactZoneRiskBD.sendLocation;
    code = contactZoneRiskBD.code;
    isactived = contactZoneRiskBD.isActived;
    sendwhatsappcontact = contactZoneRiskBD.sendWhatsappContact;
    callme = contactZoneRiskBD.callme;
    save = contactZoneRiskBD.save;
  }

  ZoneRiskApi.fromApi({
    required this.id,
    required this.phoneNumber,
    required this.photo,
    required this.name,
    required this.phones,
    required this.sendwhatsapp,
    required this.sendlocation,
    required this.code,
    required this.isactived,
    required this.sendwhatsappcontact,
    required this.callme,
    required this.save
  });

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'photo': photo,
    'name': name,
    'phones': phones,
    'sendwhatsapp': sendwhatsapp,
    'sendlocation': sendlocation,
    'code': code,
    'isactived': isactived,
    'sendwhatsappcontact': sendwhatsappcontact,
    'callme': callme,
    'save': save
  };

  factory ZoneRiskApi.fromJson(Map<String, dynamic> json) {
    return ZoneRiskApi.fromApi(
        id: json['id'],
        phoneNumber: json['phoneNumber'],
        photo: json['photo'],
        name: json['name'],
        phones: json['phones'],
        sendwhatsapp: json['sendwhatsapp'],
        sendlocation: json['sendlocation'],
        code: json['code'],
        isactived: json['isactived'],
        sendwhatsappcontact: json['sendwhatsappcontact'],
        callme: json['callme'],
        save: json['save']
    );
  }
}
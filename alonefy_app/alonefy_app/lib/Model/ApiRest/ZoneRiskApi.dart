import 'package:ifeelefine/Model/contactZoneRiskBD.dart';

import '../../Common/utils.dart';

class ZoneRiskApi {
  late int id;
  late String phoneNumber;
  late String photo;
  late String name;
  late String customContactPhoneNumber;
  late bool customContactWhatsappNotification;
  late bool customContactVoiceNotification;
  late bool notifyPredefinedContacts;
  late bool sendlocation;
  late String awsUploadCustomContactPresignedUrl;

  ZoneRiskApi({
    required this.phoneNumber,
    required this.photo,
    required this.name,
    required this.customContactPhoneNumber,
    required this.customContactWhatsappNotification,
    required this.customContactVoiceNotification,
    required this.notifyPredefinedContacts,
    required this.sendlocation,
    required this.awsUploadCustomContactPresignedUrl});

  ZoneRiskApi.fromZoneRisk(ContactZoneRiskBD contactZoneRiskBD, String phoneNumber) {
    this.phoneNumber = phoneNumber.replaceAll("+34", "");
    photo = contactZoneRiskBD.photo.toString();
    name = contactZoneRiskBD.name;
    customContactPhoneNumber = contactZoneRiskBD.phones;
    customContactWhatsappNotification = contactZoneRiskBD.sendWhatsappContact;
    customContactVoiceNotification = contactZoneRiskBD.callme;
    notifyPredefinedContacts = contactZoneRiskBD.sendWhatsapp;
    sendlocation = contactZoneRiskBD.sendLocation;
  }

  ZoneRiskApi.fromApi({
    required this.id,
    required this.phoneNumber,
    required this.photo,
    required this.name,
    required this.customContactPhoneNumber,
    required this.customContactWhatsappNotification,
    required this.customContactVoiceNotification,
    required this.notifyPredefinedContacts,
    required this.sendlocation,
    required this.awsUploadCustomContactPresignedUrl
  });

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'customContactPhoneNumber': customContactPhoneNumber,
    'customContactWhatsappNotification': customContactWhatsappNotification,
    'customContactVoiceNotification': customContactVoiceNotification,
    'notifyPredefinedContacts': notifyPredefinedContacts,
    'sendLocation': sendlocation
  };

  factory ZoneRiskApi.fromJson(Map<String, dynamic> json) {
    return ZoneRiskApi.fromApi(
        id: json['id'],
        phoneNumber: json['phoneNumber'],
        photo: json['photo'] ?? "",
        name: json['name'] ?? "",
        customContactPhoneNumber: json['customContactPhoneNumber'],
        customContactWhatsappNotification: json['customContactWhatsappNotification'],
        customContactVoiceNotification: json['customContactVoiceNotification'],
        notifyPredefinedContacts: json['notifyPredefinedContacts'],
        sendlocation: json['sendLocation'],
        awsUploadCustomContactPresignedUrl: json['awsUploadCustomContactPresignedUrl'] ?? "",
    );
  }
}
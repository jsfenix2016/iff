import 'package:ifeelefine/Model/contactRiskBD.dart';

import '../../Common/utils.dart';

class ContactRiskApi {
  late int id;
  late String phoneNumber;
  late String photo;
  late String name;
  late String titleAlertMessage;
  late String alertMessage;
  late List<String> photoDate;
  late DateTime startDateTime;
  late DateTime endDateTime;
  late String customContactPhoneNumber;
  late bool notifyPredefinedContacts;
  late bool sendLocation;
  late int totalImagesToUpload;
  List<String>? awsUploadPresignedUrls;
  late String awsUploadCustomContactPresignedUrl;

  ContactRiskApi({
      required this.phoneNumber,
      required this.photo,
      required this.name,
      required this.titleAlertMessage,
      required this.alertMessage,
      required this.photoDate,
      required this.startDateTime,
      required this.endDateTime,
      required this.customContactPhoneNumber,
      required this.notifyPredefinedContacts,
      required this.sendLocation});

  ContactRiskApi.fromContact(ContactRiskBD contactRisk, this.phoneNumber, this.totalImagesToUpload) {
    photo = contactRisk.photo.toString();
    name = contactRisk.name;
    titleAlertMessage = contactRisk.titleMessage;
    alertMessage = contactRisk.messages;
    photoDate = [];
    startDateTime = parseDurationRow(contactRisk.timeinit);
    endDateTime = parseDurationRow(contactRisk.timefinish);
    customContactPhoneNumber = contactRisk.phones;
    notifyPredefinedContacts = contactRisk.sendWhatsapp;
    sendLocation = contactRisk.sendLocation;
  }

  ContactRiskApi.fromApi({
    required this.id,
    required this.phoneNumber,
    required this.photo,
    required this.name,
    required this.titleAlertMessage,
    required this.alertMessage,
    required this.photoDate,
    required this.startDateTime,
    required this.endDateTime,
    required this.customContactPhoneNumber,
    required this.notifyPredefinedContacts,
    required this.sendLocation,
    required this.totalImagesToUpload,
    required this.awsUploadCustomContactPresignedUrl,
    required this.awsUploadPresignedUrls});

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    //'photo': photo,
    //'name': name,
    //'titleAlertMessage': titleAlertMessage,
    //'alertMessage': alertMessage,
    //'photoDate': photoDate,
    'startDateTime': startDateTime.toIso8601String(),
    'endDateTime': endDateTime.toIso8601String(),
    //'customContactPhoneNumber': customContactPhoneNumber,
    'notifyPredefinedContacts': notifyPredefinedContacts,
    'sendLocation': sendLocation,
    'totalImagesToUpload': totalImagesToUpload
  };

  factory ContactRiskApi.fromJson(Map<String, dynamic> json) {
    return ContactRiskApi.fromApi(
        id: json['id'],
        phoneNumber: json['phoneNumber'],
        photo: json['photo'] ?? "",
        name: json['name'] ?? "",
        titleAlertMessage: json['titleAlertMessage'] ?? "",
        alertMessage: json['alertMessage'] ?? "",
        photoDate: [],
        startDateTime: jsonToDatetime(json['startDateTime'], getDefaultPattern()),
        endDateTime: jsonToDatetime(json['endDateTime'], getDefaultPattern()),
        customContactPhoneNumber: json['customContactPhoneNumber'] ?? "",
        notifyPredefinedContacts: json['notifyPredefinedContacts'],
        sendLocation: json['sendLocation'],
        totalImagesToUpload: json['totalImagesToUpload'] ?? 0,
        awsUploadPresignedUrls: json['awsUploadPresignedUrls'] != null ? dynamicToStringList(json['awsUploadPresignedUrls']) : [],
        awsUploadCustomContactPresignedUrl: json['awsUploadCustomContactPresignedUrl'] ?? ""
    );
  }
}
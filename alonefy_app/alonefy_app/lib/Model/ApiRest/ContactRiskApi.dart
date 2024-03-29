import 'package:ifeelefine/Model/contactRiskBD.dart';

import '../../Common/utils.dart';

class ContactRiskApi {
  late int id;
  late String phoneNumber;
  late String photo;
  late String name;
  late String titleAlertMessage;
  late String alertMessage;
  late String phones;
  late List<String> photoDate;
  late DateTime startDateTime;
  late DateTime endDateTime;
  late String customContactPhoneNumber;
  late bool notifyPredefinedContacts;
  late bool sendLocation;
  late int totalImagesToUpload;
  List<String>? awsUploadPresignedUrls;
  late String awsUploadCustomContactPresignedUrl;
  List<String>? awsDownloadPresignedUrls;
  late String awsDownloadCustomContactPresignedUrl;
  late bool finished;

  ContactRiskApi(
      {required this.phoneNumber,
      required this.photo,
      required this.name,
      required this.titleAlertMessage,
      required this.alertMessage,
      required this.phones,
      required this.photoDate,
      required this.startDateTime,
      required this.endDateTime,
      required this.customContactPhoneNumber,
      required this.notifyPredefinedContacts,
      required this.sendLocation,
      required this.finished});

  ContactRiskApi.fromContact(
      ContactRiskBD contactRisk, this.phoneNumber, this.totalImagesToUpload) {
    photo = contactRisk.photo.toString();
    name = contactRisk.name;
    titleAlertMessage = contactRisk.titleMessage;
    alertMessage = contactRisk.messages;
    phones = contactRisk.phones.replaceAll(" ", "");
    photoDate = [];
    startDateTime = parseContactRiskDate(contactRisk.timeinit);
    endDateTime = parseContactRiskDate(contactRisk.timefinish);
    customContactPhoneNumber = contactRisk.phones;
    notifyPredefinedContacts = contactRisk.sendWhatsapp;
    sendLocation = contactRisk.sendLocation;
    finished = contactRisk.finish;
  }

  ContactRiskApi.fromApi(
      {required this.id,
      required this.phoneNumber,
      required this.photo,
      required this.name,
      required this.titleAlertMessage,
      required this.alertMessage,
      required this.phones,
      required this.photoDate,
      required this.startDateTime,
      required this.endDateTime,
      required this.customContactPhoneNumber,
      required this.notifyPredefinedContacts,
      required this.sendLocation,
      required this.totalImagesToUpload,
      required this.awsUploadCustomContactPresignedUrl,
      required this.awsUploadPresignedUrls,
      required this.awsDownloadPresignedUrls,
      required this.awsDownloadCustomContactPresignedUrl,
      required this.finished});

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber.replaceAll(" ", ""),
        'phones': phones.replaceAll(" ", ""),
        'name': name,
        'titleAlertMessage': titleAlertMessage,
        'alertMessage': alertMessage,
        //'photoDate': photoDate,
        'startDateTime': startDateTime.toIso8601String(),
        'endDateTime': endDateTime.toIso8601String(),
        'customContactPhoneNumber': customContactPhoneNumber,
        'notifyPredefinedContacts': notifyPredefinedContacts,
        'sendLocation': sendLocation,
        'totalImagesToUpload': totalImagesToUpload,
        'finished': finished,
      };

  factory ContactRiskApi.fromJson(Map<String, dynamic> json) {
    return ContactRiskApi.fromApi(
        id: json['id'],
        phoneNumber: json['phoneNumber'],
        photo: json['photo'] ?? "",
        name: json['name'] ?? "",
        titleAlertMessage: json['titleAlertMessage'] ?? "",
        alertMessage: json['alertMessage'] ?? "",
        phones: json['phones'] ?? "",
        photoDate: [],
        startDateTime:
            jsonToDatetime(json['startDateTime'], getDefaultPattern()),
        endDateTime: jsonToDatetime(json['endDateTime'], getDefaultPattern()),
        customContactPhoneNumber: json['customContactPhoneNumber'] ?? "",
        notifyPredefinedContacts: json['notifyPredefinedContacts'],
        sendLocation: json['sendLocation'],
        totalImagesToUpload: json['totalImagesToUpload'] ?? 0,
        awsUploadPresignedUrls: json['awsUploadPresignedUrls'] != null
            ? dynamicToStringList(json['awsUploadPresignedUrls'])
            : [],
        finished: json['finished'],
        awsUploadCustomContactPresignedUrl:
            json['awsUploadCustomContactPresignedUrl'] ?? "",
        awsDownloadPresignedUrls: json['awsDownloadPresignedUrls'] != null
            ? dynamicToStringList(json['awsDownloadPresignedUrls'])
            : [],
        awsDownloadCustomContactPresignedUrl:
            json['awsDownloadCustomContactPresignedUrl'] ?? "");
  }
}

import 'package:ifeelefine/Model/VideoPresignedUrls.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';

import '../../Common/utils.dart';

class ZoneRiskApi {
  late int id;
  late String phoneNumber;
  // late String photo;
  late String name;
  late String customContactPhoneNumber;
  late bool customContactWhatsappNotification;
  late bool customContactVoiceNotification;
  late bool notifyPredefinedContacts;
  late bool sendlocation;
  late String awsUploadCustomContactPresignedUrl;
  late DateTime createDate;
  late String awsDownloadCustomContactPresignedUrl;
  late List<VideoPresigned> awsDownloadVideoPresignedUrls;

  ZoneRiskApi(
      {required this.phoneNumber,
      // required this.photo,
      required this.name,
      required this.customContactPhoneNumber,
      required this.customContactWhatsappNotification,
      required this.customContactVoiceNotification,
      required this.notifyPredefinedContacts,
      required this.sendlocation,
      required this.awsUploadCustomContactPresignedUrl});

  ZoneRiskApi.fromZoneRisk(
      ContactZoneRiskBD contactZoneRiskBD, String phoneNumber) {
    this.phoneNumber = phoneNumber.contains("+34")
        ? phoneNumber.replaceAll("+34", "").replaceAll(" ", "")
        : phoneNumber.replaceAll(" ", "");
    // photo = contactZoneRiskBD.photo.toString();
    name = contactZoneRiskBD.name;
    customContactPhoneNumber = contactZoneRiskBD.phones;
    customContactWhatsappNotification = contactZoneRiskBD.sendWhatsapp;
    customContactVoiceNotification = contactZoneRiskBD.callme;
    notifyPredefinedContacts = contactZoneRiskBD.sendWhatsappContact;
    sendlocation = contactZoneRiskBD.sendLocation;
  }

  ZoneRiskApi.fromApi(
      {required this.id,
      required this.phoneNumber,
      // required this.photo,
      required this.name,
      required this.customContactPhoneNumber,
      required this.customContactWhatsappNotification,
      required this.customContactVoiceNotification,
      required this.notifyPredefinedContacts,
      required this.sendlocation,
      required this.awsUploadCustomContactPresignedUrl,
      required this.createDate,
      required this.awsDownloadCustomContactPresignedUrl,
      required this.awsDownloadVideoPresignedUrls});

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'name': name,
        // 'photo': photo,
        'customContactPhoneNumber': customContactPhoneNumber,
        'customContactWhatsappNotification': customContactWhatsappNotification,
        'customContactVoiceNotification': customContactVoiceNotification,
        'notifyPredefinedContacts': notifyPredefinedContacts,
        'sendLocation': sendlocation
      };

  factory ZoneRiskApi.fromJson(Map<String, dynamic> json) {
    print(json);
    List<VideoPresigned> asw = [];

    if (json.length == 11) {
      if (json.containsKey('awsDownloadVideoPresignedUrls')) {
        var awsUrls = json['awsDownloadVideoPresignedUrls'];
        if (awsUrls is List) {
// Luego, puedes usar esta función para convertir la lista de objetos JSON a una lista de VideoPresigned:
          asw = parseVideoPresignedList(awsUrls);
        }
      }
    }

    var id = json['id'];
    var phoneNumber = json['phoneNumber'] ?? "";
    // photo: json['photo'] ?? "",
    var name = json['name'] ?? "";
    var customContactPhoneNumber = json['customContactPhoneNumber'];
    var customContactWhatsappNotification =
        json['customContactWhatsappNotification'] ?? false;
    var customContactVoiceNotification =
        json['customContactVoiceNotification'] ?? false;
    var notifyPredefinedContacts = json['notifyPredefinedContacts'] ?? false;
    var sendlocation = json['sendLocation'] ?? false;
    var awsUploadCustomContactPresignedUrl =
        json['awsUploadCustomContactPresignedUrl'] ?? "";
    var createDate = jsonToDatetime(json['created'], getDefaultPattern());
    var awsDownloadCustomContactPresignedUrl =
        json['awsDownloadCustomContactPresignedUrl'] ?? "";

    var zone = ZoneRiskApi.fromApi(
      id: id,
      phoneNumber: phoneNumber,
      // photo: json['photo'] ?? "",
      name: name,
      customContactPhoneNumber: customContactPhoneNumber,
      customContactWhatsappNotification: customContactWhatsappNotification,
      customContactVoiceNotification: customContactVoiceNotification,
      notifyPredefinedContacts: notifyPredefinedContacts,
      sendlocation: sendlocation,
      awsUploadCustomContactPresignedUrl: awsUploadCustomContactPresignedUrl,
      createDate: createDate,
      awsDownloadCustomContactPresignedUrl:
          awsDownloadCustomContactPresignedUrl,
      awsDownloadVideoPresignedUrls: asw,
    );
    return zone;
  }
}

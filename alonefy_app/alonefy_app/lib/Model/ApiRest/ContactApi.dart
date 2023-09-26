import 'package:ifeelefine/Model/contact.dart';

import '../../Common/utils.dart';

class ContactApi {
  late String userPhoneNumber;
  late String phoneNumber;
  late String name;
  late String displayName;
  late int timeSendSms;
  late int timeCall;
  late int timeWhatsapp;
  late String photo;
  late String status;

  ContactApi(
      {required this.userPhoneNumber,
      required this.phoneNumber,
      required this.name,
      required this.displayName,
      required this.timeSendSms,
      required this.timeCall,
      required this.timeWhatsapp,
      required this.photo,
      required this.status});

  ContactApi.fromContact(ContactBD contact, String userPhoneNumber) {
    this.userPhoneNumber = userPhoneNumber.contains("+34")
        ? userPhoneNumber.replaceAll("+34", "").replaceAll(" ", "")
        : userPhoneNumber.replaceAll(" ", "");
    this.phoneNumber = contact.phones.contains("+34")
        ? contact.phones.replaceAll("+34", "").replaceAll(" ", "")
        : contact.phones.replaceAll(" ", "");
    this.name = contact.name;
    this.displayName = contact.displayName;
    this.timeSendSms = stringTimeToInt(contact.timeSendSMS);
    this.timeCall = stringTimeToInt(contact.timeCall);
    this.timeWhatsapp = stringTimeToInt(contact.timeWhatsapp);
    status = contact.requestStatus;
  }

  Map<String, dynamic> toJson() => {
        'userPhoneNumber': userPhoneNumber,
        'phoneNumber': phoneNumber,
        'name': name,
        'displayName': displayName,
        'timeSendSms': timeSendSms,
        'timeCall': timeCall,
        'timeWhatsapp': timeWhatsapp,
        'status': status
      };

  factory ContactApi.fromJson(Map<String, dynamic> json) {
    return ContactApi(
        userPhoneNumber: json['userPhoneNumber'],
        phoneNumber: json['phoneNumber'],
        name: json['name'],
        displayName: json['displayName'],
        timeSendSms: json['timeSendSms'],
        timeCall: json['timeCall'],
        timeWhatsapp: json['timeWhatsapp'],
        photo: json["awsDownloadPresignedUrl"] ?? "",
        status: json["status"]);
  }
}

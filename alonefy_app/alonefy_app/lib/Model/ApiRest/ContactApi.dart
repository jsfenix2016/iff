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

  ContactApi({required this.userPhoneNumber, required this.phoneNumber, required this.name,
    required this.displayName, required this.timeSendSms, required this.timeCall,
    required this.timeWhatsapp, required this.photo, required this.status});

  //ContactApi(String userPhoneNumber, String phoneNumber) {
  //  this.userPhoneNumber = userPhoneNumber;
  //}

  ContactApi.fromContact(ContactBD contact, String userPhoneNumber) {
    this.userPhoneNumber = userPhoneNumber.replaceAll("+34", "");
    this.phoneNumber = contact.phones.replaceAll("+34", "");
    this.name = contact.name;
    this.displayName = contact.displayName;
    this.timeSendSms = stringTimeToInt(contact.timeSendSMS);
    this.timeCall = stringTimeToInt(contact.timeCall);
    this.timeWhatsapp = stringTimeToInt(contact.timeWhatsapp);
  }

  Map<String, dynamic> toJson() => {
    'userPhoneNumber': userPhoneNumber,
    'phoneNumber': phoneNumber,
    'name': name,
    'displayName': displayName,
    'timeSendSms': timeSendSms,
    'timeCall': timeCall,
    'timeWhatsapp': timeWhatsapp,
  };

  factory ContactApi.fromJson(Map<String, dynamic> json) {
    return ContactApi(
      userPhoneNumber: "",
      phoneNumber: "",
      name: json['name'],
      displayName: json['displayName'],
      timeSendSms: json['timeSendSms'],
      timeCall: json['timeCall'],
      timeWhatsapp: json['timeWhatsapp'],
      photo: json["photo"] ?? "",
      status: json["status"]
    );
  }
}
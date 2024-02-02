import 'dart:convert';

import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/ApiRest/ContactRiskApi.dart';
import 'package:ifeelefine/Model/ApiRest/UseMobilApi.dart';
import 'package:ifeelefine/Model/ApiRest/UserRestApi.dart';
import 'package:ifeelefine/Model/ApiRest/ZoneRiskApi.dart';
import 'package:ifeelefine/Model/ApiRest/activityDayApiResponse.dart';

import 'AlertApi.dart';
import 'ContactApi.dart';

class UserApi {
  late String phoneNumber;
  late String fcmToken;
  late String idUser;
  late String name;
  late String lastname;
  late String email;
  late String gender;
  late String styleLife;
  late String maritalStatus;
  late int age;
  late String country;
  late String city;
  late bool premium;
  late bool smsCallAccepted;
  late bool activateFalls;
  late bool activateLocation;
  late bool activateNotifications;
  late bool activateCamera;
  late bool activateContacts;
  late bool activateAlarm;
  late int fallTime;
  late DateTime lastMovement;
  late bool currentlyDeactivated;
  late String awsDownloadPresignedUrl;
  late List<ContactApi> contact;
  late List<ContactRiskApi> contactRisk;
  late List<ZoneRiskApi> zoneRisk;
  late List<ActivityDayApiResponse> activities;
  late List<UseMobilApi> inactivityTimes;
  late List<UserRestApi> sleepHours;
  late List<AlertApi> logAlert;

  UserApi(
      {required this.phoneNumber,
      required this.fcmToken,
      required this.idUser,
      required this.name,
      required this.lastname,
      required this.email,
      required this.gender,
      required this.maritalStatus,
      required this.age,
      required this.styleLife,
      required this.country,
      required this.city,
      required this.premium,
      required this.smsCallAccepted,
      required this.activateFalls,
      required this.activateLocation,
      required this.activateNotifications,
      required this.activateCamera,
      required this.activateContacts,
      required this.activateAlarm,
      required this.fallTime,
      required this.lastMovement,
      required this.currentlyDeactivated,
      required this.awsDownloadPresignedUrl,
      required this.contact,
      required this.contactRisk,
      required this.zoneRisk,
      required this.activities,
      required this.inactivityTimes,
      required this.sleepHours,
      required this.logAlert});

  UserApi.id(this.idUser);

  factory UserApi.fromJson(Map<String, dynamic> json) {
    return UserApi(
        phoneNumber: json['phoneNumber'],
        fcmToken: json['fcmToken'],
        idUser: json['idUser'] ?? "",
        name: json['name'] ?? "",
        lastname: json['lastname'] ?? "",
        email: json['email'],
        gender: json['gender'] ?? "",
        maritalStatus: json['maritalStatus'] ?? "",
        age: json['age'] ?? 0,
        styleLife: json['styleLife'] ?? "",
        country: json['country'] ?? "",
        city: json['city'] ?? "",
        premium: json['premium'] ?? false,
        smsCallAccepted: json['smsCallAccepted'] ?? false,
        activateFalls: json['activateFalls'] ?? false,
        activateLocation: json['activateLocation'] ?? false,
        activateNotifications: json['activateNotifications'] ?? false,
        activateCamera: json['activateCamera'] ?? false,
        activateContacts: json['activateContacts'] ?? false,
        activateAlarm: json['activateAlarm'] ?? false,
        fallTime: json['fallTime'] ?? 5,
        lastMovement: json['lastMovement'] != null
            ? jsonToDatetime(json['lastMovement'], getDefaultPattern())
            : DateTime.now(),
        currentlyDeactivated: json['currentlyDeactivated'] ?? false,
        awsDownloadPresignedUrl: json['awsDownloadPresignedUrl'],
        contact: jsonToGenericList<ContactApi>(json, "contact"),
        contactRisk: jsonToGenericList<ContactRiskApi>(json, "contactRisk"),
        zoneRisk: jsonToGenericList<ZoneRiskApi>(json, "zoneRisk"),
        activities:
            jsonToGenericList<ActivityDayApiResponse>(json, "activities"),
        inactivityTimes:
            jsonToGenericList<UseMobilApi>(json, "inactivityTimes"),
        sleepHours: jsonToGenericList<UserRestApi>(json, "sleepHours"),
        logAlert: jsonToGenericList<AlertApi>(json, "logAlert"));
  }
}

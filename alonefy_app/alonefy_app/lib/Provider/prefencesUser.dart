import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUser {
  static final PreferenceUser _instance = PreferenceUser._internal();
  factory PreferenceUser() {
    return _instance;
  }
  PreferenceUser._internal();
  // ignore: prefer_typing_uninitialized_variables
  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  get onBoarding {
    return _prefs.getBool('onboard') ?? false;
  }

  set onboarding(bool value) {
    _prefs.setBool('onboard', value);
  }

  get isFirstConfig {
    return _prefs.getBool('firstConfig') ?? false;
  }

  set firstConfig(bool value) {
    _prefs.setBool('firstConfig', value);
  }

  get isConfig {
    return _prefs.getBool('isConfig') ?? false;
  }

  set config(bool value) {
    _prefs.setBool('isConfig', value);
  }

  get getTimeUse {
    return _prefs.getBool('timeUse') ?? false;
  }

  set setTimeUse(bool value) {
    _prefs.setBool('timeUse', value);
  }

  get isNotConfigUser {
    return _prefs.getBool('notConfig') ?? false;
  }

  set notConfigUser(bool value) {
    _prefs.setBool('notConfig', value);
  }

  get getUseMobil {
    return _prefs.getString('useMobil') ?? "5 min";
  }

  set setUseMobil(String value) {
    _prefs.setString('useMobil', value);
  }

  get getEmailTime {
    return _prefs.getString('EmailTime') ?? "10 min";
  }

  set setEmailTime(String value) {
    _prefs.setString('EmailTime', value);
  }

  get getSMSTime {
    return _prefs.getString('SMSTime') ?? "10 min";
  }

  set setSMSTime(String value) {
    _prefs.setString('SMSTime', value);
  }

  get getPhoneTime {
    return _prefs.getString('PhoneTime') ?? "15 min";
  }

  set setPhoneTime(String value) {
    _prefs.setString('PhoneTime', value);
  }

  get getAceptedTerms {
    return _prefs.getBool('aceptedTerms') ?? false;
  }

  set setAceptedTerms(bool value) {
    _prefs.setBool('aceptedTerms', value);
  }

  get getAceptedSendSMS {
    return _prefs.getBool('AceptedSendSMS') ?? false;
  }

  set setAceptedSendSMS(bool value) {
    _prefs.setBool('AceptedSendSMS', value);
  }

  get getAceptedSendLocation {
    return _prefs.getBool('AceptedSendLocation') ?? false;
  }

  set setAceptedSendLocation(bool value) {
    _prefs.setBool('AceptedSendLocation', value);
  }

  get getAcceptedSendLocation {
    return PreferencePermission
        .values[_prefs.getInt('AcceptedSendLocation') ?? 0];
  }

  set setAcceptedSendLocation(PreferencePermission permission) {
    _prefs.setInt('AcceptedSendLocation', permission.index);
  }

  get getAcceptedCamera {
    return PreferencePermission.values[_prefs.getInt('AcceptedCamera') ?? 0];
  }

  set setAcceptedCamera(PreferencePermission permission) {
    _prefs.setInt('AcceptedCamera', permission.index);
  }

  get getAcceptedContacts {
    return PreferencePermission.values[_prefs.getInt('AcceptedContacts') ?? 0];
  }

  set setAcceptedContacts(PreferencePermission permission) {
    _prefs.setInt('AcceptedContacts', permission.index);
  }

  get getAcceptedNotification {
    return PreferencePermission
        .values[_prefs.getInt('AcceptedNotification') ?? 0];
  }

  set setAcceptedNotification(PreferencePermission permission) {
    _prefs.setInt('AcceptedNotification', permission.index);
  }

  get getAcceptedScheduleExactAlarm {
    return PreferencePermission
        .values[_prefs.getInt('AcceptedScheduleExactAlarm') ?? 0];
  }

  set setAcceptedScheduleExactAlarm(PreferencePermission permission) {
    _prefs.setInt('AcceptedScheduleExactAlarm', permission.index);
  }

  get getDetectedFall {
    return _prefs.getBool('DetectedFall') ?? false;
  }

  set setDetectedFall(bool value) {
    _prefs.setBool('DetectedFall', value);
  }

  get getFallTime {
    return _prefs.getString('FallTime') ?? "5 min";
  }

  set setFallTime(String value) {
    _prefs.setString('FallTime', value);
  }

  get getUserPremium {
    return _prefs.getBool('userPremium') ?? false;
  }

  set setUserPremium(bool value) {
    _prefs.setBool('userPremium', value);
  }

  get getUserNotification {
    return _prefs.getBool('UserNotification') ?? false;
  }

  set setUserNotification(bool value) {
    _prefs.setBool('UserNotification', value);
  }

  get getDisambleIFF {
    return _prefs.getString('DisambleIFF') ?? "";
  }

  set setDisambleIFF(String value) {
    _prefs.setString('DisambleIFF', value);
  }

  get getEnableIFF {
    return _prefs.getBool('EnableIFF') ?? true;
  }

  set setEnableIFF(bool value) {
    _prefs.setBool('EnableIFF', value);
  }

  set setDisambleIFFForActivity(int value) {
    _prefs.setInt('DisambleForActivity', value);
  }

  get getDisambleIFFForActivity {
    return _prefs.getInt('DisambleForActivity') ?? 5;
  }

  set setNotificationAudio(String audioPath) {
    _prefs.setString('NotificationAudio', audioPath);
  }

  get getNotificationAudio {
    return _prefs.getString('NotificationAudio') ?? '';
  }
}

enum PreferencePermission { init, denied, deniedForever, allow, noAccepted }

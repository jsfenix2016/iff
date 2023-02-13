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
    return _prefs.getBool('onboar') ?? false;
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

  get getDetectedFall {
    return _prefs.getBool('DetectedFall') ?? false;
  }

  set setDetectedFall(bool value) {
    _prefs.setBool('DetectedFall', value);
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
}

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

  refreshData() {
    _prefs.reload();
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

  get isNotConfigUser {
    return _prefs.getBool('notConfig') ?? false;
  }

  set notConfigUser(bool value) {
    _prefs.setBool('notConfig', value);
  }

  get getProtected {
    return _prefs.getString('protected') ?? "";
  }

  set setProtected(String value) {
    _prefs.setString('protected', value);
  }

  get getHabitsTime {
    return _prefs.getString('habitsTime') ?? "";
  }

  set setHabitsTime(String value) {
    _prefs.setString('habitsTime', value);
  }

  get getHabitsEnable {
    return _prefs.getBool('habitsEnable') ?? false;
  }

  set setHabitsEnable(bool enable) {
    _prefs.setBool('habitsEnable', enable);
  }

  get getHabitsRefresh {
    return _prefs.getString('habitsRefresh') ?? "";
  }

  set setHabitsRefresh(String datetime) {
    _prefs.setString('habitsRefresh', datetime);
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
    return _prefs.getString('PhoneTime') ?? "10 min";
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

  get getUseMobilConfig {
    return _prefs.getBool('UseMobilConfig') ?? false;
  }

  set setUseMobilConfig(bool value) {
    _prefs.setBool('UseMobilConfig', value);
  }

  get getUserPremium {
    return _prefs.getBool('userPremium') ?? false;
  }

  get getUserFree {
    return _prefs.getBool('userFree') ?? true;
  }

  get getDayFree {
    return _prefs.getString('DayFree') ?? "0";
  }

  set setUsedFreeDays(bool value) {
    _prefs.setBool('UsedFreeDays', value);
  }

  get getUsedFreeDays {
    return _prefs.getBool('UsedFreeDays') ?? false;
  }

  set setDayFree(String value) {
    _prefs.setString('DayFree', value);
  }

  set setUserFree(bool value) {
    _prefs.setBool('userFree', value);
  }

  set setUserPremium(bool value) {
    _prefs.setBool('userPremium', value);
  }

  get getDemoActive {
    return _prefs.getBool('demo') ?? false;
  }

  set setDemoActive(bool value) {
    _prefs.setBool('demo', value);
  }

  get getPremiumPrice {
    return _prefs.getString('premiumPrice') ?? "4.99€/mes";
  }

  set setPremiumPrice(String price) {
    _prefs.setString('premiumPrice', price);
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

  get getStartDateTimeDisambleIFF {
    return _prefs.getString('StartDateTimeDisambleIFF') ?? "";
  }

  set setStartDateTimeDisambleIFF(String value) {
    _prefs.setString('StartDateTimeDisambleIFF', value);
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

  Future<void> saveLastScreenRoute(String routeName) async {
    await _prefs.setString('lastScreenRoute', routeName);
  }

  Future<String?> getLastScreenRoute() async {
    return _prefs.getString('lastScreenRoute');
  }

  set setIdTokenEmail(String id) {
    _prefs.setString('IdTokenEmail', id);
  }

  get geIdTokenEmail {
    return _prefs.getString('IdTokenEmail') ?? '';
  }

  set setHrefSMS(String id) {
    _prefs.setString('HrefSMS', id);
  }

  get getHrefSMS {
    return _prefs.getString('HrefSMS') ?? '';
  }

  set setHrefMail(String id) {
    _prefs.setString('HrefMail', id);
  }

  get getHrefMail {
    return _prefs.getString('HrefMail') ?? '';
  }

  get getNameZone {
    return _prefs.getString('NameZone') ?? "Europe/Madrid";
  }

  set setNameZone(String name) {
    _prefs.setString('NameZone', name);
  }

  void resetToDefault() {
    onboarding = false;
    firstConfig = false;
    config = false;
    notConfigUser = false;
    setHabitsTime = '';
    setHabitsEnable = false;
    setHabitsRefresh = '';
    setEmailTime = '10 min';
    setSMSTime = '10 min';
    setPhoneTime = '10 min';
    setAceptedTerms = false;
    setAceptedSendSMS = false;
    setAcceptedSendLocation = PreferencePermission.values[0];
    setAcceptedCamera = PreferencePermission.values[0];
    setAcceptedContacts = PreferencePermission.values[0];
    setAcceptedNotification = PreferencePermission.values[0];
    setAcceptedScheduleExactAlarm = PreferencePermission.values[0];
    setDetectedFall = false;
    setFallTime = '5 min';
    setUserPremium = false;
    setDemoActive = false;
    setPremiumPrice = '4.99€/mes';
    setUserNotification = false;
    setDisambleIFF = '';
    setEnableIFF = true;
    setStartDateTimeDisambleIFF = '';
    setDisambleIFFForActivity = 5;
    setNotificationAudio = '';
    // Restablecer otras variables según sea necesario
  }
}

enum PreferencePermission { init, denied, deniedForever, allow, noAccepted }

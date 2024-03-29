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

  get getlistConfigPage {
    return _prefs.getStringList('listConfigPage') ?? [];
  }

  set setlistConfigPage(List<String> value) {
    _prefs.setStringList('listConfigPage', value);
  }

  get getTimerCancelZone {
    return _prefs.getInt('timerCancelZone') ?? 30;
  }

  set setTimerCancelZone(int value) {
    _prefs.setInt('timerCancelZone', value);
  }

  get getlistTaskIdsCancel {
    return _prefs.getStringList('listTaskIdsCancel') ?? [""];
  }

  set setlistTaskIdsCancel(List<String> value) {
    _prefs.setStringList('listTaskIdsCancel', value);
  }

  get getIsSelectContactRisk {
    return _prefs.getInt('idContactRisk') ?? -1;
  }

  set setSelectContactRisk(int value) {
    _prefs.setInt('idContactRisk', value);
  }

  get onBoarding {
    return _prefs.getBool('onboard') ?? false;
  }

  set onboarding(bool value) {
    _prefs.setBool('onboard', value);
  }

  get getListDate {
    return _prefs.getBool('listDate') ?? false;
  }

  set setListDate(bool value) {
    _prefs.setBool('listDate', value);
  }

  get getCancelDate {
    return _prefs.getBool('cancelDate') ?? false;
  }

  set setCancelDate(bool value) {
    _prefs.setBool('cancelDate', value);
  }

  get getAlertPointRed {
    return _prefs.getBool('AlertPoinRed') ?? false;
  }

  set setAlertPointRed(bool value) {
    _prefs.setBool('AlertPoinRed', value);
  }

  get getNotificationId {
    return _prefs.getInt('NotificationId') ?? -1;
  }

  set setNotificationId(int value) {
    _prefs.setInt('NotificationId', value);
  }

  get getNotificationType {
    return _prefs.getString('NotificationType') ?? '';
  }

  set setNotificationType(String value) {
    _prefs.setString('NotificationType', value);
  }

  get getCancelIdDate {
    return _prefs.getInt('cancelIdDate') ?? -1;
  }

  set setCancelIdDate(int value) {
    _prefs.setInt('cancelIdDate', value);
  }

  get getFinishIdDate {
    return _prefs.getBool('FinishIdDate') ?? false;
  }

  set setFinishIdDate(bool value) {
    _prefs.setBool('FinishIdDate', value);
  }

  get getCancelIdDateTemp {
    return _prefs.getInt('cancelIdDateTemp') ?? -1;
  }

  set setCancelIdDateTemp(int value) {
    _prefs.setInt('cancelIdDateTemp', value);
  }

  get getIdDateGroup {
    return _prefs.getString('IdDateGroup') ?? '-1';
  }

  set setIdDateGroup(String value) {
    _prefs.setString('IdDateGroup', value);
  }

  get getIdZoneGroup {
    return _prefs.getString('IdZoneGroup') ?? '-1';
  }

  set setIdZoneGroup(String value) {
    _prefs.setString('IdZoneGroup', value);
  }

  get getIdInactiveGroup {
    return _prefs.getString('IdInactiveGroup') ?? '-1';
  }

  set setIdInactiveGroup(String value) {
    _prefs.setString('IdInactiveGroup', value);
  }

  get getIdDropGroup {
    return _prefs.getString('IdDropGroup') ?? '-1';
  }

  set setIdDropGroup(String value) {
    _prefs.setString('IdDropGroup', value);
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

  get getContactEnabled {
    return _prefs.getBool('ContactEnabled') ?? false;
  }

  set setContactEnabled(bool value) {
    _prefs.setBool('ContactEnabled', value);
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

  get getOpenGalery {
    return _prefs.getBool('OpenGalery') ?? false;
  }

  set setOpenGalery(bool value) {
    _prefs.setBool('OpenGalery', value);
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

  get getDisambleTimeIFF {
    return _prefs.getString('DisambleTimeIFF') ?? "";
  }

  set setDisambleTimeIFF(String value) {
    _prefs.setString('DisambleTimeIFF', value);
  }

  get getEnableIFF {
    return _prefs.getBool('EnableIFF') ?? true;
  }

  set setEnableIFF(bool value) {
    _prefs.setBool('EnableIFF', value);
  }

  get getEnableTimer {
    return _prefs.getBool('EnableTimer') ?? true;
  }

  set setEnableTimer(bool value) {
    _prefs.setBool('EnableTimer', value);
  }

  get getEnableTimerDrop {
    return _prefs.getBool('EnableTimerDrop') ?? true;
  }

  set setEnableTimerDrop(bool value) {
    _prefs.setBool('EnableTimerDrop', value);
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

  set setCountFinish(bool value) {
    _prefs.setBool('CountFinish', value);
  }

  get getCountFinish {
    return _prefs.getBool('CountFinish') ?? false;
  }

  set setNotificationAudio(String audioPath) {
    _prefs.setString('NotificationAudio', audioPath);
  }

  get getNotificationAudio {
    return _prefs.getString('NotificationAudio') ?? 'notification9158194';
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

  get getNotificationsToSave {
    return _prefs.getStringList('NotificationsToSave') ?? [];
  }

  set setNotificationsToSave(List<String> notifications) {
    _prefs.setStringList('NotificationsToSave', notifications);
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
    setNotificationsToSave = [];
    // Restablecer otras variables según sea necesario
  }
}

enum PreferencePermission { init, denied, deniedForever, allow, noAccepted }

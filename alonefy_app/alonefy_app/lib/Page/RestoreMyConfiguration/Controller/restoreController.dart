import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/Firebase/firebaseManager.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/Contact/Controller/contactUserController.dart';

import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/ApiRest/ContactRiskApi.dart';
import 'package:ifeelefine/Model/ApiRest/UseMobilApi.dart';
import 'package:ifeelefine/Model/ApiRest/ZoneRiskApi.dart';
import 'package:ifeelefine/Model/ApiRest/userApi.dart';
import 'package:ifeelefine/Page/AddActivityPage/Controller/addActivityController.dart';
import 'package:ifeelefine/Page/Alerts/Controller/alertsController.dart';
import 'package:ifeelefine/Page/EditUseMobil/Controller/editUseController.dart';
import 'package:ifeelefine/Page/RestoreMyConfiguration/Service/restoreService.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/EditZoneRisk/Controller/EditZoneController.dart';
import 'package:ifeelefine/Page/UserEdit/Controller/getUserController.dart';
import 'package:ifeelefine/Page/UserEdit/Service/editUserService.dart';
import 'package:ifeelefine/Page/UserRest/Controller/userRestController.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Data/hive_data.dart';
import '../../../Model/ApiRest/AlertApi.dart';
import '../../../Model/ApiRest/ContactApi.dart';
import '../../../Model/ApiRest/UserRestApi.dart';
import '../../../Model/ApiRest/activityDayApiResponse.dart';
import '../../../Utils/MimeType/mime_type.dart';

final _prefs = PreferenceUser();

class RestoreController extends GetxController {
  final RestoreService restServ = Get.put(RestoreService());

  Future<bool> sendData(
      BuildContext context, String number, String email) async {
    final userApi = await restServ.getUser(number);

    FlutterBackgroundService service = FlutterBackgroundService();
    if (userApi != null) {
      var isRunning = await service.isRunning();
      if (isRunning) {
        service.invoke("stopService");
      }
      _saveNotifications(userApi);
      _saveUserFromAPI(userApi);
      _saveTimeUseMobile(userApi.inactivityTimes);
      _saveRestDays(userApi.sleepHours);
      _saveActivities(userApi.activities);
      _saveContacts(userApi.contact);
      _saveContactRisk(userApi.contactRisk);
      _saveContactZoneRisk(userApi.zoneRisk);
      _saveLogAlerts(userApi.logAlert);
      _saveLocation(userApi);
      _saveTermsAndConditions(userApi);
      _saveFall(userApi);

      _saveScheduleExactAlarm(userApi);
      _saveCameraPermission(userApi);

      _saveConfig();
      _prefs.setUserPremium = true;
      _prefs.setUserFree = false;
      Future.sync(
        () => {
          activateService(),
          showSaveAlert(context, Constant.info, Constant.restoredCorrectly.tr)
        },
      );
      return true;
    } else {
      Future.sync(
        () => {
          showSaveAlert(
              context, Constant.info, Constant.errorGenericConextion.tr)
        },
      );

      return false;
    }
  }

  void getContactList(BuildContext context) async {
    if (user != null && user!.idUser != '-1') {
      Future.delayed(const Duration(seconds: 4), () async {
        contactlist = await getContacts(context);
      });
    }
  }

  Future<void> _saveUserFromAPI(UserApi? userApi) async {
    if (userApi != null) {
      var bytes = await GetUserController()
          .getUserImage(userApi.awsDownloadPresignedUrl);

      var pathImage = "";
      if (bytes != null) {
        var mime = lookupMimeType('', headerBytes: bytes);
        var extension = "";
        if (mime != null) {
          extension = extensionFromMime(mime);
        }
        pathImage = await saveImageFromUrl(bytes, 'user_profile.$extension');
      }

      var userBD = GetUserController().userApiToUserBD(userApi, pathImage);
      user = userBD;
      if (userApi.activateContacts ||
          userApi.contact.isNotEmpty ||
          userApi.contactRisk.isNotEmpty) {
        getContactList(RedirectViewNotifier.storedContext!);
      }

      var existsUser = await const HiveData().getuserbd;
      if (existsUser.idUser == "-1") {
        await const HiveData().saveUserBD(userBD);
      } else {
        await const HiveData().updateUser(userBD);
      }

      await EditUserService().updateUser(userBD);

      refreshMenu("config2");
      await onActionSelected("get_apns_token");
      NotificationCenter().notify('getUserData');
    }
  }

  Future<void> _saveTimeUseMobile(List<UseMobilApi> useMobilApiList) async {
    await EditUseMobilController().saveUseMobilFromApi(useMobilApiList);
    if (prefs.getUserPremium) {
      refreshMenu("useMobil");
    }
  }

  Future<void> _saveRestDays(List<UserRestApi> userRestApiList) async {
    await UserRestController().saveFromApi(userRestApiList);
    refreshMenu("restDay");
  }

  Future<void> _saveActivities(
      List<ActivityDayApiResponse> activitiesApi) async {
    await AddActivityController().saveFromApi(activitiesApi);
    if (activitiesApi.isNotEmpty) {
      refreshMenu("previewActivity");
    }
  }

  Future<void> _saveFall(UserApi? userApi) async {
    if (userApi != null) {
      _prefs.setDetectedFall = userApi.activateFalls;
      _prefs.setFallTime = minutesToString(userApi.fallTime);

      if (userApi.activateFalls) {
        refreshMenu("fallActivation");
      }
    }
  }

  void _saveContacts(List<ContactApi> contactsApi) {
    Future.sync(
      () async {
        await ContactUserController().saveFromApi(contactsApi);
        if (contactsApi.isNotEmpty) {
          refreshMenu("addContact");
          // Future.sync(() async {
          //   var contacts =
          //       await PermissionService.requestPermission(Permission.contacts);
          //   if (contacts) {
          //     _prefs.setAcceptedContacts = PreferencePermission.allow;
          //   }
          // });
        }
      },
    );
  }

  void _saveLocation(UserApi? userApi) async {
    if (userApi != null && userApi.activateLocation) {
      Future.delayed(const Duration(seconds: 6), () async {
        var sendLocation = await requestPermission(Permission.location);
        if (sendLocation) {
          _prefs.setAcceptedSendLocation = PreferencePermission.allow;
          refreshMenu("configGeo");
        }
      });

      // _prefs.setAcceptedSendLocation = PreferencePermission.allow;
    }
  }

  Future<void> _saveTermsAndConditions(UserApi? userApi) async {
    if (userApi != null) {
      _prefs.setAceptedTerms = userApi.smsCallAccepted;
      _prefs.setAceptedSendSMS = userApi.smsCallAccepted;
    }
  }

  void _saveCameraPermission(UserApi? userApi) {
    if (userApi != null && userApi.activateCamera) {
      Future.delayed(const Duration(seconds: 8), () async {
        var cameraenabled =
            await PermissionService.requestPermission(Permission.camera);
        if (cameraenabled) {
          _prefs.setAcceptedCamera = PreferencePermission.allow;
        }
      });
    }
  }

  void _saveNotifications(UserApi? userApi) {
    if (userApi != null && userApi.activateNotifications) {
      Future.delayed(const Duration(seconds: 10), () async {
        var notification =
            await PermissionService.requestPermission(Permission.notification);
        if (notification) {
          _prefs.setAcceptedNotification = PreferencePermission.allow;
        }
      });

      updateFirebaseToken();
      _prefs.setAcceptedNotification = userApi.activateNotifications
          ? PreferencePermission.allow
          : PreferencePermission.noAccepted;
      if (_prefs.getAcceptedNotification == PreferencePermission.allow ||
          _prefs.getDetectedFall ||
          _prefs.getAcceptedSendLocation == PreferencePermission.allow) {
        _prefs.setProtected =
            "AlertFriends está activada y estamos comprobando que te encuentres bien";
      }
    }
  }

  Future<void> _saveScheduleExactAlarm(UserApi? userApi) async {
    if (userApi != null && userApi.activateAlarm) {
      Future.delayed(const Duration(seconds: 13), () async {
        var notification = await PermissionService.requestPermission(
            Permission.scheduleExactAlarm);
        if (notification) {
          _prefs.setAcceptedScheduleExactAlarm = PreferencePermission.allow;
        } else {
          _prefs.setAcceptedScheduleExactAlarm =
              PreferencePermission.noAccepted;
        }
      });
    }
  }

  Future<void> _saveContactRisk(List<ContactRiskApi> contactsRiskApi) async {
    if (contactsRiskApi.isEmpty) {
      return;
    }

    EditRiskController().saveFromApi(contactsRiskApi);
  }

  Future<void> _saveContactZoneRisk(
      List<ZoneRiskApi> contactsZoneRiskApi) async {
    if (contactsZoneRiskApi.isEmpty) {
      return;
    }
    prefs.setAcceptedCamera = PreferencePermission.allow;
    await cameraPermissions(
      prefs.getAcceptedCamera,
    );
    EditZoneController().saveFromApi(contactsZoneRiskApi);
  }

  Future<void> _saveLogAlerts(List<AlertApi> alerts) async {
    AlertsController().saveFromApi(alerts);
  }

  void _saveConfig() {
    _prefs.firstConfig = true;
    _prefs.config = true;
    _prefs.setUseMobilConfig = true;
    _prefs.saveLastScreenRoute("home");
  }

  Future deleteAllData() async {
    _deleteUsers();
    _deleteUseMobile();
    _deleteRestDays();
    _deleteActivities();
    _deleteFall();
    _deleteContacts();
    _deleteTermsAndConditions();
    _deleteLocation();
    _deleteLogActivities();
    _deleteLogAlerts();
    _deleteContactZoneRisk();
    _deleteContactRisk();
    _deleteOnboarding();
    _deleteFirstConfig();
    _deleteConfig();
    _deleteHabits();
    _deletePermissions();
    _deletePremium();
    _deleteDesactivateAlertFriend();
    _deleteNotificationAudio();
  }

  void _deleteUsers() async {
    await const HiveData().deleteUsers();
  }

  void _deleteUseMobile() async {
    await const HiveData().deleteAllUseMobil();
  }

  void _deleteRestDays() async {
    await const HiveData().deleteAllRestDays();
  }

  void _deleteActivities() async {
    await const HiveData().deleteAllActivities();
  }

  void _deleteFall() async {
    _prefs.setDetectedFall = false;
    _prefs.setFallTime = "5 min";
  }

  void _deleteContacts() async {
    await const HiveData().deleteAllContacts();

    _prefs.setEmailTime = "10 min";
    _prefs.setSMSTime = "10 min";
    _prefs.setPhoneTime = "15 min";
  }

  void _deleteTermsAndConditions() async {
    _prefs.setAceptedTerms = false;
    _prefs.setAceptedSendSMS = false;
  }

  void _deleteLocation() async {
    _prefs.setAcceptedSendLocation = PreferencePermission.noAccepted;
  }

  void _deleteLogActivities() async {
    await const HiveData().deleteAllLogActivities();
  }

  void _deleteLogAlerts() async {
    await const HiveData().deleteAllAlerts();
  }

  void _deleteContactZoneRisk() async {
    await const HiveDataRisk().deleteAllContactZoneRisk();
  }

  void _deleteContactRisk() async {
    await const HiveDataRisk().deleteAllContactRisk();
  }

  void _deleteOnboarding() async {
    _prefs.onboarding = false;
  }

  void _deleteFirstConfig() async {
    _prefs.firstConfig = false;
  }

  void _deleteConfig() async {
    _prefs.config = false;
  }

  void _deleteHabits() async {
    _prefs.setHabitsTime = "";
    _prefs.setHabitsEnable = false;
    _prefs.setHabitsRefresh = "";
  }

  void _deletePermissions() async {
    _prefs.setAcceptedCamera = PreferencePermission.noAccepted;
    _prefs.setAcceptedContacts = PreferencePermission.noAccepted;
    _prefs.setAcceptedNotification = PreferencePermission.noAccepted;
    _prefs.setAcceptedScheduleExactAlarm = PreferencePermission.noAccepted;
  }

  void _deletePremium() async {
    _prefs.setUserPremium = false;
  }

  void _deleteDesactivateAlertFriend() async {
    _prefs.setDisambleIFF = "";
    _prefs.setEnableIFF = true;
    _prefs.setStartDateTimeDisambleIFF = "";
  }

  void _deleteNotificationAudio() async {
    _prefs.setNotificationAudio = '';
  }
}

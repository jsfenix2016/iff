import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/Firebase/firebaseManager.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
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
import 'package:uuid/uuid.dart';

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

      await RestoreController().deleteAllData();
      mainController.refreshHome();

      _saveUserFromAPI(userApi);
      _saveTimeUseMobile(userApi.inactivityTimes);
      _saveRestDays(userApi.sleepHours);
      _saveActivities(userApi.activities);
      _saveContacts(userApi.contact);
      _saveContactRisk(userApi.contactRisk);
      _saveContactZoneRisk(userApi.zoneRisk);
      _saveLogAlerts(userApi.logAlert);
      _saveTermsAndConditions(userApi);
      _saveFall(userApi);
      await _prefs.initPrefs();
      _prefs.setUserPremium = true;
      _prefs.setUserFree = false;
      Map<String, Permission> permissions = _getActivePermissions(userApi);
      if (permissions.isNotEmpty) {
        await _requestPermissions(permissions, userApi);
      }

      _saveConfig();

      _prefs.setEnableIFF = userApi.currentlyDeactivated;
      _prefs.setDisambleIFF =
          convertDateTimeToDisamble(userApi.deactivatedUntil);
      _prefs.setDisambleTimeIFF = userApi.deactivatedUntil.toString();
      await refreshMenu("useMobil");
      await refreshMenu("restDay");
      await refreshMenu("previewActivity");
      if (_prefs.getAcceptedSendLocation == PreferencePermission.allow) {
        refreshMenu("configGeo");
      }
      Future.sync(
        () => {
          activateService(),
          mainController.refreshHome(),
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

  void getContactList(BuildContext context, UserApi? userApi) async {
    if (user != null && user!.idUser != '-1' && userApi != null) {
      if (userApi.activateContacts ||
          userApi.contact.isNotEmpty ||
          userApi.contactRisk.isNotEmpty) {
        Future.delayed(const Duration(seconds: 4), () async {
          contactlist = await getContactsListWithoutPermission();
        });
      }
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

        var uuid = const Uuid();
        String newUuid = uuid.v4();
        pathImage = await saveImageFromUrl(bytes, 'user_profile_$newUuid.$extension');
      }

      var userBD = GetUserController().userApiToUserBD(userApi, pathImage);
      user = userBD;
      // if (userApi.activateContacts ||
      //     userApi.contact.isNotEmpty ||
      //     userApi.contactRisk.isNotEmpty) {
      //   getContactList(RedirectViewNotifier.storedContext!);
      // }

      var existsUser = await const HiveData().getuserbd;
      if (existsUser.idUser == "-1") {
        await const HiveData().saveUserBD(userBD);
      } else {
        await const HiveData().updateUser(userBD);
      }

      await EditUserService().updateUser(userBD);

      await refreshMenu("config2");
      await onActionSelected("get_apns_token");

      try {
        NotificationCenter().notify('getUserData');
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _saveTimeUseMobile(List<UseMobilApi> useMobilApiList) async {
    await EditUseMobilController().saveUseMobilFromApi(useMobilApiList);
  }

  Future<void> _saveRestDays(List<UserRestApi> userRestApiList) async {
    await UserRestController().saveFromApi(userRestApiList);
  }

  Future<void> _saveActivities(
      List<ActivityDayApiResponse> activitiesApi) async {
    await AddActivityController().saveFromApi(activitiesApi);
    // if (activitiesApi.isNotEmpty) {
    //   await refreshMenu("previewActivity");
    // }
  }

  void _saveFall(UserApi? userApi) {
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
          await refreshMenu("addContact");
        }
      },
    );
  }

  Future<void> _saveTermsAndConditions(UserApi? userApi) async {
    if (userApi != null) {
      _prefs.setAceptedTerms = userApi.smsCallAccepted;
      _prefs.setAceptedSendSMS = userApi.smsCallAccepted;
    }
  }

  void _saveNotifications(PreferencePermission permission) {
    updateFirebaseToken();
    _prefs.setAcceptedNotification = permission;
    if (_prefs.getAcceptedNotification == PreferencePermission.allow ||
        _prefs.getDetectedFall ||
        _prefs.getAcceptedSendLocation == PreferencePermission.allow) {
      _prefs.setProtected =
          "AlertFriends está activada y estamos comprobando que te encuentres bien";
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
    // await cameraPermissions(
    //   prefs.getAcceptedCamera,
    // );
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
    _deleteTermsAndConditions();
    _deleteUsers();
    _deleteAllZoneRisk();
    _deleteAllHistorial();
    _deleteUseMobile();
    _deleteRestDays();
    _deleteActivities();
    _deleteFall();
    _deleteContacts();

    _deleteLocation();
    // _deleteLogActivities();
    // _deleteLogAlerts();
    // _deleteContactZoneRisk();
    // _deleteContactRisk();
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
    _prefs.setlistConfigPage = [];
    _prefs.setAlertPointRed = false;
  }

  void _deleteLocation() async {
    _prefs.setAcceptedSendLocation = PreferencePermission.noAccepted;
  }

  // void _deleteLogActivities() async {
  //   await const HiveData().deleteAllLogActivities();
  // }

  // void _deleteLogAlerts() async {
  //   await const HiveData().deleteAllAlerts();
  // }

  void _deleteAllZoneRisk() async {
    await const HiveDataRisk().deleteAllZoneRisk();
  }

  // void _deleteContactZoneRisk() async {
  //   await const HiveDataRisk().deleteAllContactZoneRisk();
  // }

  // void _deleteContactRisk() async {
  //   await const HiveDataRisk().deleteAllContactRisk();
  // }

  void _deleteAllHistorial() async {
    await const HiveData().deleteAll();
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

  Future<void> _requestPermissions(
      Map<String, Permission> permissions, UserApi? userApi) async {
    String premisionError = "";
    try {
      List<Permission> permissionsToRequest = permissions.values.toList();
      await permissionsToRequest.request().then((statuses) {
        for (var item in permissions.entries.toList()) {
          var permissionStatus = statuses[item.value]!;
          premisionError = item.key;
          PreferencePermission preferencePermission =
              !permissionStatus.isPermanentlyDenied &&
                      !permissionStatus.isDenied
                  ? PreferencePermission.allow
                  : (item.key == 'scheduleExactAlarm'
                      ? PreferencePermission.noAccepted
                      : PreferencePermission.denied);

          switch (item.key) {
            case 'camera':
              _prefs.setAcceptedCamera = preferencePermission;
              break;
            case 'notification':
              _saveNotifications(preferencePermission);
              break;
            case 'contacts':
              if (preferencePermission == PreferencePermission.allow) {
                getContactList(RedirectViewNotifier.storedContext!, userApi);
              }
              _prefs.setAcceptedContacts = preferencePermission;
              break;
            case 'location':
              _prefs.setAcceptedSendLocation = preferencePermission;
              break;
            case 'scheduleExactAlarm':
              _prefs.setAcceptedScheduleExactAlarm = preferencePermission;
              break;
          }
        }
      });
    } catch (e) {
      print('error de permisos: $premisionError');
      debugPrint('$e');
    }
  }

  Map<String, Permission> _getActivePermissions(UserApi? userApi) {
    Map<String, Permission> permissions = {};

    if (userApi != null) {
      if (userApi.activateCamera) permissions['camera'] = Permission.camera;
      if (userApi.activateNotifications)
        permissions['notification'] = Permission.notification;
      if (userApi.contact.isNotEmpty)
        permissions['contacts'] = Permission.contacts;
      if (userApi.activateLocation)
        permissions['location'] = Permission.location;
      if (userApi.activateAlarm)
        permissions['scheduleExactAlarm'] = Permission.scheduleExactAlarm;
    }

    return permissions;
  }
}

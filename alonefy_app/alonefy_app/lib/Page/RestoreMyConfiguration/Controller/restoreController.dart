import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Controllers/contactUserController.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/ApiRest/ContactRiskApi.dart';
import 'package:ifeelefine/Model/ApiRest/UseMobilApi.dart';
import 'package:ifeelefine/Model/ApiRest/ZoneRiskApi.dart';
import 'package:ifeelefine/Model/ApiRest/userApi.dart';
import 'package:ifeelefine/Page/AddActivityPage/Controller/addActivityController.dart';
import 'package:ifeelefine/Page/EditUseMobil/Controller/editUseController.dart';
import 'package:ifeelefine/Page/RestoreMyConfiguration/Service/restoreService.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/EditZoneRisk/Controller/EditZoneController.dart';
import 'package:ifeelefine/Page/UserEdit/Controller/getUserController.dart';
import 'package:ifeelefine/Page/UserEdit/Service/editUserService.dart';
import 'package:ifeelefine/Page/UserRest/Controller/userRestController.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import '../../../Data/hive_data.dart';
import '../../../Model/ApiRest/ContactApi.dart';
import '../../../Model/ApiRest/UserRestApi.dart';
import '../../../Model/ApiRest/activityDayApiResponse.dart';

final _prefs = PreferenceUser();

class RestoreController extends GetxController {
  final RestoreService restServ = Get.put(RestoreService());

  Future<void> sendData(
    BuildContext context, String number, String email) async {
    final restoreApi = await restServ.restoreData(number, email);

    if (restoreApi != null) {
      await _saveUserFromAPI(restoreApi.userApi);
      await _saveTimeUseMobile(restoreApi.inactivities);
      await _saveRestDays(restoreApi.restDays);
      await _saveActivities(restoreApi.activities);
      await _saveContacts(restoreApi.contacts);
      await _saveContactRisk(restoreApi.contactsRisk);
      await _saveContactZoneRisk(restoreApi.contactsZoneRisk);
      await _saveLocation(restoreApi.userApi);
      await _saveTermsAndConditions(restoreApi.userApi);
      await _saveFall(restoreApi.userApi);
      showAlert(context, "Se restauro correctamente");
    } else {
      showAlert(context,
          "Se produjo un error, verifique su conexion a internet e intente de nuevo.");
    }
  }

  Future<void> _saveUserFromAPI(UserApi? userApi) async {
    if (userApi != null) {
      var bytes = await GetUserController().getUserImage(userApi.pathImage);

      var pathImage = "";
      if (bytes != null) {
        var imageName = "";
        if (userApi.pathImage.contains('png')) {
          imageName = 'user.png';
        } else {
          imageName = 'user.jpg';
        }
        pathImage = await saveImageFromUrl(bytes, imageName);
      }

      var userBD = GetUserController().userApiToUserBD(userApi, pathImage);

      await const HiveData().saveUserBD(userBD);

      await EditUserService().updateUser(userBD);
    }
  }

  Future<void> _saveTimeUseMobile(List<UseMobilApi> useMobilApiList) async {
    EditUseMobilController().saveUseMobilFromApi(useMobilApiList);
  }

  Future<void> _saveRestDays(List<UserRestApi> userRestApiList) async {
    UserRestController().saveFromApi(userRestApiList);
  }

  Future<void> _saveActivities(List<ActivityDayApiResponse> activitiesApi) async {
    AddActivityController().saveFromApi(activitiesApi);
  }

  Future<void> _saveFall(UserApi? userApi) async {
    if (userApi != null) {
      _prefs.setDetectedFall = userApi.fallAccepted;
      _prefs.setFallTime = minutesToString(userApi.timeFall);
    }
  }

  Future<void> _saveContacts(List<ContactApi> contactsApi) async {
    ContactUserController().saveFromApi(contactsApi);
  }

  Future<void> _saveLocation(UserApi? userApi) async {
    if (userApi != null) {
      _prefs.setAcceptedSendLocation = userApi.locationAccepted
          ? PreferencePermission.allow
          : PreferencePermission.noAccepted;
    }
  }

  Future<void> _saveTermsAndConditions(UserApi? userApi) async {
    if (userApi != null) {
      _prefs.setAceptedTerms = userApi.smsCallAccepted;
      _prefs.setAceptedSendSMS = userApi.smsCallAccepted;
    }
  }

  Future<void> _saveContactRisk(List<ContactRiskApi> contactsRiskApi) async {
    EditRiskController().saveFromApi(contactsRiskApi);
  }

  Future<void> _saveContactZoneRisk(List<ZoneRiskApi> contactsZoneRiskApi) async {
    EditZoneController().saveFromApi(contactsZoneRiskApi);
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
  }

  void _deleteNotificationAudio() async {
    _prefs.setNotificationAudio = '';
  }
}

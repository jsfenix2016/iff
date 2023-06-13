import 'package:get/get.dart';
import 'package:ifeelefine/Model/ApiRest/PermissionApi.dart';
import 'package:ifeelefine/Page/PermissionUser/Service/permission_service.dart';

import '../../../Controllers/mainController.dart';
import '../../../Model/ApiRest/TermsAndConditionsApi.dart';
import '../../../Provider/prefencesUser.dart';
import '../../Geolocator/Controller/configGeolocatorController.dart';
import '../../TermsAndConditions/Service/termsAndConditionsService.dart';

class PermissionController extends GetxController {

  final _prefs = PreferenceUser();
  final _locationController = Get.put(ConfigGeolocatorController());

  Future<bool> savePermissions(List<bool> permissionStatus) async {
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    for (var i=0;i<permissionStatus.length;i++) {
      if (permissionStatus[i]) {
        PreferencePermission preferencePermission;
        preferencePermission = PreferencePermission.allow;

        switch (i) {
          case 0:
            _prefs.setAcceptedNotification = preferencePermission;
            break;
          case 1:
            _prefs.setAcceptedCamera = preferencePermission;
            break;
          case 2:
            _prefs.setAcceptedContacts = preferencePermission;
            break;
          case 3:
            _locationController.activateLocation(preferencePermission);
            //_prefs.setAcceptedSendLocation = preferencePermission;
            break;
          case 4:
            _prefs.setAcceptedScheduleExactAlarm = preferencePermission;
            break;
          case 5:
            _prefs.setAceptedSendSMS = true;
            break;
        }
      } else {
        switch (i) {
          case 0:
            if (_prefs.getAcceptedNotification == PreferencePermission.allow) {
              _prefs.setAcceptedNotification = PreferencePermission.noAccepted;
            }
            break;
          case 1:
            if (_prefs.getAcceptedCamera == PreferencePermission.allow) {
              _prefs.setAcceptedCamera = PreferencePermission.noAccepted;
            }
            break;
          case 2:
            if (_prefs.getAcceptedContacts == PreferencePermission.allow) {
              _prefs.setAcceptedContacts = PreferencePermission.noAccepted;
            }
            break;
          case 3:
            if (_prefs.getAcceptedSendLocation == PreferencePermission.allow) {
              _locationController.activateLocation(PreferencePermission.noAccepted);
              //_prefs.setAcceptedSendLocation = PreferencePermission.noAccepted;
            }
            break;
          case 4:
            if (_prefs.getAcceptedScheduleExactAlarm == PreferencePermission.allow) {
              _prefs.setAcceptedScheduleExactAlarm = PreferencePermission.noAccepted;
            }
            break;
          case 5:
            _prefs.setAceptedSendSMS = false;
            break;
        }
      }

      var termsAndConditionsApi = TermsAndConditionsApi(
          phoneNumber: user.telephone,
          smsCallAccepted: _prefs.getAceptedSendSMS
      );
      await TermsAndConditionsService().saveData(termsAndConditionsApi);

      var permissionApi = PermissionApi(
          phoneNumber: user.telephone,
          activateNotifications: _prefs.getAcceptedNotification == PreferencePermission.allow,
          activateCamera: _prefs.getAcceptedCamera == PreferencePermission.allow,
          activateContacts: _prefs.getAcceptedContacts == PreferencePermission.allow,
          activateAlarm: _prefs.getAcceptedScheduleExactAlarm == PreferencePermission.allow
      );
      await PermissionService().activatePermissions(user.telephone, permissionApi);
    }

    return true;
  }

  Future<void> saveNotification() async {
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    _prefs.setAcceptedNotification = PreferencePermission.allow;

    var permissionApi = PermissionApi(
        phoneNumber: user.telephone.replaceAll("+34", ""),
        activateNotifications: _prefs.getAcceptedNotification == PreferencePermission.allow,
        activateCamera: _prefs.getAcceptedCamera == PreferencePermission.allow,
        activateContacts: _prefs.getAcceptedContacts == PreferencePermission.allow,
        activateAlarm: _prefs.getAcceptedScheduleExactAlarm == PreferencePermission.allow
    );
    await PermissionService().activatePermissions(user.telephone, permissionApi);
  }
}
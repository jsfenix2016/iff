import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/ApiRest/AlertApi.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/historialbd.dart';
import 'package:ifeelefine/Page/Alerts/Service/alerts_service.dart';
import 'package:ifeelefine/Page/Disamble/Controller/disambleController.dart';
import 'package:ifeelefine/Page/Geolocator/Controller/configGeolocatorController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Service/contactRiskService.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Services/mainService.dart';
import 'package:notification_center/notification_center.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../../../../Common/utils.dart';
import '../../../../Controllers/mainController.dart';
import '../../../../Model/ApiRest/ContactRiskApi.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

class EditRiskController extends GetxController {
  Future<void> saveActivityLog(ContactRiskBD contact) async {
    var uuid = Uuid().v4();
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    LogAlertsBD mov = LogAlertsBD(
        id: contact.id,
        type: "Cita",
        time: DateTime.now(),
        photoDate: contact.photoDate,
        groupBy: uuid);
    prefs.setIdDateGroup = uuid;

    var alertApi = await AlertsService()
        .saveAlert(AlertApi.fromAlert(mov, user.telephone));

    if (alertApi != null) {
      mov.id = alertApi.id;
    }
    await const HiveData().saveUserPositionBD(mov);
    HistorialBD hist = HistorialBD(
        id: mov.id,
        type: mov.type,
        time: mov.time,
        photoDate: [],
        groupBy: mov.groupBy);

    const HiveData().saveLogsHistorialBD(hist);
  }

  Future<bool> saveContactRisk(
      BuildContext context, ContactRiskBD contact) async {
    try {
      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      var contactRiskApi = ContactRiskApi.fromContact(
          contact,
          user.telephone.contains("+34")
              ? user.telephone.replaceAll("+34", "")
              : user.telephone,
          contact.photoDate.length);
      var contactRiskApiResponse =
          await ContactRiskService().createContactRisk(contactRiskApi);
      if (contact.photo != null &&
          contactRiskApiResponse != null &&
          contactRiskApiResponse
              .awsUploadCustomContactPresignedUrl.isNotEmpty) {
        await ContactRiskService().updateImage(
            contactRiskApiResponse.awsUploadCustomContactPresignedUrl,
            contact.photo);
      }
      if (contact.photoDate.isNotEmpty &&
          contactRiskApiResponse != null &&
          contactRiskApiResponse.awsUploadPresignedUrls != null &&
          contactRiskApiResponse.awsUploadPresignedUrls!.isNotEmpty) {
        var index = 0;

        for (var url in contactRiskApiResponse.awsUploadPresignedUrls!) {
          print(url);
          await ContactRiskService().updateImage(url, contact.photoDate[index]);
          index++;
        }
      }
      if (contactRiskApiResponse != null) {
        contact.id = contactRiskApiResponse.id;
        final save = await const HiveDataRisk().saveContactRisk(contact);
        if (save) {
          saveActivityLog(contact);
          RiskController? riskVC;
          try {
            riskVC = Get.find<RiskController>();
          } catch (e) {
            // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
            // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
            riskVC = Get.put(RiskController());
          }

// Ahora, puedes utilizar riskVC normalmente sabiendo que está disponible.
          if (riskVC != null) {
            riskVC.update();
            // NotificationCenter().notify('getContactRisk');
          }

          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateContactRisk(ContactRiskBD contact) async {
    try {
      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      var contactRiskApi = await ContactRiskService().updateContactRisk(
          ContactRiskApi.fromContact(
              contact,
              user.telephone.contains('+34')
                  ? user.telephone.replaceAll("+34", "")
                  : user.telephone,
              contact.photoDate.length),
          contact.id);

      if (contact.photoDate.isNotEmpty &&
          contactRiskApi != null &&
          contactRiskApi.awsUploadPresignedUrls != null &&
          contactRiskApi.awsUploadPresignedUrls!.isNotEmpty) {
        var index = 0;
        for (var url in contactRiskApi.awsUploadPresignedUrls!) {
          await ContactRiskService().updateImage(url, contact.photoDate[index]);
          index++;
        }
      }
      print("contact id ${contact.id}");
      var update = await const HiveDataRisk().updateContactRisk(contact);
      if (update.id != -1) {
        PreferenceUser prefs = PreferenceUser();
        await prefs.initPrefs();

        prefs.setCancelIdDate = update.id;

        print("contact id update ${contact.id}");
        await prefs.refreshData();
        RiskController? riskVC;
        try {
          riskVC = Get.find<RiskController>();
        } catch (e) {
          // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
          // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
          riskVC = Get.put(RiskController());
        }

// Ahora, puedes utilizar riskVC normalmente sabiendo que está disponible.
        if (riskVC != null) {
          riskVC.update();
          try {
            NotificationCenter().notify('getContactRisk');
          } catch (e) {
            print(e);
          }
        }

        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<void> updateContactRiskWhenDateStarted(int id) async {
    await inicializeHiveBD();
    var contactRisk = await const HiveDataRisk().getContactRiskBD(id);

    if (contactRisk != null) {
      contactRisk.isActived = true;
      contactRisk.isprogrammed = false;
      contactRisk.isFinishTime = false;
      var contactTemp =
          await const HiveDataRisk().updateContactRisk(contactRisk);

      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      ContactRiskService().updateContactRisk(
          ContactRiskApi.fromContact(
              contactRisk,
              user.telephone.contains('+34')
                  ? user.telephone.replaceAll("+34", "")
                  : user.telephone,
              contactTemp.photoDate.length),
          contactTemp.id);
      RiskController? riskVC;
      try {
        riskVC = Get.find<RiskController>();
      } catch (e) {
        // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
        // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
        riskVC = Get.put(RiskController());
      }

// Ahora, puedes utilizar riskVC normalmente sabiendo que está disponible.
      if (riskVC != null) {
        riskVC.update();
        try {
          NotificationCenter().notify('getContactRisk');
        } catch (e) {
          print(e);
        }
      }
    }
  }

  Future<void> updateContactRiskWhenDateFinished(
      int id, Map<String, dynamic> data) async {
    var contactRisk = await const HiveDataRisk().getContactRiskBD(id);

    if (contactRisk != null) {
      contactRisk.isActived = false;
      contactRisk.isprogrammed = false;
      contactRisk.isFinishTime = true;
      contactRisk.finish = false;
      contactRisk.taskIds = getTaskIdList(data['task_ids'].toString());

      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      ContactRiskService().updateContactRisk(
          ContactRiskApi.fromContact(
              contactRisk,
              user.telephone.contains('+34')
                  ? user.telephone.replaceAll("+34", "")
                  : user.telephone,
              contactRisk.photoDate.length),
          contactRisk.id);
      RiskController? riskVC;
      try {
        riskVC = Get.find<RiskController>();
      } catch (e) {
        // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
        // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
        riskVC = Get.put(RiskController());
      }

// Ahora, puedes utilizar riskVC normalmente sabiendo que está disponible.
      if (riskVC != null) {
        riskVC.update();
        try {
          NotificationCenter().notify('getContactRisk');
        } catch (e) {
          print(e);
        }
      }
    }
  }

  Future<void> saveFromApi(List<ContactRiskApi> contactsRiskApi) async {
    for (var contactRiskApi in contactsRiskApi) {
      var bytes;
      if (contactRiskApi.awsDownloadCustomContactPresignedUrl != null &&
          contactRiskApi.awsDownloadCustomContactPresignedUrl.isNotEmpty) {
        bytes = await ContactRiskService().getContactImage(
            contactRiskApi.awsDownloadCustomContactPresignedUrl);
      }
      List<Uint8List> photoDate = [];
      if (contactRiskApi.awsDownloadPresignedUrls != null &&
          contactRiskApi.awsDownloadPresignedUrls!.isNotEmpty) {
        for (var photo in contactRiskApi.awsDownloadPresignedUrls!) {
          var photoBytes = await ContactRiskService().getContactImage(photo);
          if (photoBytes != null) photoDate.add(photoBytes);
        }
      }
      var contact = ContactRiskBD(
          id: contactRiskApi.id,
          photo: bytes,
          name: contactRiskApi.name,
          timeinit: contactRiskApi.startDateTime.toString().replaceAll("Z", ""),
          timefinish: contactRiskApi.endDateTime.toString().replaceAll("Z", ""),
          phones: contactRiskApi.customContactPhoneNumber,
          titleMessage: contactRiskApi.titleAlertMessage,
          messages: contactRiskApi.alertMessage,
          sendLocation: contactRiskApi.sendLocation,
          sendWhatsapp: contactRiskApi.notifyPredefinedContacts,
          isInitTime: false,
          isFinishTime: false,
          code: "",
          isActived: false,
          isprogrammed: false,
          photoDate: photoDate,
          saveContact: true,
          createDate: DateTime.now(),
          taskIds: [],
          finish: contactRiskApi.finished);
      await const HiveDataRisk().saveContactRisk(contact);
    }
  }

  Future<bool> updateNewContactRisk(
      BuildContext context, ContactRiskBD contact) async {
    try {
      // Map info

      Future.sync(() => ContactRiskService().deleteContactsRisk(contact.id));
      await const HiveDataRisk().deleteDate(contact);
      await saveContactRisk(context, contact);

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteContactRisk(
      BuildContext context, ContactRiskBD contact) async {
    try {
      // Map info
      await const HiveDataRisk().deleteDate(contact);

      await ContactRiskService().deleteContactsRisk(contact.id);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future checkPermission(BuildContext context) async {
    PreferencePermission preferencePermission = PreferencePermission.init;
    LocationPermission permission;
    bool serviceEnabled;
    final _locationController = Get.put(ConfigGeolocatorController());

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever &&
        preferencePermission == PreferencePermission.init) {
    } else {
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        switch (preferencePermission) {
          case PreferencePermission.init:
            _locationController.activateLocation(PreferencePermission.denied);
            //_prefs.setAcceptedSendLocation = PreferencePermission.denied;
            break;
          case PreferencePermission.denied:
            _locationController
                .activateLocation(PreferencePermission.deniedForever);
            //_prefs.setAcceptedSendLocation = PreferencePermission.deniedForever;
            break;
          case PreferencePermission.deniedForever:
            //_prefs.setAcceptedSendLocation = PreferencePermission.deniedForever;
            _locationController
                .activateLocation(PreferencePermission.deniedForever);
            if (permission == LocationPermission.deniedForever) {
              showPermissionDialog(context, Constant.enablePermission);
            }
            break;
          case PreferencePermission.allow:
            //_prefs.setAcceptedSendLocation = PreferencePermission.deniedForever;
            _locationController
                .activateLocation(PreferencePermission.deniedForever);
            break;
          case PreferencePermission.noAccepted:
            //_prefs.setAcceptedSendLocation = PreferencePermission.deniedForever;
            _locationController
                .activateLocation(PreferencePermission.deniedForever);
            break;
        }
      } else {
        //_prefs.setAcceptedSendLocation = PreferencePermission.allow;
        _locationController.activateLocation(PreferencePermission.allow);
      }

      preferencePermission = prefs.getAcceptedSendLocation;
    }
  }
}

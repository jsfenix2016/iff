import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/ApiRest/AlertApi.dart';
import 'package:ifeelefine/Model/historialbd.dart';

import 'package:ifeelefine/Model/logActivityBd.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/Alerts/Controller/alertsController.dart';
import 'package:ifeelefine/Page/Alerts/Service/alerts_service.dart';
import 'package:ifeelefine/Page/Contact/Notice/Controller/contactNoticeController.dart';
import 'package:ifeelefine/Page/Historial/Controller/historial_controller.dart';
import 'package:ifeelefine/Page/HomePage/Controller/homeController.dart';
import 'package:ifeelefine/Page/LogActivity/Controller/logActivity_controller.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/EditZoneRisk/Controller/EditZoneController.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/Controller/listContactZoneController.dart';
import 'package:ifeelefine/Services/mainService.dart';
import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';
import 'package:uuid/uuid.dart';

class MainController extends GetxController {
  final MainService contactServ = Get.put(MainService());
  final LogActivityController logActivityController =
      Get.put(LogActivityController());

  Future<UserBD> getUserData() async {
    UserBD user = await const HiveData().getuserbd;
    // ignore: unnecessary_null_comparison
    if (user != null) {
      return user;
    } else {
      return initUserBD();
    }
  }

  Future<bool> uptadeCOntact(String phoneNumber, String status) async {
    await inicializeHiveBD();

    var contact = await const HiveData().getContactBD(phoneNumber);

    if (contact != null) {
      //ACCEPTED - DENIED
      contactTemp = contact;
      contactTemp!.requestStatus = status;
      var resp = await const HiveData().updateContactBackGround(contactTemp!);
      if (resp != null) {
        contactTemp = resp;
      }

      return true;
    }
    return false;
  }

  Future<bool> getAlertBy(String messaje, DateTime time) async {
    await inicializeHiveBD();
    bool exist = await const HiveData().getExistAlert(messaje, time);

    return exist;
  }

  Future<void> saveUserLog(String messaje, DateTime time, String group) async {
    await inicializeHiveBD();
    LogAlertsBD mov =
        LogAlertsBD(id: -1, type: messaje, time: time, groupBy: group);

    MainController? controller;
    try {
      controller = Get.find<MainController>();
    } catch (e) {
      // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
      // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
      controller = Get.put(MainController());
    }
    if (controller != null) {
      user = await mainController.getUserData();

      var alertApi = await AlertsService()
          .saveAlert(AlertApi.fromAlert(mov, user!.telephone));

      if (alertApi != null) {
        mov.id = alertApi.id;
      }
      const HiveData().saveUserPositionBD(mov);
      HistorialBD hist = HistorialBD(
          id: mov.id, type: mov.type, time: mov.time, groupBy: mov.groupBy);

      const HiveData().saveLogsHistorialBD(hist);
      controller.refreshHome();
    }
  }

  Future<void> saveUserRiskLog(LogAlertsBD alert) async {
    await inicializeHiveBD();

    var user = await getUserData();

    var alertApi = await AlertsService()
        .saveAlert(AlertApi.fromAlert(alert, user.telephone));

    if (alertApi != null) {
      alert.id = alertApi.id;
    }
    const HiveData().saveUserPositionBD(alert);
    HistorialBD hist = HistorialBD(
        id: alert.id,
        type: alert.type,
        time: alert.time,
        groupBy: alert.groupBy);

    const HiveData().saveLogsHistorialBD(hist);
  }

  Future<void> saveActivityLog(
      DateTime dateTime, String movementType, String group) async {
    LogActivityBD activityBD = LogActivityBD(
        time: dateTime, movementType: movementType, groupBy: group);
    timerSendDropNotification.cancel();
    await inicializeHiveBD();

    await logActivityController.saveLogActivity(activityBD);
    await logActivityController.saveLastMovement();

    LogActivityController? controller;
    try {
      controller = Get.find<LogActivityController>();
    } catch (e) {
      // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
      // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
      controller = Get.put(LogActivityController());
    }
    if (controller != null) {
      controller.update();
    }

    print(" ----movimiento normal - timerSendDropNotification.cancel----");
  }

  Future<void> saveDrop() async {
    var duration = Duration(minutes: stringTimeToInt(prefs.getFallTime));
    timerSendDropNotification = Timer(duration, () async {
      await inicializeHiveBD();

      var user = await getUserData();
      print("cancelado el timer");
      MainService().saveDrop(user);
      var newUuid = const Uuid().v4().toString();

      mainController.saveActivityLog(DateTime.now(), "Caida", newUuid);
      timerSendDropNotification.cancel();
    });
  }

  void refreshHome() {
    HomeController? hVC;
    try {
      hVC = Get.find<HomeController>();
    } catch (e) {
      // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
      // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
      hVC = Get.put(HomeController());
    }
    // Ahora, puedes utilizar riskVC normalmente sabiendo que está disponible.
    if (hVC != null) {
      hVC.update();
    } else {
      try {
        NotificationCenter().notify('refreshView');
      } catch (e) {
        print(e);
      }
    }

    refreshContactNotify();
    refreshHistorial();
    refreshRiskList();
    refreshRiskZoneList();
    refreshAlerts();
  }

  void refreshHistorial() {
    HistorialController? hVC;
    try {
      hVC = Get.find<HistorialController>();
    } catch (e) {
      // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
      // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
      hVC = Get.put(HistorialController());
    }
    // Ahora, puedes utilizar riskVC normalmente sabiendo que está disponible.
    if (hVC != null) {
      hVC.update();
    }
  }

  void refreshContactNotify() {
    ContactNoticeController? contactNotiVC;
    try {
      contactNotiVC = Get.find<ContactNoticeController>();
    } catch (e) {
      // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
      // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
      contactNotiVC = Get.put(ContactNoticeController());
    }
    // Ahora, puedes utilizar riskVC normalmente sabiendo que está disponible.
    if (contactNotiVC != null) {
      contactNotiVC.update();
    }
  }

  void refreshAlerts() {
    AlertsController? alertsVC;
    try {
      alertsVC = Get.find<AlertsController>();
    } catch (e) {
      // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
      // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
      alertsVC = Get.put(AlertsController());
    }
    // Ahora, puedes utilizar riskVC normalmente sabiendo que está disponible.
    if (alertsVC != null) {
      alertsVC.update();
    }
  }

  void refreshRiskList() {
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
    }
  }

  void refreshRiskZoneList() {
    ListContactZoneController? riskZoneListVC;
    try {
      riskZoneListVC = Get.find<ListContactZoneController>();
    } catch (e) {
      // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
      // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
      riskZoneListVC = Get.put(ListContactZoneController());
    }

// Ahora, puedes utilizar riskVC normalmente sabiendo que está disponible.
    if (riskZoneListVC != null) {
      riskZoneListVC.update();
      try {
        NotificationCenter().notify('getContactZoneRisk');
      } catch (e) {
        // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
        // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
        print(e);
      }
    }
  }

  void refreshContactList(List<Contact> contacts) {
    contactlist = contacts;
  }


void saveNotificationBackground(String message, DateTime time, String group) async {
    await prefs.refreshData();
    Map<String, dynamic> notification = {
      'message': message,
      'time': time.toIso8601String(),
      'group': group
    };

    String jsonString = jsonEncode(notification);
    final notifications = await prefs.getNotificationsToSave;
    print("saveNotificationBackground notifications BEFORE: ${notifications.toString()}");
    notifications.add(jsonString);
    print("saveNotificationBackground notifications AFTER: ${notifications.toString()}");
    prefs.setNotificationsToSave = notifications;
    await prefs.refreshData();
  }
}

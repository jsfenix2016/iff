import 'dart:async';

import 'package:get/get.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/ApiRest/AlertApi.dart';

import 'package:ifeelefine/Model/logActivityBd.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/Alerts/Controller/alertsController.dart';
import 'package:ifeelefine/Page/Alerts/Service/alerts_service.dart';
import 'package:ifeelefine/Page/Contact/Notice/Controller/contactNoticeController.dart';
import 'package:ifeelefine/Page/Historial/Controller/historial_controller.dart';
import 'package:ifeelefine/Page/HomePage/Controller/homeController.dart';
import 'package:ifeelefine/Page/LogActivity/Controller/logActivity_controller.dart';
import 'package:ifeelefine/Services/mainService.dart';
import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';

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

  Future<void> saveUserLog(String messaje, DateTime time, String group) async {
    await inicializeHiveBD();
    LogAlertsBD mov =
        LogAlertsBD(id: -1, type: messaje, time: time, groupBy: group);

    final MainController mainController = Get.put(MainController());
    user = await mainController.getUserData();

    var alertApi = await AlertsService()
        .saveAlert(AlertApi.fromAlert(mov, user!.telephone));

    if (alertApi != null) {
      mov.id = alertApi.id;
    }
    const HiveData().saveUserPositionBD(mov);
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
  }

  Future<void> saveActivityLog(
      DateTime dateTime, String movementType, String group) async {
    LogActivityBD activityBD = LogActivityBD(
        time: dateTime, movementType: movementType, groupBy: group);
    timerSendDropNotification.cancel();
    await inicializeHiveBD();

    await logActivityController.saveLogActivity(activityBD);
    await logActivityController.saveLastMovement();
    print(" ----timerSendDropNotification.cancel----");
  }

  Future<void> saveDrop() async {
    var duration = Duration(minutes: stringTimeToInt(prefs.getFallTime));
    print("getFallTime - ${stringTimeToInt(prefs.getFallTime)}");
    timerSendDropNotification = Timer(duration, () async {
      await inicializeHiveBD();

      var user = await getUserData();
      print("cancelado el timer");
      MainService().saveDrop(user);
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
      NotificationCenter().notify('refreshView');
    }
    refreshAlerts();
    refreshHistorial();
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
    refreshAlerts();
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
      refreshAlerts();
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
}

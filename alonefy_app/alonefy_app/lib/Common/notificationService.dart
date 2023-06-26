import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/idleLogic.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Controllers/contactUserController.dart';
import 'package:ifeelefine/Controllers/mainController.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/cancelDatePage.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/PageView/riskDatePage.dart';
import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';
import 'package:url_launcher/url_launcher.dart';

class RedirectViewNotifier with ChangeNotifier {
  static BuildContext? context;
  static ContactRiskBD? contactRisk;
  static void setContext(BuildContext context) =>
      RedirectViewNotifier.context = context;

  //static void setContactRisk(ContactRiskBD contactRisk) =>
  //    RedirectViewNotifier.contactRisk = contactRisk;

  /// when app is in the foreground
  static Future<void> onTapNotification(NotificationResponse? response, List<String> taskIds, int id) async {
    if (RedirectViewNotifier.context == null || response?.payload == null)
      return;

    await inicializeHiveBD();

    var contactRisk = await const HiveDataRisk().getContactRiskBD(id);

    Navigator.push(
      RedirectViewNotifier.context!,
      MaterialPageRoute(
        builder: (context) => CancelDatePage(
          contactRisk: contactRisk!, taskIds: taskIds,
        ),
      ),
    );
  }

  static Future<void> manageNotifications(RemoteMessage message) async {
    var data = message.data;

    if (data.containsValue(Constant.inactive) || data.containsValue(Constant.drop)) {
      final mainController = Get.put(MainController());
      if (data.containsValue(Constant.inactive)) {
        mainController.saveUserLog("Inactividad ", DateTime.now());
      } else {
        mainController.saveUserLog("Movimiento rudo", DateTime.now());
        mainController.saveActivityLog(DateTime.now(), "Movimiento rudo");
      }
      showHelpNotification(message);
    } else if (data.containsValue(Constant.startRiskDate) || data.containsValue(Constant.finishRiskDate)) {
      final editRiskController = Get.put(EditRiskController());
      var id = int.parse(data['id']);

      if (data.containsValue(Constant.startRiskDate)) {
        editRiskController.updateContactRiskWhenDateStarted(id);
        showDateNotifications(message);
      } else {
        editRiskController.updateContactRiskWhenDateFinished(id, data);
        showDateFinishNotifications(message, id);
      }
    } else if (data.containsValue(Constant.contactStatusChanged)) {
      final contactUserController = Get.put(ContactUserController());
      String phoneNumber = data["phone_number"];
      String status = data['status'];

      if (status == Constant.contactAccepted) {
        if (phoneNumber.isNotEmpty) {
          contactUserController.updateContactStatus(phoneNumber, Constant.contactAcceptedLabel);
        }
      } else if (status == Constant.contactDenied){
        if (phoneNumber.isNotEmpty) {
          contactUserController.updateContactStatus(phoneNumber, Constant.contactDeniedLabel);
        }
      }
      showContactResponseNotification(message);
    }
  }

  static Future<void> showHelpNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    String? taskIds = message.data['task_ids'];//getTaskIds(message.data);

    taskIds ??= "";

    await flutterLocalNotificationsPlugin.show(
      0,
      notification?.title,
      notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          '0',
          'MY FOREGROUND SERVICE',
          icon: '@mipmap/logo_alertfriends',
          color: ColorPalette.principal,
          importance: Importance.high,
          ongoing: true,
          enableLights: true,
          playSound: true,
          enableVibration: true,
          channelShowBadge: false,
          priority: Priority.high,

          largeIcon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
          // sound: RawResourceAndroidNotificationSound(
          //     "content://media/internal/audio/media/26.wav"),
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              "helpID_$taskIds",
              "AYUDA",
              icon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
              showsUserInterface: true,
              cancelNotification: true,
            ),
            AndroidNotificationAction(
              "imgoodId_$taskIds",
              "ESTOY BIEN",
              icon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        ),
      ),
      payload: 'Inactived_$taskIds',
    );
  }

  static Future<void> showSendToContactNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    await flutterLocalNotificationsPlugin.show(
      20,
      notification?.title,
      notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '20',
          'MY FOREGROUND SERVICE',
          icon: '@mipmap/logo_alertfriends',
          color: ColorPalette.principal,
          importance: Importance.high,
          ongoing: false,
          enableLights: true,
          playSound: true,
          enableVibration: true,
          channelShowBadge: false,
          priority: Priority.high,
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
          // sound: RawResourceAndroidNotificationSound(
          //     "content://media/internal/audio/media/26.wav"),
        ),
      ),
      payload: 'SMS',
    );
  }

  static Future<void> sendMessageContactDate(ContactRiskBD contact) async {
    Duration useMobil = await IdleLogic().convertStringToDuration("5 min");
    timerSendSMS = Timer(useMobil, () {
      timerActive = false;

      IdleLogic().notifyContactDate(contact);
      if (contact.sendWhatsapp) {
        IdleLogic().notifyContact();
      }
      mainController.saveUserLog("Envio de SMS a contacto cita", now);
    });
  }

  static Future<void> showDateNotifications(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    await flutterLocalNotificationsPlugin.show(
      1,
      notification?.title,
      notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          '1',
          'MY FOREGROUND SERVICE',
          icon: '@mipmap/logo_alertfriends',
          color: ColorPalette.principal,
          importance: Importance.max,
          ongoing: false,
          enableLights: true,
          playSound: true,
          enableVibration: true,
          channelShowBadge: false,
          //groupAlertBehavior: GroupAlertBehavior.children,
          priority: Priority.high,

          largeIcon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
          // sound: RawResourceAndroidNotificationSound(
          //     "content://media/internal/audio/media/26.wav"),
        ),
      ),
      payload: 'DateRisk_',
    );
  }

  static Future<void> showDateFinishNotifications(RemoteMessage message, int id) async {
    RemoteNotification? notification = message.notification;

    String? taskIds = message.data['task_ids'];

    taskIds ??= "";

    await flutterLocalNotificationsPlugin.show(
      2,
      notification?.title,
      notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          '2',
          'MY FOREGROUND SERVICE',
          icon: '@mipmap/logo_alertfriends',
          color: ColorPalette.principal,
          importance: Importance.max,
          ongoing: false,
          enableLights: true,
          playSound: true,
          enableVibration: true,
          channelShowBadge: false,
          // groupAlertBehavior: GroupAlertBehavior.children,
          priority: Priority.high,

          largeIcon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
          // sound: RawResourceAndroidNotificationSound(
          //     "content://media/internal/audio/media/26.wav"),
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              "dateHelp_$taskIds",
              "AYUDA",
              icon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
              showsUserInterface: true,
              cancelNotification: true,
            ),
            AndroidNotificationAction(
              "dateImgood_${taskIds}id=$id",
              "CANCELAR CITA",
              icon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        ),
      ),
      payload: 'DateRisk_${taskIds}id=$id',
    );
  }

  static Future<void> showContactResponseNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    await flutterLocalNotificationsPlugin.show(
      10,
      notification?.title,
      notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '20',
          'MY FOREGROUND SERVICE',
          icon: '@mipmap/logo_alertfriends',
          color: ColorPalette.principal,
          importance: Importance.high,
          ongoing: false,
          enableLights: true,
          playSound: true,
          enableVibration: true,
          channelShowBadge: false,
          priority: Priority.high,
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
          // sound: RawResourceAndroidNotificationSound(
          //     "content://media/internal/audio/media/26.wav"),
        ),
      ),
      payload: 'ContactResponse',
    );
  }
}

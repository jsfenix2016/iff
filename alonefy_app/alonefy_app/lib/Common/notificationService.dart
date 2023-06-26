import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/idleLogic.dart';
import 'package:ifeelefine/Controllers/contactUserController.dart';
import 'package:ifeelefine/Controllers/mainController.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/cancelDatePage.dart';
import 'package:ifeelefine/main.dart';

class RedirectViewNotifier with ChangeNotifier {
  static BuildContext? context;
  static ContactRiskBD? contactRisk;
  static void setContext(BuildContext context) =>
      RedirectViewNotifier.context = context;

  static void setContactRisk(ContactRiskBD contactRisk) =>
      RedirectViewNotifier.contactRisk = contactRisk;

  /// when app is in the foreground
  static Future<void> onTapNotification(NotificationResponse? response) async {
    if (RedirectViewNotifier.context == null || response?.payload == null)
      return;

    Navigator.push(
      RedirectViewNotifier.context!,
      MaterialPageRoute(
        builder: (context) => CancelDatePage(
          contactRisk: RedirectViewNotifier.contactRisk!,
        ),
      ),
    );
  }

  static Future<void> manageNotifications(RemoteMessage message) async {
    var data = message.data;

    if (data.containsValue(Constant.inactive) ||
        data.containsValue(Constant.drop)) {
      final mainController = Get.put(MainController());
      if (data.containsValue(Constant.inactive)) {
        mainController.saveUserLog("Inactividad ", DateTime.now());
      } else {
        mainController.saveUserLog("Movimiento rudo a ", DateTime.now());
        mainController.saveActivityLog(DateTime.now(), "Movimiento brusco");
      }
      showHelpNotification(message);
    } else if (data.containsValue('SMS') ||
        data.containsValue('Whatsapp') ||
        data.containsValue('Call')) {
      final mainController = Get.put(MainController());
      if (data.containsValue('SMS')) {
        mainController.saveUserLog("Envío de SMS a contacto", now);
      } else if (data.containsValue('Whatsapp')) {
        mainController.saveUserLog("Envío de Whatsapp a contacto", now);
      } else {
        mainController.saveUserLog("Envío de llamada a contacto", now);
        //final call = Uri.parse('tel:+91 9830268966');
        //launchUrl(call);
      }
      showSendToContactNotification(message);
    } else if (data.containsValue('StartDateRisk') ||
        data.containsValue('EndDateRisk')) {
      final editRiskController = Get.put(EditRiskController());
      String phones = data['phones'];

      if (data.containsValue('StartDateRisk')) {
        if (phones.isNotEmpty) {
          editRiskController.updateContactRiskWhenDateStarted(phones);
        }
        showDateNotifications(message);
      } else {
        if (phones.isNotEmpty) {
          editRiskController.updateContactRiskWhenDateFinished(phones);
        }
        showDateFinishNotifications(message);
      }
    } else if (data.containsValue('SMSRisk') ||
        data.containsValue('WhatsappRisk') ||
        data.containsValue('CallRisk')) {
      final mainController = Get.put(MainController());
      if (data.containsValue('SMSRisk')) {
        mainController.saveUserLog("Envío de SMS a contacto cita", now);
      } else if (data.containsValue('WhatsappRisk')) {
        mainController.saveUserLog("Envío de Whatsapp a contacto cita", now);
      } else {
        mainController.saveUserLog("Envío de llamada a contacto cita", now);
        //final call = Uri.parse('tel:+91 9830268966');
        //launchUrl(call);
      }
      showSendToContactNotification(message);
    } else if (data.containsValue('ContactAccepted') ||
        data.containsValue('ContactDenied')) {
      final contactUserController = Get.put(ContactUserController());
      String phones = data["phones"];

      if (data.containsValue('ContactAccepted')) {
        if (phones.isNotEmpty) {
          contactUserController.updateContactStatus(phones, "Accepted");
        }
      } else {
        if (phones.isNotEmpty) {
          contactUserController.updateContactStatus(phones, "Denied");
        }
      }
      showContactResponseNotification(message);
    }
  }

  static Future<void> showHelpNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    String tokenIds = "";

    if (message.data.isNotEmpty && message.data.values.isNotEmpty) {
      for (var tokenId in message.data.values) {
        tokenIds += '$tokenId;';
      }
      if (tokenIds.isNotEmpty) {
        tokenIds = tokenIds.substring(0, tokenIds.length - 1);
      }
    }

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
              "helpID_$tokenIds",
              "AYUDA",
              icon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
              showsUserInterface: true,
              cancelNotification: true,
            ),
            AndroidNotificationAction(
              "imgoodId_$tokenIds",
              "ESTOY BIEN",
              icon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        ),
      ),
      payload: 'Inactived',
    );
  }

  static Future<void> showSendToContactNotification(
      RemoteMessage message) async {
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
      const NotificationDetails(
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
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              "date",
              "Cancelar cita",
              icon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        ),
      ),
      payload: 'DateRisk',
    );
  }

  static Future<void> showDateFinishNotifications(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    await flutterLocalNotificationsPlugin.show(
      2,
      notification?.title,
      notification?.body,
      const NotificationDetails(
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
              "date",
              "Cancelar cita",
              icon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        ),
      ),
      payload: 'DateRisk',
    );
  }

  static Future<void> showContactResponseNotification(
      RemoteMessage message) async {
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

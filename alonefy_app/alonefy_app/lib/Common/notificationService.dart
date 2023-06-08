import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/idleLogic.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/cancelDatePage.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/PageView/riskDatePage.dart';
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

  ///Funcion utilizada para mostrar la notificacion local al usuario luego de pasado un periodo de tiempo de inactividad o por movimiento brusco.
  ///una ves se notifica al usuario se activa otra funcion -> sendMessageContact que se activa un timer a la espera de que el usuario indique
  ///si esta bien o se procede a notificar al contacto antes seleccionado.
  static Future<void> showNotifications() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Alerta',
      '¿Te encuentras bien?',
      const NotificationDetails(
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
              "helpID",
              "ayuda",
              icon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
              showsUserInterface: true,
              cancelNotification: true,
            ),
            AndroidNotificationAction(
              "imgoodId",
              "Estoy bien",
              icon: DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends'),
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        ),
      ),
      payload: 'Inactived',
    );

    sendMessageContact();
  }

  static Future<void> showNotificationsFromFirebase(
      RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    String tokenIds = "dasdasdwecasfa;adafefver";

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

  static Future<void> showDateNotifications() async {
    await flutterLocalNotificationsPlugin.show(
      1,
      'Alerta',
      'Se ha iniciado el horario de cita',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '1',
          'MY FOREGROUND SERVICE',
          icon: '@mipmap/logo_alertfriends',
          color: ColorPalette.principal,
          importance: Importance.max,
          ongoing: true,
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

  static Future<void> showDateFinishNotifications() async {
    await flutterLocalNotificationsPlugin.show(
      2,
      'Alerta',
      'Se ha finalizado el horario de cita',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '2',
          'MY FOREGROUND SERVICE',
          icon: '@mipmap/logo_alertfriends',
          color: ColorPalette.principal,
          importance: Importance.max,
          ongoing: true,
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
}

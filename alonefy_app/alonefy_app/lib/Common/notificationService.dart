// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';

// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:flutter_background_service/flutter_background_service.dart';

// import 'package:flutter_background_service_android/flutter_background_service_android.dart';

// class NotificationService {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future onStart(ServiceInstance service) async {
//     if (service is AndroidServiceInstance) {
//       service.on('setAsForeground').listen((event) {
//         service.setAsForegroundService();
//       });

//       service.on('setAsBackground').listen((event) {
//         service.setAsBackgroundService();
//       });
//     }

//     service.on('stopService').listen((event) {
//       service.stopSelf();
//     });

//     // bring to foreground
//     Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (Platform.isAndroid) {
//         if (service is AndroidServiceInstance) {
//           if (await service.isForegroundService()) {}
//         }
//       }

//       /// you can see this log in logcat
//       print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

//       // test using external plugin
//       final deviceInfo = DeviceInfoPlugin();
//       String? device;
//       if (Platform.isAndroid) {
//         final androidInfo = await deviceInfo.androidInfo;
//         device = androidInfo.model;
//         var id = androidInfo.id;
//       }

//       service.invoke(
//         'update',
//         {
//           "current_date": DateTime.now().toIso8601String(),
//           "device": device,
//         },
//       );
//     });
//   }
// }

import 'dart:async';

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
          'my_foreground',
          'MY FOREGROUND SERVICE',
          icon: 'ic_bg_service_small',
          color: ColorPalette.principal,
          importance: Importance.max,
          ongoing: true,
          enableLights: true,
          playSound: true,
          enableVibration: true,
          channelShowBadge: false,
          groupAlertBehavior: GroupAlertBehavior.children,
          priority: Priority.high,

          largeIcon: DrawableResourceAndroidBitmap('ic_bg_service_small'),
          // sound: RawResourceAndroidNotificationSound(
          //     "content://media/internal/audio/media/26.wav"),
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              "helpID",
              "ayuda",
              icon: DrawableResourceAndroidBitmap('ic_bg_service_small'),
              showsUserInterface: true,
              cancelNotification: true,
            ),
            AndroidNotificationAction(
              "imgoodId",
              "Estoy bien",
              icon: DrawableResourceAndroidBitmap('ic_bg_service_small'),
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        ),
      ),
      payload: 'Inactived',
    );
    DateTime now = DateTime.now();
    saveUserLog("Alerta de inactividad ", now);
    sendMessageContact();
  }

  static Future<void> sendMessageContactDate(ContactRiskBD contact) async {
    Duration useMobil = await IdleLogic().convertStringToDuration("5 min");
    timerSendSMS = Timer(useMobil, () {
      timerActive = false;

      IdleLogic().notifyContactDate(contact);
      if (contact.sendWhatsapp) {
        IdleLogic().notifyContact();
      }
      saveUserLog("Envio de SMS a contacto cita", now);
    });
  }

  static Future<void> showDateNotifications() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Alerta',
      'Se a iniciado el horario de cita',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'my_foreground',
          'MY FOREGROUND SERVICE',
          icon: 'ic_bg_service_small',
          color: ColorPalette.principal,
          importance: Importance.max,
          ongoing: true,
          enableLights: true,
          playSound: true,
          enableVibration: true,
          channelShowBadge: false,
          groupAlertBehavior: GroupAlertBehavior.children,
          priority: Priority.high,

          largeIcon: DrawableResourceAndroidBitmap('ic_bg_service_small'),
          // sound: RawResourceAndroidNotificationSound(
          //     "content://media/internal/audio/media/26.wav"),
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              "date",
              "Cancelar cita",
              icon: DrawableResourceAndroidBitmap('ic_bg_service_small'),
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

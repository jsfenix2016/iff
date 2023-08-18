import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/idleLogic.dart';

import 'package:ifeelefine/Controllers/contactUserController.dart';
import 'package:ifeelefine/Controllers/mainController.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_moths_free.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/cancelDatePage.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/main.dart';

PreferenceUser prefs = PreferenceUser();

class RedirectViewNotifier with ChangeNotifier {
  static BuildContext? context;
  static ContactRiskBD? contactRisk;
  static void setContext(BuildContext context) =>
      RedirectViewNotifier.context = context;

  //static void setContactRisk(ContactRiskBD contactRisk) =>
  //    RedirectViewNotifier.contactRisk = contactRisk;

  /// when app is in the foreground
  static Future<void> onTapNotification(
      NotificationResponse? response, List<String> taskIds, int id) async {
    if (RedirectViewNotifier.context == null || response?.payload == null)
      return;

    await inicializeHiveBD();

    var contactRisk = await const HiveDataRisk().getContactRiskBD(id);

    Navigator.push(
      RedirectViewNotifier.context!,
      MaterialPageRoute(
        builder: (context) => CancelDatePage(
          contactRisk: contactRisk!,
          taskIds: taskIds,
        ),
      ),
    );
  }

  static Future<void> onTapPremiumNotification(
      NotificationResponse? response) async {
    await inicializeHiveBD();
    await Navigator.push(
      RedirectViewNotifier.context!,
      MaterialPageRoute(
        builder: (context) => const PremiumPage(
            isFreeTrial: false,
            img: 'Pantalla5.png',
            title: "Prueba la versión gratuita por 30 días y siente protegido",
            subtitle: ''),
      ),
    ).then((value) {
      if (value != null && value) {
        Navigator.of(context!).pop();
      }
    });
    //
  }

  static Future<void> onTapFreeNotification(
      NotificationResponse? response) async {
    if (RedirectViewNotifier.context == null) return;

    await inicializeHiveBD();
    await Navigator.push(
      RedirectViewNotifier.context!,
      MaterialPageRoute(
        builder: (context) => const PremiumMothFree(
            img: 'Pantalla5.png',
            title: "Prueba la versión gratuita por 30 días y siente protegido",
            subtitle: ''),
      ),
    ).then((value) {
      if (value != null && value) {
        Navigator.of(context!).pop();
      }
    });
    // await flutterLocalNotificationsPlugin.cancel(12,
    //     tag: response!.actionId.toString());
  }

  static Future<void> manageNotifications(RemoteMessage message) async {
    var data = message.data;
    await inicializeHiveBD();
    if (data.containsValue(Constant.inactive) ||
        data.containsValue(Constant.drop)) {
      final mainController = Get.put(MainController());
      if (data.containsValue(Constant.inactive)) {
        mainController.saveUserLog("Inactividad ", DateTime.now());
      } else {
        mainController.saveUserLog("Movimiento rudo", DateTime.now());
        mainController.saveActivityLog(DateTime.now(), "Movimiento rudo");
      }
      showHelpNotification(message);
    } else if (data.containsValue(Constant.startRiskDate) ||
        data.containsValue(Constant.finishRiskDate)) {
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
          contactUserController.updateContactStatus(
              phoneNumber, Constant.contactAcceptedLabel);
        }
      } else if (status == Constant.contactDenied) {
        if (phoneNumber.isNotEmpty) {
          contactUserController.updateContactStatus(
              phoneNumber, Constant.contactDeniedLabel);
        }
      }
      showContactResponseNotification(message);
    }
  }

  static Future<void> showHelpNotification(RemoteMessage message) async {
    /// OPTIONAL, using custom notification channel id

    String? taskIds = message.data['task_ids']; //getTaskIds(message.data);
    String? title = message.data['title'];
    String? body = message.data['body'];
    taskIds ??= "";

    PreferenceUser prefs = PreferenceUser();
    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;

    FlutterLocalNotificationsPlugin notifications =
        FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/logo_alertfriends_v2');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notifications.initialize(initializationSettings);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      sound, // id
      'AlertFriends – PERSONAL PROTECTION', // title
      icon: '@mipmap/logo_alertfriends_v2',
      color: ColorPalette.principal,
      importance: Importance.high,

      priority: Priority.high,
      showWhen: false,
      playSound: true,

      enableLights: true,

      enableVibration: true,
      channelShowBadge: true,
      fullScreenIntent: true,
      audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
      // visibility: NotificationVisibility.public,
      largeIcon:
          const DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends_v2'),
      sound: RawResourceAndroidNotificationSound(sound),

      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          "helpID_$taskIds",
          "AYUDA",
          icon: const DrawableResourceAndroidBitmap(
              '@mipmap/logo_alertfriends_v2'),
          showsUserInterface: true,
          cancelNotification: true,
        ),
        AndroidNotificationAction(
          "imgoodId_$taskIds",
          "ESTOY BIEN",
          icon: const DrawableResourceAndroidBitmap(
              '@mipmap/logo_alertfriends_v2'),
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await notifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Inactived_$taskIds',
    );
  }

  static Future<void> showSendToContactNotification(
      RemoteMessage message) async {
    // RemoteNotification? notification = message.notification;
    String? title = message.data['title'];
    String? body = message.data['body'];
    PreferenceUser prefs = PreferenceUser();
    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;

    FlutterLocalNotificationsPlugin notifications =
        FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/logo_alertfriends_v2');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notifications.initialize(initializationSettings);

    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        sound,
        'SendToContact',
        icon: '@mipmap/logo_alertfriends_v2',
        color: ColorPalette.principal,
        importance: Importance.high,
        enableLights: true,
        playSound: true,
        enableVibration: true,
        channelShowBadge: false,
        priority: Priority.high,
        largeIcon:
            const DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends_v2'),
        sound: RawResourceAndroidNotificationSound(sound),
      ),
    );

    await notifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
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
    // RemoteNotification? notification = message.notification;
    String? title = message.data['title'];
    String? body = message.data['body'];
    PreferenceUser prefs = PreferenceUser();
    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;

    FlutterLocalNotificationsPlugin notifications =
        FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/logo_alertfriends_v2');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notifications.initialize(initializationSettings);

    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        sound,
        'DateNotifications',
        icon: '@mipmap/logo_alertfriends_v2',
        color: ColorPalette.principal,
        importance: Importance.max,
        fullScreenIntent: true,
        audioAttributesUsage: AudioAttributesUsage.notificationRingtone,

        enableLights: true,
        playSound: true,
        enableVibration: true,
        channelShowBadge: false,
        visibility: NotificationVisibility.public,
        //groupAlertBehavior: GroupAlertBehavior.children,
        priority: Priority.high,

        largeIcon:
            const DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends_v2'),
        sound: RawResourceAndroidNotificationSound(sound),
      ),
    );

    await notifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'DateRisk_',
    );
  }

  static Future<void> showDateFinishNotifications(
      RemoteMessage message, int id) async {
    // RemoteNotification? notification = message.notification;
    String? title = message.data['title'];
    String? body = message.data['body'];
    String? taskIds = message.data['task_ids'];

    taskIds ??= "";
    PreferenceUser prefs = PreferenceUser();
    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;

    FlutterLocalNotificationsPlugin notifications =
        FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/logo_alertfriends_v2');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notifications.initialize(initializationSettings);

    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        sound,
        'DateFinish',
        icon: '@mipmap/logo_alertfriends_v2',
        color: ColorPalette.principal,
        importance: Importance.max,
        fullScreenIntent: true,
        audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
        visibility: NotificationVisibility.public,
        enableLights: true,
        playSound: true,
        enableVibration: true,
        channelShowBadge: false,
        // groupAlertBehavior: GroupAlertBehavior.children,
        priority: Priority.high,

        largeIcon:
            const DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends_v2'),
        sound: RawResourceAndroidNotificationSound(sound),
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            "dateHelp_$taskIds",
            "AYUDA",
            icon: const DrawableResourceAndroidBitmap(
                '@mipmap/logo_alertfriends_v2'),
            showsUserInterface: true,
            cancelNotification: true,
          ),
          AndroidNotificationAction(
            "dateImgood_${taskIds}id=$id",
            "CANCELAR CITA",
            icon: const DrawableResourceAndroidBitmap(
                '@mipmap/logo_alertfriends_v2'),
            showsUserInterface: true,
            cancelNotification: true,
          ),
        ],
      ),
    );

    await notifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'DateRisk_${taskIds}id=$id',
    );
  }

  static Future<void> showContactResponseNotification(
      RemoteMessage message) async {
    // RemoteNotification? notification = message.notification;
    String? title = message.data['title'];
    String? body = message.data['body'];
    PreferenceUser prefs = PreferenceUser();
    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;

    FlutterLocalNotificationsPlugin notifications =
        FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/logo_alertfriends_v2');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notifications.initialize(initializationSettings);

    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        sound,
        'ContactResponse',
        icon: '@mipmap/logo_alertfriends_v2',
        color: ColorPalette.principal,
        importance: Importance.high,
        enableLights: true,
        playSound: true,
        enableVibration: true,
        channelShowBadge: false,
        priority: Priority.high,
        largeIcon:
            const DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends_v2'),
        sound: RawResourceAndroidNotificationSound(sound),
      ),
    );

    await notifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'ContactResponse',
    );
  }

  static Future<void> showFreeeNotification() async {
    // RemoteNotification? notification = message.notification;

    await flutterLocalNotificationsPlugin.show(
      11,
      "No estás protegido",
      "Prueba la versión completa por 30 días",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '11',
          'free',
          icon: '@mipmap/logo_alertfriends_v2',
          color: ColorPalette.principal,

          importance: Importance.max,

          enableLights: true,
          playSound: true,
          enableVibration: true,
          channelShowBadge: false,
          priority: Priority.high,

          largeIcon:
              DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends_v2'),
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              "ok",
              "Probar",
              icon:
                  DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends_v2'),
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
          // sound: RawResourceAndroidNotificationSound(
          //     "content://media/internal/audio/media/26.wav"),
        ),
      ),
      payload: 'free',
    );
  }

  static Future<void> showPremiumNotification() async {
    // RemoteNotification? notification = message.notification;

    await flutterLocalNotificationsPlugin.show(
      12,
      "No estás protegido",
      "Utilize la versión premium",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '12',
          'premium',
          icon: '@mipmap/logo_alertfriends_v2',
          color: ColorPalette.principal,

          importance: Importance.max,

          enableLights: true,
          playSound: true,
          enableVibration: true,
          channelShowBadge: false,
          priority: Priority.high,

          largeIcon:
              DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends_v2'),
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              "premium",
              "Prmium",
              icon:
                  DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends_v2'),
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
          // sound: RawResourceAndroidNotificationSound(
          //     "content://media/internal/audio/media/26.wav"),
        ),
      ),
      payload: 'premium',
    );
  }
}

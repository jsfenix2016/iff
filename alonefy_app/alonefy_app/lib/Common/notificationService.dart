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
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_moths_free.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/cancelDatePage.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/CancelAlert/PageView/cancelAlert.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/Controller/listContactZoneController.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import 'package:ifeelefine/Views/help_page.dart';
import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';

PreferenceUser prefs = PreferenceUser();

class RedirectViewNotifier with ChangeNotifier {
  static BuildContext? _storedContext;
  static ContactRiskBD? contactRisk;
  static void setStoredContext(BuildContext context) {
    _storedContext = context;
  }

  static BuildContext? get storedContext => _storedContext;

  //static void setContactRisk(ContactRiskBD contactRisk) =>
  //    RedirectViewNotifier.contactRisk = contactRisk;

  /// when app is in the foreground

  static Future<void> onTapNotificationBody(
      NotificationResponse? response, List<String> taskIds) async {
    if (response?.payload == null) return;

    // var contactRisk = await const HiveDataRisk().getContactRiskBD(id);
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.push(
        _storedContext!,
        MaterialPageRoute(builder: (context) => const HelpPage()),
      );
    });
  }

  static Future<void> onTapNotification(
      NotificationResponse? response, List<String> taskIds, int id) async {
    if (response?.payload == null) return;
    ContactRiskBD? contactRisk;
    await inicializeHiveBD();
    Future.sync(() async =>
        {contactRisk = await const HiveDataRisk().getContactRiskBD(id)});

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        _storedContext!,
        MaterialPageRoute(
          builder: (context) => CancelDatePage(
            contactRisk: contactRisk!,
            taskIds: taskIds,
          ),
        ),
      );
    });
  }

  static Future<void> onTapRedirectCancelZone() async {
    if (_storedContext == null) return;
    await inicializeHiveBD();
    print(prefs.getIsSelectContactRisk);
    if (prefs.getIsSelectContactRisk != -1) {
      ListContactZoneController riskVC = ListContactZoneController();
      var resp = await riskVC.getContactsZoneRisk();
      print(resp);
      int indexSelect =
          resp.indexWhere((item) => item.id == prefs.getIsSelectContactRisk);
      var contactSelect = resp[indexSelect];

      // Future.delayed(const Duration(seconds: 3), () async {
      //   await Navigator.push(
      //     _storedContext!,
      //     MaterialPageRoute(
      //       builder: (context) => CancelAlertPage(
      //           contactRisk: contactSelect,
      //           taskdIds: prefs.getlistTaskIdsCancel),
      //     ),
      //   );
      // });
    }
  }

  static Future<void> onTapPremiumNotification(
      NotificationResponse? response) async {
    await inicializeHiveBD();
    await Navigator.push(
      _storedContext!,
      MaterialPageRoute(
        builder: (context) => const PremiumPage(
            isFreeTrial: false,
            img: 'Pantalla5.jpg',
            title: "Prueba la versión gratuita por 30 días y siente protegido",
            subtitle: ''),
      ),
    ).then((value) {
      if (value != null && value) {
        prefs.setUserPremium = true;
        prefs.setUserFree = false;
        var premiumController = Get.put(PremiumController());
        premiumController.updatePremiumAPI(true);
        Navigator.of(_storedContext!).pop();
      }
    });
    //
  }

  static Future<void> onTapFreeNotification(
      NotificationResponse? response) async {
    if (_storedContext == null) return;

    await inicializeHiveBD();
    await Navigator.push(
      _storedContext!,
      MaterialPageRoute(
        builder: (context) => const PremiumMothFree(
            img: 'Pantalla5.png',
            title: "Prueba la versión gratuita por 30 días y siente protegido",
            subtitle: ''),
      ),
    ).then((value) {
      if (value != null && value) {
        prefs.setUserPremium = true;
        prefs.setUserFree = false;
        var premiumController = Get.put(PremiumController());
        premiumController.updatePremiumAPI(true);
        Navigator.of(_storedContext!).pop();
      }
    });
    // await flutterLocalNotificationsPlugin.cancel(12,
    //     tag: response!.actionId.toString());
  }

  static Future<void> manageNotifications(RemoteMessage message) async {
    var data = message.data;
    await inicializeHiveBD();
    // await prefs.initPrefs();
    if (data.containsValue(Constant.inactive) ||
        data.containsValue(Constant.drop) ||
        data.containsValue("DROP_NOTIFY_SELF")) {
      final mainController = Get.put(MainController());
      if (data.containsValue(Constant.inactive)) {
        mainController.saveUserLog("Inactividad ", DateTime.now());
        showHelpNotification(message);
      } else {
        mainController.saveUserLog("Movimiento rudo", DateTime.now());
        mainController.saveActivityLog(DateTime.now(), "Movimiento rudo");
        showDropNotification(message);
      }
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

      if (phoneNumber.isNotEmpty) {
        await contactUserController.updateContactStatus(
            phoneNumber,
            status.contains("ACCEPTED")
                ? Constant.contactAccepted
                : Constant.contactDenied);
      }

      showContactResponseNotification(message);
    }
    if (data.isEmpty) {
      showTestNotification(message);
    }
  }

  static Future<void> showHelpNotification(RemoteMessage message) async {
    /// OPTIONAL, using custom notification channel id
    if (message.data.isEmpty) return;
    String? taskIds = message.data['task_ids']; //getTaskIds(message.data);
    String? title = message.data['title'];
    String? body = message.data['body'];
    taskIds ??= "";
    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      sound, // id

      'AlertFriends – PERSONAL PROTECTION', // title
      icon: '@mipmap/logo_alertfriends_v2',
      color: ColorPalette.principal,
      importance: Importance.max,

      priority: Priority.high,

      playSound: true,
      ongoing: false,
      enableLights: true,
      groupKey: 'Inactive',
      enableVibration: true,
      channelShowBadge: true,

      autoCancel: false,

      visibility: NotificationVisibility.public,
      largeIcon:
          const DrawableResourceAndroidBitmap('@drawable/splash_v2_screen'),
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

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Inactived_$taskIds',
    );
  }

  static Future<void> getNewNotification(
      String message, List<String> listid) async {
    // String sound = prefs.getNotificationAudio;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "my_foreground",
      "my_foreground",
      playSound: false,
      importance: Importance.high,
      priority: Priority.max,
      color: ColorPalette.principal,
      // fullScreenIntent: true,
      groupKey: "New",
      enableLights: true,
      styleInformation: const BigTextStyleInformation(''),
      // largeIcon:
      //     const DrawableResourceAndroidBitmap('@drawable/splash_v2_screen'),
      visibility: NotificationVisibility.public,
      // audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
      // sound: RawResourceAndroidNotificationSound(soundResource),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          "helpID_$message",
          "AYUDA",
          icon: const DrawableResourceAndroidBitmap(
              '@mipmap/logo_alertfriends_v2'),
          showsUserInterface: true,
          cancelNotification: true,
        ),
        AndroidNotificationAction(
          "imgoodId_$message",
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

    await flutterLocalNotificationsPlugin.show(
      100,
      "Advertencia",
      'No detectamos una acción en la notificación, necesitas ayuda?',
      platformChannelSpecifics,
      payload: 'Inactived_$message',
    );
  }

  static Future<void> showDropNotification(RemoteMessage message) async {
    /// OPTIONAL, using custom notification channel id

    String? taskIds = message.data['task_ids']; //getTaskIds(message.data);
    String? title = message.data['title'];
    String? body = message.data['body'];
    taskIds ??= "";

    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      sound, // id
      'AlertFriends – PERSONAL PROTECTION', // title
      icon: '@mipmap/logo_alertfriends_v2',
      color: ColorPalette.principal,
      importance: Importance.high,
      autoCancel: false,

      priority: Priority.high,

      playSound: true,

      enableLights: true,
      groupKey: 'Drop',
      enableVibration: true,
      channelShowBadge: false,

      audioAttributesUsage: AudioAttributesUsage.notification,
      visibility: NotificationVisibility.public,
      largeIcon:
          const DrawableResourceAndroidBitmap('@drawable/splash_v2_screen'),
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

    await flutterLocalNotificationsPlugin.show(
      19,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Drop_$taskIds',
    );
  }

  static Future<void> showSendToContactNotification(
      RemoteMessage message) async {
    // RemoteNotification? notification = message.notification;
    String? title = message.data['title'];
    String? body = message.data['body'];

    String? taskIds = message.data['task_ids'];
    taskIds ??= "";

    // String sound = prefs.getNotificationAudio;

    // FlutterLocalNotificationsPlugin notifications =
    //     FlutterLocalNotificationsPlugin();

    // var initializationSettingsAndroid =
    //     const AndroidInitializationSettings('@mipmap/logo_alertfriends_v2');

    // var initializationSettings =
    //     InitializationSettings(android: initializationSettingsAndroid);
    // await notifications.initialize(initializationSettings);

    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;

    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        sound,
        'SendToContact',
        icon: '@mipmap/logo_alertfriends_v2',
        color: ColorPalette.principal,
        importance: Importance.max,
        styleInformation: const BigTextStyleInformation(''),
        groupKey: "SMS",
        visibility: NotificationVisibility.public,
        enableLights: true,
        playSound: true,
        enableVibration: true,
        channelShowBadge: false,
        priority: Priority.high,
        largeIcon:
            const DrawableResourceAndroidBitmap('@drawable/splash_v2_screen'),
        sound: RawResourceAndroidNotificationSound(sound),
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      50,
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

    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;

    // FlutterLocalNotificationsPlugin notifications =
    //     FlutterLocalNotificationsPlugin();

    // var initializationSettingsAndroid =
    //     const AndroidInitializationSettings('@mipmap/logo_alertfriends_v2');

    // var initializationSettings =
    //     InitializationSettings(android: initializationSettingsAndroid);
    // await notifications.initialize(initializationSettings);

    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        sound,
        'DateNotifications',
        icon: '@mipmap/logo_alertfriends_v2',
        color: ColorPalette.principal,
        importance: Importance.max,
        priority: Priority.high,
        // fullScreenIntent: true,
        autoCancel: false,
        audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
        styleInformation: const BigTextStyleInformation(''),
        ongoing: false,
        enableLights: true,
        // playSound: true,
        groupKey: "DateNotifications",
        enableVibration: true,
        channelShowBadge: false,
        visibility: NotificationVisibility.public,
        //groupAlertBehavior: GroupAlertBehavior.children,

        largeIcon:
            const DrawableResourceAndroidBitmap('@drawable/splash_v2_screen'),
        sound: RawResourceAndroidNotificationSound(sound),
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      80,
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

    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;

    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        sound,
        'DateFinish',
        icon: '@mipmap/logo_alertfriends_v2',
        color: ColorPalette.principal,
        importance: Importance.max,
        // fullScreenIntent: true,
        audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
        visibility: NotificationVisibility.public,
        styleInformation: const BigTextStyleInformation(''),
        ongoing: false,
        enableLights: true,
        playSound: true,
        autoCancel: false,
        showWhen: false,
        enableVibration: true,
        channelShowBadge: false,
        groupKey: "DateFinish",
        // groupAlertBehavior: GroupAlertBehavior.children,
        priority: Priority.high,

        largeIcon:
            const DrawableResourceAndroidBitmap('@drawable/splash_v2_screen'),
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

    await flutterLocalNotificationsPlugin.show(
      17,
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

    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;

    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        sound,
        'ContactResponse',
        icon: '@mipmap/logo_alertfriends_v2',
        color: ColorPalette.principal,
        importance: Importance.high,
        enableLights: true,
        playSound: true,
        groupKey: "ContactResponse",
        enableVibration: true,
        channelShowBadge: false,
        priority: Priority.high,
        largeIcon: DrawableResourceAndroidBitmap('@drawable/splash_v2_screen'),
        sound: RawResourceAndroidNotificationSound(sound),
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      16,
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

  static Future<void> showTestNotification(RemoteMessage message) async {
    // RemoteNotification? notification = message.notification;
    String? title = 'title';
    String? body = 'body';

    // await prefs.initPrefs();
    // String sound = prefs.getNotificationAudio;

    // FlutterLocalNotificationsPlugin notifications =
    //     FlutterLocalNotificationsPlugin();

    // var initializationSettingsAndroid =
    //     const AndroidInitializationSettings('@mipmap/logo_alertfriends_v2');

    // var initializationSettings =
    //     InitializationSettings(android: initializationSettingsAndroid);
    // await notifications.initialize(initializationSettings);

    var platformChannelSpecifics = const NotificationDetails(
      android: AndroidNotificationDetails(
        'organization',
        'Organization management',

        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        playSound: true,
        // ledColor: Colors.redAccent,
        color: Colors.amber,
        category: AndroidNotificationCategory.alarm,
        // icon: '@mipmap/ic_launcher',
        visibility: NotificationVisibility.public,
        // largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        // styleInformation: BigTextStyleInformation(''),
        // sound: RawResourceAndroidNotificationSound(sound),
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      17,
      title,
      body,
      platformChannelSpecifics,
      payload: 'test',
    );
  }
}

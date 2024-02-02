import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/idleLogic.dart';

import 'package:ifeelefine/Controllers/mainController.dart';

import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';

import 'package:ifeelefine/Model/contactRiskBD.dart';

import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_moths_free.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Pageview/cancelDatePage.dart';

import 'package:ifeelefine/Page/Risk/ZoneRisk/ListContactZoneRisk/Controller/listContactZoneController.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import 'package:ifeelefine/Views/help_page.dart';
import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';
import 'package:uuid/uuid.dart';

PreferenceUser prefs = PreferenceUser();

class RedirectViewNotifier with ChangeNotifier {
  static BuildContext? _storedContext;
  static ContactRiskBD? contactRisk;
  static void setStoredContext(BuildContext context) {
    _storedContext = context;
  }

  static BuildContext? get storedContext => _storedContext;

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

  static Future<void> onRefreshContact(NotificationResponse? response) async {
    Get.appUpdate();
  }

  static Future<void> onTapNotification(
      NotificationResponse? response, List<String> taskIds, int id) async {
    if (response?.payload == null) return;

    prefs.setSelectContactRisk = id;
    Future.delayed(const Duration(seconds: 2), () async {
      await Get.offAll(CancelDatePage(
        taskIds: taskIds,
      ));
    });
  }

  // static Future<void> onTapRedirectCancelZone() async {
  //   if (_storedContext == null) return;
  //   await inicializeHiveBD();
  //   print(prefs.getIsSelectContactRisk);
  //   if (prefs.getIsSelectContactRisk != -1) {
  //     ListContactZoneController riskVC = ListContactZoneController();
  //     var resp = await riskVC.getContactsZoneRisk();
  //     print(resp);
  //     int indexSelect =
  //         resp.indexWhere((item) => item.id == prefs.getIsSelectContactRisk);
  //   }
  // }

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
  }

  static Future<void> manageNotifications(RemoteMessage message) async {
    var data = message.data;
    await inicializeHiveBD();
    await prefs.initPrefs();

    if (data.containsValue(Constant.inactive) ||
        data.containsValue(Constant.drop) ||
        data.containsValue("DROP_NOTIFY_SELF")) {
      final mainController = Get.put(MainController());
      if (data.containsValue(Constant.inactive)) {
        var uuid = const Uuid();
        String newUuid = uuid.v4();
        mainController.saveUserLog("Inactividad ", DateTime.now(), newUuid);
        prefs.setIdInactiveGroup = newUuid;
        prefs.setEnableTimer = true;
        showHelpNotification(message);
      } else {
        var uuid = const Uuid();
        String newUuid = uuid.v4();
        mainController.saveUserLog("Caida", DateTime.now(), newUuid);

        mainController.saveActivityLog(DateTime.now(), "Caida", newUuid);
        prefs.setIdDropGroup = newUuid;
        prefs.setEnableTimerDrop = true;
        showDropNotification(message);
      }
    } else if (data.containsValue(Constant.startRiskDate) ||
        data.containsValue(Constant.finishRiskDate)) {
      final editRiskController = Get.put(EditRiskController());
      var id = int.parse(data['id']);

      if (data.containsValue(Constant.startRiskDate)) {
        if (id != prefs.getCancelIdDate) {
          editRiskController.updateContactRiskWhenDateStarted(id);
          showDateNotifications(message);
        }
      } else {
        if (id != prefs.getCancelIdDate) {
          mainController.saveUserLog(
              "Cita finalizada", DateTime.now(), prefs.getIdDateGroup);

          prefs.setListDate = true;
          editRiskController.updateContactRiskWhenDateFinished(id, data);
          showDateFinishNotifications(message, id);
        }
      }
    } else if (data.containsValue(Constant.contactStatusChanged)) {
      String phoneNumber = data["phone_number"];
      String status = data['status'];

      if (phoneNumber.isNotEmpty) {
        mainController.uptadeCOntact(
            phoneNumber,
            status.contains("ACCEPTED")
                ? Constant.contactAccepted
                : Constant.contactDenied);

        showContactResponseNotification(message);
      }
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

    String sound = prefs.getNotificationAudio;

    timerTempDown = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      // Actualizar el contenido de la notificación en tiempo real
      prefs.refreshData();

      String updatedContent =
          '${countdown ~/ 60}:${(countdown % 60).toString().padLeft(2, '0')}';
      notificationContentController.add(updatedContent);
      var temp = body!.replaceAll(
          ",", ", En $updatedContent se notificara a tus contactos, ");

      var bigTextStyleInformation =
          BigTextStyleInformation(temp, htmlFormatBigText: true);

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        sound, // id

        'AlertFriends – PERSONAL PROTECTION', // title
        icon: '@mipmap/logo_alertfriends_v2',
        color: ColorPalette.principal,
        importance: Importance.max,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,

        playSound: true,
        ongoing: true,
        enableLights: true,
        groupKey: 'Inactive',
        enableVibration: true,
        channelShowBadge: true,
        onlyAlertOnce: true,
        autoCancel: false,

        visibility: NotificationVisibility.public,
        // largeIcon: const DrawableResourceAndroidBitmap(
        //     '@drawable/logo_alertfriends_v2_background'),
        sound: RawResourceAndroidNotificationSound(sound),

        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            "helpID_$taskIds",
            "PEDIR AYUDA",
            titleColor: Colors.red,
            icon: const DrawableResourceAndroidBitmap(
                '@mipmap/logo_alertfriends_v2'),
            showsUserInterface: false,
            cancelNotification: true,
          ),
          AndroidNotificationAction(
            "imgoodId_$taskIds",
            "ESTOY BIEN",
            titleColor: Colors.green,
            icon: const DrawableResourceAndroidBitmap(
                '@mipmap/logo_alertfriends_v2'),
            showsUserInterface: false,
            cancelNotification: true,
          ),
        ],
      );

      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      countdown--;
      // Actualizar la notificación local
      if (prefs.getEnableTimer == false || countdown <= 0) {
        t.cancel();

        mainController.saveUserLog("Inactividad - se notificó a tus contactos",
            DateTime.now(), prefs.getIdInactiveGroup);

        await flutterLocalNotificationsPlugin.cancel(0);
        timerTempDown.cancel();
      } else {
        await flutterLocalNotificationsPlugin.show(
          0,
          title,
          temp,
          platformChannelSpecifics,
          payload: 'Inactived_$taskIds',
        );
      }

      if (countdown <= 0) {
        t.cancel();
        await flutterLocalNotificationsPlugin.cancel(0);
        timerTempDown.cancel();
      }
    });
  }

  Future<void> getNewNotification(String message, List<String> listid) async {
    // String sound = prefs.getNotificationAudio;

    timerTempDown = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      // Actualizar el contenido de la notificación en tiempo real
      prefs.refreshData();

      String updatedContent =
          '${countdown ~/ 60}:${(countdown % 60).toString().padLeft(2, '0')}';
      notificationContentController.add(updatedContent);
      var temp =
          'No detectamos una acción en la notificación, necesitas ayuda?!'
              .replaceAll(
                  ",", ",En $updatedContent se notificara a tus contactos, ");

      var bigTextStyleInformation =
          BigTextStyleInformation(temp, htmlFormatBigText: true);
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "my_foreground",
        "my_foreground",
        playSound: false,
        importance: Importance.high,
        priority: Priority.max,
        color: ColorPalette.principal,
        styleInformation: bigTextStyleInformation,
        groupKey: "New",
        enableLights: true,
        onlyAlertOnce: true,
        enableVibration: false,
        largeIcon: const DrawableResourceAndroidBitmap(
            '@drawable/logo_alertfriends_v2_background'),
        visibility: NotificationVisibility.public,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            "helpID_$message",
            "PEDIR AYUDA",
            icon: const DrawableResourceAndroidBitmap(
                '@mipmap/logo_alertfriends_v2'),
            showsUserInterface: false,
            cancelNotification: true,
          ),
          AndroidNotificationAction(
            "imgoodId_$message",
            "ESTOY BIEN",
            icon: const DrawableResourceAndroidBitmap(
                '@mipmap/logo_alertfriends_v2'),
            showsUserInterface: false,
            cancelNotification: true,
          ),
        ],
      );

      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      // Actualizar la notificación local
      // updateNotification('Advertencia', temp, platformChannelSpecifics,
      //     'Inactived_$message', 100);

      await flutterLocalNotificationsPlugin.show(
        100,
        "Advertencia",
        temp,
        platformChannelSpecifics,
        payload: 'Inactived_$message',
      );

      countdown--;

      if (countdown <= 0) {
        t.cancel();
        countdown = 300;
        mainController.saveUserLog(
            "Caida - no hubo respuesta", DateTime.now(), prefs.getIdDropGroup);

        await flutterLocalNotificationsPlugin.cancel(100);
      }
    });
  }

  static void updateNotification(String title, String updatedContent,
      NotificationDetails anddetail, String payload, int id) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      updatedContent,
      anddetail,
      payload: payload,
    );
  }

  // void startTimer() {
  //   Timer.periodic(const Duration(seconds: 1), (Timer t) {
  //     // Actualizar el contenido de la notificación en tiempo real
  //     String updatedContent =
  //         'Tiempo restante: ${countdown ~/ 60}:${(countdown % 60).toString().padLeft(2, '0')}';
  //     notificationContentController.add(updatedContent);

  //     // Actualizar la notificación local
  //     // updateNotification(updatedContent);
  //     countdown--;

  //     if (countdown <= 0) {
  //       t.cancel();
  //     }
  //   });
  // }

  static Future<void> showDropNotification(RemoteMessage message) async {
    /// OPTIONAL, using custom notification channel id

    String? taskIds = message.data['task_ids']; //getTaskIds(message.data);
    String? title = message.data['title'];
    String? body = message.data['body'];
    taskIds ??= "";

    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;

    timerDropTempDown =
        Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      // Actualizar el contenido de la notificación en tiempo real
      prefs.refreshData();

      String updatedContent =
          '${countdownDrop ~/ 60}:${(countdownDrop % 60).toString().padLeft(2, '0')}';
      notificationContentController.add(updatedContent);

      var temp = body!.replaceAll("5", updatedContent);
      if (body.contains("caida")) {
        temp = body;
      }
      var bigTextStyleInformation =
          BigTextStyleInformation(temp, htmlFormatBigText: true);
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        sound, // id
        'AlertFriends – PERSONAL PROTECTION', // title
        icon: '@mipmap/logo_alertfriends_v2',
        color: ColorPalette.principal,
        importance: Importance.high,
        autoCancel: false,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        onlyAlertOnce: true,
        playSound: true,
        ongoing: true,
        enableLights: true,
        groupKey: 'Drop',
        enableVibration: true,
        channelShowBadge: false,

        audioAttributesUsage: AudioAttributesUsage.notification,
        visibility: NotificationVisibility.public,
        largeIcon: const DrawableResourceAndroidBitmap(
            '@drawable/logo_alertfriends_v2_background'),
        sound: RawResourceAndroidNotificationSound(sound),

        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            "helpID_$taskIds",
            "PEDIR AYUDA",
            icon: const DrawableResourceAndroidBitmap(
                '@mipmap/logo_alertfriends_v2'),
            showsUserInterface: false,
            cancelNotification: true,
          ),
          AndroidNotificationAction(
            "imgoodId_$taskIds",
            "ESTOY BIEN",
            icon: const DrawableResourceAndroidBitmap(
                '@mipmap/logo_alertfriends_v2'),
            showsUserInterface: false,
            cancelNotification: true,
          ),
        ],
      );

      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      // Actualizar la notificación local
      countdownDrop--;
      if (prefs.getEnableTimerDrop == false || countdownDrop <= 0) {
        t.cancel();
        countdownDrop = 300;
        mainController.saveUserLog(
            "Caida - no hubo respuesta", DateTime.now(), prefs.getIdDropGroup);

        await flutterLocalNotificationsPlugin.cancel(19);
      } else {
        // updateNotification(
        //     title!, temp, platformChannelSpecifics, 'Drop_$taskIds', 19);
        await flutterLocalNotificationsPlugin.show(
          19,
          title,
          temp,
          platformChannelSpecifics,
          payload: 'Drop_$taskIds',
        );
      }

      if (countdownDrop <= 0) {
        t.cancel();
        countdownDrop = 300;
        await flutterLocalNotificationsPlugin.cancel(19);
      }
    });
  }

  static Future<void> showSendToContactNotification(
      RemoteMessage message) async {
    // RemoteNotification? notification = message.notification;
    String? title = message.data['title'];
    String? body = message.data['body'];

    String? taskIds = message.data['task_ids'];
    taskIds ??= "";

    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;
    var styleInformation =
        BigTextStyleInformation(body!, htmlFormatBigText: true);
    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        sound,
        'SendToContact',
        icon: '@mipmap/logo_alertfriends_v2',
        color: ColorPalette.principal,
        importance: Importance.max,
        styleInformation: styleInformation,
        groupKey: "SMS",
        visibility: NotificationVisibility.public,
        enableLights: true,
        playSound: true,
        enableVibration: true,
        channelShowBadge: false,
        priority: Priority.high,
        largeIcon: const DrawableResourceAndroidBitmap(
            '@drawable/ic_bg_service_small'),
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
      mainController.saveUserLog(
          "Envio de SMS a contacto cita", now, prefs.getIdDateGroup);
    });
  }

  static Future<void> showDateNotifications(RemoteMessage message) async {
    // RemoteNotification? notification = message.notification;
    String? title = message.data['title'];
    String? body = message.data['body'];

    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;
    prefs.setCountFinish = false;

    var styleInformation =
        BigTextStyleInformation(body!, htmlFormatBigText: true);
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
        styleInformation: styleInformation,
        ongoing: false,
        enableLights: true,
        // playSound: true,
        groupKey: "DateNotifications",
        enableVibration: true,
        channelShowBadge: false,
        visibility: NotificationVisibility.public,
        //groupAlertBehavior: GroupAlertBehavior.children,

        largeIcon: const DrawableResourceAndroidBitmap(
            '@drawable/ic_bg_service_small'),
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
    prefs.setListDate = false;
    String sound = prefs.getNotificationAudio;
    prefs.saveLastScreenRoute("cancelDate");
    NotificationCenter().notify('getContactZoneRisk');
    var styleInformation =
        BigTextStyleInformation(body!, htmlFormatBigText: true);
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
        styleInformation: styleInformation,
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

        largeIcon: const DrawableResourceAndroidBitmap(
            '@drawable/ic_bg_service_small'),
        sound: RawResourceAndroidNotificationSound(sound),
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            "dateHelp_$taskIds",
            "AYUDA",
            icon: const DrawableResourceAndroidBitmap(
                '@mipmap/logo_alertfriends_v2'),
            showsUserInterface: false,
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
        largeIcon: const DrawableResourceAndroidBitmap(
            '@drawable/ic_bg_service_small'),
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
              showsUserInterface: false,
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
              showsUserInterface: false,
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

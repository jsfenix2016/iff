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
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Views/help_page.dart';
import 'package:ifeelefine/main.dart';
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
    prefs.saveLastScreenRoute("help");

    if (_storedContext != null) {
      Navigator.push(
        _storedContext!,
        MaterialPageRoute(
          builder: (context) => const HelpPage(),
          settings: RouteSettings(
            arguments:  {
              'type': response != null && response.payload!.contains("Drop_") ? 'DROP' : 'INACTIVITY',
              'id': response?.id
            }
          )),
      );
    }
  }

  static Future<void> onRefreshContact(NotificationResponse? response) async {
    Get.appUpdate();
  }

  static Future<void> onTapNotification(List<String> taskIds, int id) async {
    prefs.saveLastScreenRoute("cancelDate");
    prefs.setSelectContactRisk = id;

    if (_storedContext != null) {
      await Navigator.pushReplacement(
        _storedContext!,
        MaterialPageRoute(
            builder: (context) => CancelDatePage(
                  taskIds: taskIds,
                )),
      );
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
        mainController.refreshHome();
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

  static void createlogInactividad(String typeAction) {
    String newUuid = const Uuid().v4();
    // final mainController = Get.put(MainController());

    prefs.refreshData();
    MainController? mainController;
    try {
      mainController = Get.find<MainController>();
    } catch (e) {
      // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
      // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
      mainController = Get.put(MainController());
    }
    // Ahora, puedes utilizar riskVC normalmente sabiendo que está disponible.
    if (mainController != null) {
      prefs.setNotificationType = "Inactividad";
      mainController.saveUserLog(typeAction, DateTime.now(), newUuid);
      prefs.setIdInactiveGroup = newUuid;
    }
  }

  static void createLogDrop(String typeAction) {
    var uuid = const Uuid();
    String newUuid = uuid.v4();
    MainController? mainController;
    try {
      mainController = Get.find<MainController>();
    } catch (e) {
      // Si Get.find lanza un error, eso significa que el controlador no está en el árbol de widgets.
      // En ese caso, usamos Get.put para agregar el controlador al árbol de widgets.
      mainController = Get.put(MainController());
    }
    // Ahora, puedes utilizar riskVC normalmente sabiendo que está disponible.
    if (mainController != null) {
      mainController.saveUserLog(typeAction, DateTime.now(), newUuid);
      prefs.setIdDropGroup = newUuid;
      prefs.setEnableTimerDrop = true;
    }
  }

  static Future<void> manageNotifications(RemoteMessage message) async {
    var data = message.data;
    await inicializeHiveBD();
    await prefs.initPrefs();
    prefs.setEnableTimer = true;
    prefs.setAlertPointRed = true;
    if (data.containsValue(Constant.inactive) ||
        data.containsValue(Constant.drop)) {
      if (data.containsValue(Constant.inactive)) {
        createlogInactividad("Inactividad");
        showHelpNotification(message);
      } else {
        createLogDrop("Caida");
        prefs.setNotificationType = "Caida";
        showDropNotification(message);
      }
    }
    if (data.containsValue(Constant.dropSelf) ||
        data.containsValue(Constant.inactivitySelf)) {
      if (data.containsValue(Constant.inactivitySelf)) {
        mainController.saveUserLog("Inactividad - No respondió la notificación",
            DateTime.now(), prefs.getIdInactiveGroup);
        prefs.setNotificationType = "Inactividad";
        await flutterLocalNotificationsPlugin.cancel(0);
      } else {
        final mainController = Get.put(MainController());
        prefs.setNotificationType = "Caida";
        mainController.saveUserLog("Caida - No respondió la notificación",
            DateTime.now(), prefs.getIdDropGroup);
      }
      getNewNotification(message);
    } else if (data.containsValue(Constant.startRiskDate) ||
        data.containsValue(Constant.finishRiskDate)) {
      final editRiskController = Get.put(EditRiskController());
      var id = int.parse(data['id']);

      if (data.containsValue(Constant.startRiskDate)) {
        if (id != prefs.getCancelIdDate) {
          prefs.setNotificationType = "Cita";
          final mainController = Get.put(MainController());
          mainController.saveUserLog(
              "Cita - iniciada", DateTime.now(), prefs.getIdDateGroup);
          editRiskController.updateContactRiskWhenDateStarted(id);
          showDateNotifications(message);
        }
      } else {
        if (id != prefs.getCancelIdDate) {
          prefs.setNotificationType = "Cita";
          final mainController = Get.put(MainController());
          mainController.saveUserLog(
              "Cita - finalizada", DateTime.now(), prefs.getIdDateGroup);
          prefs.setFinishIdDate = true;
          prefs.setListDate = true;
          editRiskController.updateContactRiskWhenDateFinished(id, data);
          showDateFinishNotifications(message, id);
        }
      }
    } else if (data.containsValue(Constant.contactStatusChanged)) {
      String phoneNumber = data["phone_number"];
      String status = data['status'];

      if (phoneNumber.isNotEmpty) {
        final mainController = Get.put(MainController());
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

    mainController.refreshHome();
  }

  static Future<void> showHelpNotification(RemoteMessage message) async {
    /// OPTIONAL, using custom notification channel id
    if (message.data.isEmpty) return;
    String? taskIds = message.data['task_ids']; //getTaskIds(message.data);
    String? title = message.data['title'];
    String? body = message.data['body'];
    taskIds ??= "";

    String sound = prefs.getNotificationAudio;
    var list = [taskIds];
    prefs.setlistTaskIdsCancel = list;
    var temp = body!;

    var bigTextStyleInformation =
        BigTextStyleInformation(body.toString(), htmlFormatBigText: true);

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

      sound: RawResourceAndroidNotificationSound(sound),

      actions: actionButtonNotify(taskIds),
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      temp,
      platformChannelSpecifics,
      payload: 'Inactived_$taskIds',
    );
    prefs.setNotificationId = 0;
  }

  static List<AndroidNotificationAction> actionButtonNotify(String task) {
    var a = <AndroidNotificationAction>[
      AndroidNotificationAction(
        "helpID_$task",
        "PEDIR AYUDA",
        titleColor: Colors.red,
        icon:
            const DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends_v2'),
        showsUserInterface: false,
        cancelNotification: false,
      ),
      AndroidNotificationAction(
        "imgoodId_$task",
        "ESTOY BIEN",
        titleColor: Colors.green,
        icon:
            const DrawableResourceAndroidBitmap('@mipmap/logo_alertfriends_v2'),
        showsUserInterface: false,
        cancelNotification: false,
      ),
    ];

    return a;
  }

  static Future<void> getNewNotification(RemoteMessage message) async {
    // String sound = prefs.getNotificationAudio;
    if (message.data.isEmpty) return;
    String? taskIds = message.data['task_ids']; //getTaskIds(message.data);
    String? body = message.data['body'];
    taskIds ??= "";
    var list = [taskIds];
    prefs.setlistTaskIdsCancel = list;
    bool isFirstTimeNotification = true;

    await flutterLocalNotificationsPlugin
        .cancel(message.data.containsValue(Constant.inactivitySelf) ? 0 : 19);

    timerTempDown = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      // Verificar si el temporizador ha sido cancelado antes de mostrar la notificación

      if (timerTempDown!.isActive || t.isActive) {
        if (prefs.getEnableTimer == false || timeRevert <= 0) {
          t.cancel();
          timeRevert = 300;

          timerTempDown!.cancel();
          cancelNotification(100);
          return;
        }
      }

      if (t.isActive) {
        // Actualizar el contenido de la notificación en tiempo real
        prefs.refreshData();

        String updatedContent =
            '${(timeRevert ~/ 60).toString().padLeft(2, '0')}:${(timeRevert % 60).toString().padLeft(2, '0')}';

        var temp =
            'No detectamos una acción en la notificación, necesitas ayuda?!'
                .replaceAll(",",
                    ", En $updatedContent se notificara a tus contactos, ");
        var bigTextStyleInformation =
            BigTextStyleInformation(temp, htmlFormatBigText: true);
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          "my_foreground",
          "my_foreground",
          playSound: false,
          importance: Importance.high,
          priority: Priority.max,
          icon: '@mipmap/logo_alertfriends_v2',
          color: ColorPalette.principal,
          styleInformation: bigTextStyleInformation,
          groupKey: message.data.containsValue(Constant.inactivitySelf)
              ? "Inactive"
              : 'Drop',
          ongoing: true,
          enableLights: true,
          onlyAlertOnce: true,
          enableVibration: false,
          autoCancel: false,
          largeIcon: const DrawableResourceAndroidBitmap(
              '@drawable/logo_alertfriends_v2_background'),
          visibility: NotificationVisibility.public,
          actions: actionButtonNotify(taskIds!),
        );

        var platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);

        List<ActiveNotification> lista =
            await flutterLocalNotificationsPlugin.getActiveNotifications();
        var existNotification =
            lista.firstWhereOrNull((element) => element.id == 100);

        if (isFirstTimeNotification || existNotification != null) {
          isFirstTimeNotification = false;
          showNotification(temp, platformChannelSpecifics, message);
        }
        prefs.setNotificationId = 100;

        timeRevert--;

        if (timeRevert <= 0) {
          t.cancel();
          timeRevert = 300;
          mainController.saveUserLog(
              message.data.containsValue(Constant.inactivitySelf)
                  ? "Inactividad - no hubo respuesta"
                  : "Caida - no hubo respuesta",
              DateTime.now(),
              message.data.containsValue(Constant.inactivitySelf)
                  ? prefs.getIdInactiveGroup
                  : prefs.getIdDropGroup);
          cancelNotification(100);
        }
      }
    });
  }

  static void showNotification(
      String body,
      NotificationDetails platformChannelSpecifics,
      RemoteMessage message) async {
    await flutterLocalNotificationsPlugin.show(
      100,
      "Advertencia",
      body,
      platformChannelSpecifics,
      payload: message.data.containsValue(Constant.inactivitySelf)
          ? 'Inactived_$message'
          : 'Drop_$message',
    );
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> showDropNotification(RemoteMessage message) async {
    /// OPTIONAL, using custom notification channel id

    String? taskIds = message.data['task_ids']; //getTaskIds(message.data);
    String? title = message.data['title'];
    String? body = message.data['body'];
    taskIds ??= "";
    var list = [taskIds];
    prefs.setlistTaskIdsCancel = list;
    await prefs.initPrefs();
    String sound = prefs.getNotificationAudio;

    var bigTextStyleInformation =
        BigTextStyleInformation(body!, htmlFormatBigText: true);
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

      actions: actionButtonNotify(taskIds),
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
    prefs.setNotificationId = 19;
  }

  static Future<void> showSendToContactNotification(
      RemoteMessage message) async {
    // RemoteNotification? notification = message.notification;
    String? title = message.data['title'];
    String? body = message.data['body'];

    String? taskIds = message.data['task_ids'];
    taskIds ??= "";
    var list = [taskIds];
    prefs.setlistTaskIdsCancel = list;
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
    prefs.setNotificationId = 80;
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
    if (flutterLocalNotificationsPlugin.isBlank == null) {
      print("flutterLocalNotificationsPlugin vacio");
    }
    try {
      await flutterLocalNotificationsPlugin.show(
        17,
        title,
        body,
        platformChannelSpecifics,
        payload: 'DateRisk_${taskIds}id=$id',
      );
      prefs.setNotificationId = 17;
    } catch (e) {
      print(e);
    }
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
        ),
      ),
      payload: 'premium',
    );
  }

  static Future<void> showTestNotification(RemoteMessage message) async {
    // RemoteNotification? notification = message.notification;
    String? title = 'title';
    String? body = 'body';

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
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      888,
      title,
      body,
      platformChannelSpecifics,
      payload: 'test',
    );
  }

  static Future<void> showFinishTimerCancelNotification() async {
    // RemoteNotification? notification = message.notification;
    String? title = 'Información';
    String? body =
        "El servidor de AlertFriends envió una alerta con tu última ubicación";

    var styleInformation =
        BigTextStyleInformation(body, htmlFormatBigText: true);
    var platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'organization',
        'Organization management',
        styleInformation: styleInformation,
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        playSound: true,
        // ledColor: Colors.redAccent,
        color: Colors.amber,
        category: AndroidNotificationCategory.alarm,
        // icon: '@mipmap/ic_launcher',
        visibility: NotificationVisibility.public,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      8888,
      title,
      body,
      platformChannelSpecifics,
      payload: 'timerCancel',
    );
  }
}

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:ifeelefine/Common/notificationService.dart';
// import 'package:ifeelefine/Common/utils.dart';
// import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/PageView/riskDatePage.dart';
// import 'package:ifeelefine/Services/mainService.dart';
// import 'package:ifeelefine/main.dart';
// import 'package:notification_center/notification_center.dart';

// class NotificationManager {
//   static final NotificationManager _instance = NotificationManager._internal();
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   factory NotificationManager() {
//     return _instance;
//   }

//   NotificationManager._internal() {
//     // Inicializa el objeto _flutterLocalNotificationsPlugin
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/logo_alertfriends_v2');
//     final List<DarwinNotificationCategory> darwinNotificationCategories =
//         <DarwinNotificationCategory>[];
//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification:
//           (int id, String? title, String? body, String? payload) async {
//         showDialog(
//           context: RedirectViewNotifier.context!,
//           builder: (BuildContext context) => CupertinoAlertDialog(
//             title: const Text("title"),
//             content: const Text("body"),
//             actions: [
//               CupertinoDialogAction(
//                 isDefaultAction: true,
//                 child: const Text('Ok'),
//                 onPressed: () async {
//                   Navigator.of(context, rootNavigator: true).pop();
//                   await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const RiskPage(),
//                     ),
//                   );
//                 },
//               )
//             ],
//           ),
//         );
//       },
//       notificationCategories: darwinNotificationCategories,
//     );
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );
//     _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> updateNotificationSettings(
//       NotificationSettings newSettings) async {
//     // Actualiza la configuración del objeto _flutterLocalNotificationsPlugin

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );
    
//     String sound = prefs.getNotificationAudio;
//     // Muestra la notificación local en segundo plano
//     AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//         'my_foreground', // channelId
//         'AlertFriends – PERSONAL PROTECTION', // channelName
//         importance: Importance.max,
//         priority: Priority.max,
//         showWhen: false,
//         playSound: true,
//         enableLights: true,
//         enableVibration: true,
//         channelShowBadge: true,
//         fullScreenIntent: true,
//         audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
//         visibility: NotificationVisibility.public,
//         sound: RawResourceAndroidNotificationSound(sound));

//     final platformChannelSpecifics =
//         NotificationDetails(android: androidDetails);

//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       'Title',
//       'Body',
//       platformChannelSpecifics,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) async {
//         onDidReceiveNotificationResponse(notificationResponse);
//       },
//       onDidReceiveBackgroundNotificationResponse:
//           onDidReceiveBackgroundNotificationResponse,
//     );

//     final details = await _flutterLocalNotificationsPlugin
//         .getNotificationAppLaunchDetails();
//     if (details != null && details.didNotificationLaunchApp) {
//       print("object ${details.notificationResponse!.payload}");
//       onDidReceiveNotificationResponse(details.notificationResponse!);
//     }
//   }

//   void onDidReceiveNotificationResponse(
//       NotificationResponse notificationResponse) async {
//     mainController.saveActivityLog(DateTime.now(), "Movimiento normal");
//     // Maneja las respuestas de notificaciones en segundo plano aquí
//     switch (notificationResponse.notificationResponseType) {
//       case NotificationResponseType.selectedNotification:
//         // selectNotificationStream.add(notificationResponse.payload);
//         if (notificationResponse.payload!.contains("free")) {
//           RedirectViewNotifier.onTapFreeNotification(notificationResponse);
//         }
//         if (notificationResponse.payload!.contains("premium")) {
//           RedirectViewNotifier.onTapPremiumNotification(notificationResponse);
//         }
//         if (notificationResponse.payload!.contains("Inactived_")) {
//           ismove = false;
//           timerActive = true;
//           String taskIds =
//               notificationResponse.payload!.replaceAll("Inactived_", "");
//           var taskIdList = getTaskIdList(taskIds);

//           MainService().cancelAllNotifications(taskIdList);
//         }
//         if (notificationResponse.actionId == "Inactived") {
//           ismove = false;
//           timerActive = true;
//           String taskIds =
//               notificationResponse.actionId!.replaceAll("Inactived_", "");
//           var taskIdList = getTaskIdList(taskIds);

//           MainService().cancelAllNotifications(taskIdList);
//         }
//         if (notificationResponse.actionId != null &&
//             notificationResponse.actionId!.contains("DateRisk")) {
//           String taskIds = notificationResponse.actionId!
//               .substring(0, notificationResponse.actionId!.indexOf('id='));
//           taskIds = taskIds.replaceAll("DateRisk_", "");
//           String id = notificationResponse.actionId!.substring(
//               notificationResponse.actionId!.indexOf('id='),
//               notificationResponse.actionId!.length);
//           id = id.replaceAll("id=", "");
//           NotificationCenter().notify('getContactRisk');
//           var taskIdList = getTaskIdList(taskIds);
//           RedirectViewNotifier.onTapNotification(
//               notificationResponse, taskIdList, int.parse(id));
//         }

//         break;
//       case NotificationResponseType.selectedNotificationAction:
//         if (notificationResponse.actionId != null &&
//             notificationResponse.actionId!.contains("helpID")) {
//           String taskIds =
//               notificationResponse.actionId!.replaceAll("helpID_", "");
//           var taskIdList = getTaskIdList(taskIds);

//           MainService().sendAlertToContactImmediately(taskIdList);
//         }
//         if (notificationResponse.actionId != null &&
//             notificationResponse.actionId!.contains("imgoodId")) {
//           String taskIds =
//               notificationResponse.actionId!.replaceAll("imgoodId_", "");
//           var taskIdList = getTaskIdList(taskIds);
//           ismove = false;
//           timerActive = true;

//           MainService().cancelAllNotifications(taskIdList);
//           await _flutterLocalNotificationsPlugin.cancelAll();
//         }
//         if (notificationResponse.actionId != null &&
//             notificationResponse.actionId!.contains("dateHelp")) {
//           String taskIds =
//               notificationResponse.actionId!.replaceAll("dateHelp_", "");
//           var taskIdList = getTaskIdList(taskIds);
//           NotificationCenter().notify('getContactRisk');

//           MainService().sendAlertToContactImmediately(taskIdList);
//         }
//         if (notificationResponse.actionId!.contains("premium")) {
//           RedirectViewNotifier.onTapPremiumNotification(notificationResponse);
//         }
//         if (notificationResponse.actionId!.contains("ok")) {
//           RedirectViewNotifier.onTapFreeNotification(notificationResponse);
//         }
//         if (notificationResponse.actionId != null &&
//             notificationResponse.actionId!.contains("dateImgood")) {
//           String taskIds = notificationResponse.actionId!
//               .substring(0, notificationResponse.actionId!.indexOf('id='));
//           taskIds = taskIds.replaceAll("dateImgood_", "");
//           String id = notificationResponse.actionId!.substring(
//               notificationResponse.actionId!.indexOf('id='),
//               notificationResponse.actionId!.length);
//           id = id.replaceAll("id=", "");
//           NotificationCenter().notify('getContactRisk');
//           var taskIdList = getTaskIdList(taskIds);
//           RedirectViewNotifier.onTapNotification(
//               notificationResponse, taskIdList, int.parse(id));
//         }

//         break;
//     }
//   }

//   @pragma('vm:entry-point')
//   void onDidReceiveBackgroundNotificationResponse(
//       NotificationResponse notificationResponse) async {
//     onDidReceiveNotificationResponse(notificationResponse);
//   }
// }

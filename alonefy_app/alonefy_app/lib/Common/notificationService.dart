// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> showNotification() async {
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       timeoutAfter: 5000,
//       styleInformation: AndroidBigPictureStyleInformation('Notification body',
//           bigPicture: 'path_to_your_image',
//           htmlFormatBigPicture: true,
//           contentTitle: 'Notification Title',
//           htmlFormatContentTitle: true,
//           summaryText: 'Summary',
//           htmlFormatSummaryText: true,
//           actions: <AndroidNotificationAction>[
//             AndroidNotificationAction(
//                 'button_1', 'Button 1', 'button_1_action'),
//             AndroidNotificationAction(
//                 'button_2', 'Button 2', 'button_2_action'),
//             AndroidNotificationAction(
//                 'button_3', 'Button 3', 'button_3_action'),
//             AndroidNotificationAction(
//                 'button_4', 'Button 4', 'button_4_action'),
//           ]),
//     );
//     var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//     var platformChannelSpecifics = NotificationDetails(
//         androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//         0, 'Notification Title', 'Notification body', platformChannelSpecifics,
//         payload: 'item x');
//   }

// Future selectNotification(String payload) async {
//     if (payload != null) {
//       debugPrint('notification payload: $payload');
//     }
//     await Navigator.push(
//       context,
//       MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
//     );
// }

//   Future onDidReceiveLocalNotification(
//       int id, String title, String body, String payload) async {
//     // display a dialog with the notification details, tap ok to go to another page
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => CupertinoAlertDialog(
//         title: Text(title),
//         content: Text(body),
//         actions: [
//           CupertinoDialogAction(
//             isDefaultAction: true,
//             child: Text('Ok'),
//             onPressed: () async {
//               Navigator.of(context, rootNavigator: true).pop();
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SecondScreen(payload),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

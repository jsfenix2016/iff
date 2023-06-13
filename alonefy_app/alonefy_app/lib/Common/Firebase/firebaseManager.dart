import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Firebase/FirebaseService.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Model/ApiRest/FirebaseTokenApi.dart';

import '../../Controllers/mainController.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  showFlutterNotification(message);
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

void showFlutterNotification(RemoteMessage message) {
  RedirectViewNotifier.showNotificationsFromFirebase(message);
}

Future<void> showNotification() async {
  RedirectViewNotifier.showNotifications();
}

Future<void> showRiskNotification() async {
  RedirectViewNotifier.showDateNotifications();
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> initializeFirebase() async {
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.getInitialMessage();

  onActionSelected("get_apns_token");
  FirebaseMessaging.onMessage.listen(showFlutterNotification);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //if (!kIsWeb) {
  //await setupFlutterNotifications();
  //}
}

int _messageCount = 0;

String constructFCMPayload(String? token) {
  _messageCount++;
  return jsonEncode({
    'token': token,
    'data': {
      'via': 'FlutterFire Cloud Messaging!!!',
      'count': _messageCount.toString(),
    },
    'notification': {
      'title': 'Hello FlutterFire!',
      'body': 'This notification (#$_messageCount) was created via FCM!',
    },
  });
}

Future<void> onActionSelected(String value) async {
  switch (value) {
    case 'subscribe':
      {
        print(
          'FlutterFire Messaging Example: Subscribing to topic "fcm_test".',
        );
        await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
        print(
          'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.',
        );
      }
      break;
    case 'unsubscribe':
      {
        print(
          'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".',
        );
        await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
        print(
          'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.',
        );
      }
      break;
    case 'get_apns_token':
      {
        if (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS) {
          print('FlutterFire Messaging Example: Getting APNs token...');
          String? token = await FirebaseMessaging.instance.getAPNSToken();
          print('FlutterFire Messaging Example: Got APNs token: $token');
        } else {
          String? token = await FirebaseMessaging.instance.getToken();

          final MainController mainController = Get.put(MainController());
          var user = await mainController.getUserData();

          if (user.telephone != "" && token != null) {
            var firebaseTokenApi =
                FirebaseTokenApi(phoneNumber: user.telephone, fcmToken: token);
            FirebaseService().saveData(firebaseTokenApi);
          }

          print(
            'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.',
          );
        }
      }
      break;
    default:
      break;
  }
}

Future<void> sendPushMessage(String token) async {
  if (token == null) {
    print('Unable to send FCM message, no token exists.');
    return;
  }

  //try {
  //  await http.post(
  //    Uri.parse('https://api.rnfirebase.io/messaging/send'),
  //    headers: <String, String>{
  //      'Content-Type': 'application/json; charset=UTF-8',
  //    },
  //    body: constructFCMPayload(token),
  //  );
  //  print('FCM request for device sent!');
  //} catch (e) {
  //  print(e);
  //}
}

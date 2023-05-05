import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ifeelefine/Common/notificationService.dart';

import '../../main.dart';
import '../colorsPalette.dart';
import 'firebaseOptions.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  //if (isFlutterLocalNotificationsInitialized) {
  //  return;
  //}
  channel = const AndroidNotificationChannel(
    'my_foreground', // id
    'IFEELFINE – PERSONAL PROTECTION', // title
    description: 'IFeelFine está activado.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
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
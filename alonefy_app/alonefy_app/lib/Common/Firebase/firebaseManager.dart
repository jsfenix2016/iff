import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:ifeelefine/Common/Firebase/FirebaseService.dart';

import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Model/ApiRest/FirebaseTokenApi.dart';
import 'package:ifeelefine/main.dart';

import '../../Controllers/mainController.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  showFlutterNotification(message);
}

void showFlutterNotification(RemoteMessage message) {
  RedirectViewNotifier.manageNotifications(message);
}

Future<void> initializeFirebase() async {
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();
  // await FirebaseMessaging.instance.getInitialMessage();
  onActionSelected("get_apns_token");
  FirebaseMessaging.onMessage.listen(showFlutterNotification);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> updateFirebaseToken() async {
  onActionSelected("get_apns_token");
}

Future<void> onActionSelected(String value) async {
  switch (value) {
    case 'subscribe':
      {
        print(
          'FlutterFire Messaging Example: Subscribing to topic "fcm_test"',
        );
        await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
        print(
          'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful',
        );
      }
      break;
    case 'unsubscribe':
      {
        print(
          'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test"',
        );
        await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
        print(
          'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful',
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
          user = await mainController.getUserData();

          if (user!.telephone != "" && token != null) {
            var firebaseTokenApi = FirebaseTokenApi(
                phoneNumber: user!.telephone.contains("+34")
                    ? user!.telephone.replaceAll("+34", "")
                    : user!.telephone,
                fcmToken: token);
            print('token fire->' + token);
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

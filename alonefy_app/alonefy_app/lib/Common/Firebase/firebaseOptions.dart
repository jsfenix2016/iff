import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAgl25m_sziseckcMNDOsoHt9vLvPEhYHU',
    appId: '1:509585336823:android:51d1249374216cabe8e6f2',
    messagingSenderId: '509585336823',
    projectId: 'alertfriends-72e7a',
    authDomain: 'flutterfire-e2e-tests.firebaseapp.com',
    //databaseURL:
    //'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'alertfriends-72e7a.appspot.com',
    measurementId: 'G-JN95N1JV2E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgl25m_sziseckcMNDOsoHt9vLvPEhYHU',
    appId: '1:509585336823:android:51d1249374216cabe8e6f2',
    messagingSenderId: '509585336823',
    projectId: 'alertfriends-72e7a',
    storageBucket: 'alertfriends-72e7a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDooSUGSf63Ghq02_iIhtnmwMDs4HlWS6c',
    appId: '1:406099696497:ios:1b423b89c63b82053574d0',
    messagingSenderId: '406099696497',
    projectId: 'flutterfire-e2e-tests',
    databaseURL:
    'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'flutterfire-e2e-tests.appspot.com',
    androidClientId:
    '406099696497-17qn06u8a0dc717u8ul7s49ampk13lul.apps.googleusercontent.com',
    iosClientId:
    '406099696497-irb7edfevfkhi6t5s9kbuq1mt1og95rg.apps.googleusercontent.com',
    iosBundleId: 'io.flutter.plugins.firebase.messaging',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDooSUGSf63Ghq02_iIhtnmwMDs4HlWS6c',
    appId: '1:406099696497:ios:1b423b89c63b82053574d0',
    messagingSenderId: '406099696497',
    projectId: 'flutterfire-e2e-tests',
    databaseURL:
    'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'flutterfire-e2e-tests.appspot.com',
    androidClientId:
    '406099696497-17qn06u8a0dc717u8ul7s49ampk13lul.apps.googleusercontent.com',
    iosClientId:
    '406099696497-irb7edfevfkhi6t5s9kbuq1mt1og95rg.apps.googleusercontent.com',
    iosBundleId: 'io.flutter.plugins.firebase.messaging',
  );
}
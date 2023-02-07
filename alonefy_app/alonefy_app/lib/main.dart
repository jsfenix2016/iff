import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/userPosition.dart';
import 'package:ifeelefine/Model/userpositionbd.dart';
import 'package:ifeelefine/Page/Onboarding/PageView/onboarding_page.dart';
import 'package:ifeelefine/Page/RiskDate/Pageview/riskDatePage.dart';
import 'package:ifeelefine/Page/UserRest/PageView/configurationUserRest_page.dart';
import 'package:ifeelefine/Page/UserRest/PageView/previewRestTime.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Routes/routes.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';
import 'package:ifeelefine/Page/TermsAndConditions/PageView/conditionGeneral_page.dart';
import 'package:ifeelefine/Page/Geolocator/PageView/configGeolocator_page.dart';
import 'package:ifeelefine/Views/alerts_page.dart';
import 'package:ifeelefine/Page/Alternative/Pageview/alternative_page.dart';
import 'package:ifeelefine/Views/configuration2_page.dart';
import 'package:ifeelefine/Views/configuration3_page.dart';
import 'package:ifeelefine/Page/UseMobil/PageView/configurationUseMobile_page.dart';
import 'package:ifeelefine/Page/FallDetected/Pageview/fall_activation_page.dart';
import 'package:ifeelefine/Page/FinishConfig/Pageview/finishConfig_page.dart';
import 'package:ifeelefine/Page/Disamble/Pageview/disambleIfeelfine_page.dart';
import 'package:ifeelefine/Views/geolocatos_test_page.dart';
import 'package:ifeelefine/Views/menuconfig_page.dart';
import 'package:ifeelefine/Page/PermissionUser/Pageview/permission_page.dart';
import 'package:ifeelefine/Views/protectuser_page.dart';
import 'package:ifeelefine/Views/ringtone_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:all_sensors/all_sensors.dart';

final List<UserPosition> tempPosition = <UserPosition>[];
final List<String> tempMovUser = <String>[];
DateTime now = DateTime.now();
// UserPositionBD userMovBD = UserPositionBD(mov: [], time: null);
late UserPosition userMov;
List<double> _accelerometerValues = <double>[];
List<double> _userAccelerometerValues = <double>[];

/// OPTIONAL when use custom notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final List<StreamSubscription<dynamic>> _streamSubscriptions =
    <StreamSubscription<dynamic>>[];

bool _accelAvailable = false;
bool _gyroAvailable = false;
List<double> _accelData = List.filled(3, 0.0);
List<double> _gyroData = List.filled(3, 0.0);
StreamSubscription? _accelSubscription;
StreamSubscription? _gyroSubscription;
Duration dismbleTime = Duration();
final _prefs = PreferenceUser();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  userMov = UserPosition(mov: [], time: now);
  await _prefs.initPrefs();
  await inicializeHiveBD();

  await initializeService();

  String initApp = _prefs.isFirstConfig == false ? 'onboarding' : 'home';

  runApp(
    GetMaterialApp(
      home: MyApp(
        initApp: initApp,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

// void _checkAccelerometerStatus() async {
//   await SensorManager().isSensorAvailable(Sensors.ACCELEROMETER).then((result) {
//     _accelAvailable = result;
//   });
// }

// Future<void> _startAccelerometer() async {
//   if (_accelSubscription != null) return;
//   if (_accelAvailable) {
//     final stream = await SensorManager().sensorUpdates(
//       sensorId: Sensors.ACCELEROMETER,
//       interval: Sensors.SENSOR_DELAY_FASTEST,
//     );
//     _accelSubscription = stream.listen((sensorEvent) {
//       _accelData = sensorEvent.data;
//     });
//   }
// }

// // Register a sensor listener
// void startSensorListen() async {
//   await FlutterSensors.startSensor(Sensor.TYPE_ACCELEROMETER);
//   FlutterSensors.sensorsEvents.listen((event) {
//     int currentTime = DateTime.now().millisecondsSinceEpoch;
//     int lastMovement = await getLastMovement();
//     int timeSinceLastMovement = currentTime - lastMovement;
//     setLastMovement(currentTime);
//     // Log the time since last movement and update the data for the day
//   });
// }

// void backgroundFetchCallback() async {
//   DateTime now = DateTime.now();
//   int dayOfWeek = now.weekday;
//   int lastMovement = await getLastMovement();

//   if(lastMovement == null){
//     // first movement of the day
//     setFirstMovementToday(DateTime.now().millisecondsSinceEpoch);
//   }

//   // check if it is the last movement of the day
//   int currentTime = DateTime.now().millisecondsSinceEpoch;
//   int lastUse = await getLastUse();
//   int timeSinceLastUse = currentTime - lastUse;
//   if (timeSinceLastUse > threshold) {
//     setLastMovementToday(DateTime.now().millisecondsSinceEpoch);
//     // update the data for the day
//     updateDataForTheDay(dayOfWeek);
//   }
//   setLastUse(currentTime);

//   BackgroundFetch.finish();
// }

// Function to update data for the day
// void updateDataForTheDay(int dayOfWeek) {
//     var firstMovementToday = await getFirstMovementToday();
//     var lastMovementToday = await getLastMovementToday();
//     var data = await getData();
//     data[dayOfWeek] = {
//     "firstMovement": firstMovementToday,
//     "lastMovement": lastMovementToday,
//     "cadence": cadence
//   };
//   await setData(data);
// }

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  if (_prefs.getAceptedSendLocation) {
    Geolocator.openAppSettings();
  }
  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    _prefs.setAceptedSendLocation = false;
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      _prefs.setAceptedSendLocation = false;
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    _prefs.setAceptedSendLocation = false;
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.

  return await Geolocator.getCurrentPosition();
}

Future<void> initializeService() async {
  if (_prefs.getEnableIFF == false) {
    Timer(await disambleIFF(_prefs.getDisambleIFF), () {
      _prefs.setEnableIFF = true;
    });

    return;
  }

  if (_prefs.getAceptedSendLocation || _prefs.getDetectedFall) {
    final service = FlutterBackgroundService();
    _determinePosition();

    /// OPTIONAL, using custom notification channel id
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground', // id
      'MY FOREGROUND SERVICE', // title
      description:
          'This channel is used for important notifications.', // description
      playSound: true,
      importance: Importance.low, // importance must be at low or higher level
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_bg_service_small');
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: IOSInitializationSettings());
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      debugPrint('notification payload: $payload');
    });

    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: IOSInitializationSettings(),
        ),
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,

        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'AWESOME SERVICE',
        initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );

    service.startService();
  }
}

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  // display a dialog with the notification details, tap ok to go to another page
}

Future selectNotification(String payload) async {
  if (payload != "") {
    debugPrint('notification payload: $payload');
  }
}
// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

Future<void> showNotifications() async {
  await flutterLocalNotificationsPlugin.show(
    0,
    'Alerta',
    'Detectamos un movimiento brusco,$tempPosition ¿te encuentras bien? ',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'my_foreground',
        'MY FOREGROUND SERVICE',
        icon: 'ic_bg_service_small',
        color: Color.fromARGB(210, 213, 236, 109),
        importance: Importance.max,
        ongoing: true,
        enableLights: true,
        playSound: true,
        enableVibration: true,
        // sound: RawResourceAndroidNotificationSound(
        //     "content://media/internal/audio/media/26.wav"),
      ),
    ),
    payload: 'Notification Payload',
  );
}

void accelerometer() async {
  //Initialization Settings for Android
  if (_prefs.getDetectedFall == false && _prefs.getUserPremium) return;

  _streamSubscriptions.add(
    accelerometerEvents!.listen(
      (AccelerometerEvent event) {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      },
    ),
  );

  _streamSubscriptions.add(
    userAccelerometerEvents!.listen(
      (UserAccelerometerEvent event) {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
        if (event.x >= 5.5 || event.y >= 5.5 || event.z >= 5.5) {
          isMovRude = true;
        } else {
          isMovRude = false;
        }
      },
    ),
  );
}

bool isMovRude = false;
Future<int> saveUserPosition(DateTime user) async {
  await inicializeHiveBD();
  UserPositionBD mov = UserPositionBD(mov: [], time: now, movRureUser: user);
  var id = const HiveData().saveUserPositionBD(mov);

  return id;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  if (_prefs.getEnableIFF == false) {
    Timer(await disambleIFF(_prefs.getDisambleIFF), () {
      _prefs.setEnableIFF = true;
    });

    return;
  }
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (Platform.isAndroid) {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          /// OPTIONAL for use custom notification
          /// the notification id must be equals with AndroidConfiguration when you call configure() method.
          // flutterLocalNotificationsPlugin.show(
          //   888,
          //   'Estas protegido',
          //   'Awesome ${DateTime.now()}',
          //   const NotificationDetails(
          //     android: AndroidNotificationDetails(
          //       'my_foreground',
          //       'MY FOREGROUND SERVICE',
          //       icon: 'ic_bg_service_small',
          //       color: Color.fromARGB(210, 213, 236, 109),
          //       importance: Importance.low,
          //       ongoing: true,
          //       enableLights: true,
          //       playSound: true,
          //       // sound: RawResourceAndroidNotificationSound('slow_spring_board'),
          //     ),
          //   ),
          // );

          if (isMovRude) {
            isMovRude = false;
            tempMovUser.add("Movimiento brusco a $now");
            // _prefs.setListMovUse(tempMovUser);
            showNotifications();
            saveUserPosition(now);
          }
        }
      }
    }
    // accelerometer();

    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
      var id = androidInfo.id;
    }

    // if (Platform.isIOS) {
    //   flutterLocalNotificationsPlugin.show(
    //     888,
    //     'COOL SERVICE',
    //     'Awesome ${DateTime.now()}',
    //     const NotificationDetails(
    //       iOS: IOSNotificationDetails(
    //           subtitle: "HOLA",
    //           presentBadge: false,
    //           threadIdentifier: "my_foreground",
    //           presentAlert: false),
    //     ),
    //   );

    //   final iosInfo = await deviceInfo.iosInfo;
    //   device = iosInfo.model;
    //   // final List<String> accelerometer =
    //   //     _accelerometerValues.map((double v) => v.toStringAsFixed(1)).toList();
    //   // print('Accelerometer: $accelerometer');
    // }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}

class MyApp extends StatefulWidget {
  final String initApp;

  const MyApp({super.key, required this.initApp});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: appRoute,
      initialRoute: widget.initApp,
    );
  }
}

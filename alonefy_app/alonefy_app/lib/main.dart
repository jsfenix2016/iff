import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:all_sensors2/all_sensors2.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Controllers/mainController.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
import 'package:ifeelefine/Model/activitydaybd.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';

import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/Contact/ListContact/PageView/list_contact_page.dart';
import 'package:ifeelefine/Page/Contact/Notice/PageView/contactNotice_page.dart';
import 'package:ifeelefine/Page/Contact/PageView/addContact_page.dart';
import 'package:ifeelefine/Page/Historial/PageView/historial_page.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';

import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';

import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/PageView/riskDatePage.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';
import 'package:ifeelefine/Page/UserConfig2/Page/configuration2_page.dart';
import 'package:ifeelefine/Services/mainService.dart';
import 'package:ifeelefine/Views/contact_page.dart';

import 'package:intl/intl.dart';
import 'package:ifeelefine/Common/idleLogic.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'package:ifeelefine/Model/logAlerts.dart';

import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Routes/routes.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:notification_center/notification_center.dart';
import 'package:onboarding/onboarding.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'Common/Firebase/firebaseManager.dart';

import 'Page/LogActivity/Controller/logActivity_controller.dart';

DateTime now = DateTime.now();
late LogAlerts userMov;
var accelerometerValues = <double>[];
List<double> userAccelerometerValues = <double>[];
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// OPTIONAL when use custom notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final List<StreamSubscription<dynamic>> _streamSubscriptions =
    <StreamSubscription<dynamic>>[];

Duration dismbleTime = const Duration();
PreferenceUser _prefs = PreferenceUser();
FlutterBackgroundService _service = FlutterBackgroundService();
bool ismove = true;
bool timerActive = true;
Timer _timer = Timer(const Duration(seconds: 20), () {});

bool isMovRude = false;
Timer timerSendSMS = Timer(const Duration(seconds: 20), () {});

final LogActivityController logActivityController =
    Get.put(LogActivityController());

final MainController mainController = Get.put(MainController());
int _logActivityTimer = 60;
const int _logActivityTimerRefresh = 60;

String? device;
String? initApp;
UserBD? user;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  userMov = LogAlerts(mov: [], time: now);

  await _prefs.initPrefs();
  await inicializeHiveBD();
  await initializeFirebase();
  await initializeService();

  user = await mainController.getUserData();
  var premiumController = Get.put(PremiumController());

  premiumController.initPlatformState();
// Recupera la última ruta de pantalla visitada
  final lastRoute = await _prefs.getLastScreenRoute();
  initApp = _prefs.isFirstConfig == false ? 'onboarding' : lastRoute;
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    var androidInfo = await deviceInfo.androidInfo;
    device = androidInfo.model;
  }
  runApp(
    GetMaterialApp(
      home: MyApp(
        initApp: initApp!,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

///Esta funcion se utiliza para activar los servicios en segundo plano
///se utilizan las variables getAceptedSendLocation, getDetectedFall para permitir o no su activación.
///VARIABLES: Esta variable sale de preferer donde almacenamos su valor booleano
///getAceptedSendLocation:  indica que el usuario acepto el envio de la ubicacion actual a su contacto
///getDetectedFall:  indica que el usuario acepto la funcionalidad del acelerometro para poder detectar movimientos bruscos
Future activateService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'AlertFriends – PERSONAL PROTECTION 1', // title
    description: 'AlertFriends está activado.', // description
    importance: Importance.high, // importance must be at low or higher level
  );

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
      initialNotificationTitle: 'AlertFriends – PERSONAL PROTECTION 2',
      initialNotificationContent: 'AlertFriends está activado',
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
  // if (_prefs.getAceptedSendLocation || _prefs.getDetectedFall) {
  //   service.startService();
  // } else {
  //   service.invoke("stopService");
  // }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/logo_alertfriends');
  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[];
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      showDialog(
        context: RedirectViewNotifier.context!,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text("title"),
          content: const Text("body"),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RiskPage(),
                  ),
                );
              },
            )
          ],
        ),
      );
    },
    notificationCategories: darwinNotificationCategories,
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          // selectNotificationStream.add(notificationResponse.payload);
          if (notificationResponse.actionId == "Inactived") {
            ismove = false;
            timerActive = true;
            _timer.cancel();
          }
          if (notificationResponse.actionId == "dateRisk") {
            RedirectViewNotifier.onTapNotification(notificationResponse);
          }
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == "helpID") {
            IdleLogic().notifyContact();
            mainController.saveUserLog("Envio de SMS", now);
          }
          if (notificationResponse.actionId == "imgoodId") {
            ismove = false;
            timerActive = true;
            MainService().cancelNotifications();
            _timer.cancel();
          }
          if (notificationResponse.actionId == "date") {
            RedirectViewNotifier.onTapNotification(notificationResponse);
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
}

Future<void> onSelectNotification(String payload) async {
  // Aquí es donde se maneja la redirección cuando el usuario toca la notificación
  // await Navigator.push(context, MaterialPageRoute(builder: (context) => CancelDatePage()));
}

///Funcion utilizada para inicializar el servicio en segundo plano
///Variables:
///getEnableIFF: se utiliza para activar y desactivar el servicio de segundo plano por indicacion del usuario
///getDisambleIFF: se utilizada para asignar el tiempo de duracion de la desactivacion del servicio de proteccion.
Future<void> initializeService() async {
  // _prefs.setEnableIFF = false;
  if (_prefs.getEnableIFF == false) {
    var isRunning = await _service.isRunning();
    if (isRunning) {
      _service.invoke("stopService");
      for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
        subscription.cancel();
      }
    }

    Timer(await IdleLogic().convertStringToDuration(_prefs.getDisambleIFF), () {
      _prefs.setEnableIFF = true;
      _service.startService();
    });

    return;
  }
  activateService();
}

///Funcion utilizada para el momento de detectar que la app esta en segundo plano y activar o invocar el servicio.
///Variables:
///isMovRude: valor booleano para asignar si se detecto un movimiento brusco en el dispositivo y proceder a notificar de dicho movimiento.
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  await _prefs.initPrefs();
  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

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
  accelerometer();
  // bring to foreground
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (Platform.isAndroid) {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          if (isMovRude) {
            isMovRude = false;
          }
        }
      }
    }

    _logActivityTimer += 5;
    getDateRisk();

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

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

Future accelerometer() async {
  //Initialization Settings for Android
  await _prefs.initPrefs();

  if (_prefs.getDetectedFall == false && _prefs.getUserPremium == false) return;

  _streamSubscriptions.add(
    accelerometerEvents!.listen((AccelerometerEvent event) {
      double accelerationMagnitude =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (accelerationMagnitude > 19) {
        isMovRude = true;
        print("movimiento rudo $accelerationMagnitude");
        if (user != null) {
          MainService().saveDrop(user!);
        }

        RedirectViewNotifier.showNotifications();
        mainController.saveUserLog("Movimiento rudo a ", now);
      } else {
        isMovRude = false;
        if (accelerationMagnitude < 19 && accelerationMagnitude > 10) {
          print("me movi");
          if (_logActivityTimer >= _logActivityTimerRefresh) {
            print("Movimiento normal");
            mainController.saveActivityLog(DateTime.now(), "Movimiento normal");
            _logActivityTimer = 0;
          }
          ismove = false;
          timerActive = true;
          _timer.cancel();
        } else {
          activatedTimerInactivity();
        }
      }
    }),
  );
}

Future getDateRisk() async {
  await inicializeHiveBD();
  final user = await const HiveData().getuserbd;

  final box = await const HiveDataRisk().getcontactRiskbd;

  List<ContactRiskBD> dateRisk = box.toList();

  if (dateRisk.isEmpty) {
    return;
  }

  for (var element in dateRisk) {
    DateTime start = parseDurationRow(element.timeinit);
    DateTime end = parseDurationRow(element.timefinish);

    RedirectViewNotifier.contactRisk = element;

    if (now.hour.compareTo(start.hour) == 0 &&
        now.minute.compareTo(start.minute) > 0) {
      if (element.isActived == false && element.isFinishTime == false) {
        element.isActived = true;
        element.isprogrammed = false;
        await const HiveDataRisk().updateContactRisk(element);
        RedirectViewNotifier.showDateNotifications();
      } else {
        print(
            "ahora: ${now.hour}:${now.minute}, hora fin: ${end.hour}:${end.minute},isActived: ${element.isActived}");
        if ((now.hour.compareTo(end.hour) == 0 &&
                now.minute.compareTo(end.minute) >= 0) &&
            element.isActived) {
          if (element.isActived && element.isFinishTime == false) {
            element.isActived = true;
            element.isprogrammed = false;
            element.isFinishTime = true;
            await const HiveDataRisk().updateContactRisk(element);
            RedirectViewNotifier.sendMessageContactDate(element);
            RedirectViewNotifier.showDateFinishNotifications();
          }
        }
      }
      NotificationCenter().notify('getContactRisk');
    }
  }
}

///Esta funcion se encarga de verificar los tiempo de inactividad y descanso que ha proporsionado el usuario en la configuracion
///Variables:
///timerActive: Se utiliza para verificar si el usuario
Future activatedTimerInactivity() async {
  ///Funcion utilizada para inicializar la base de datos esto se vuelve a
  ///inicializar debido a que si la app esta en segundo plano la primera inicializacion se borra
  ///asi evitamos que la app se rompa al momento de consultar la base de datos.
  await inicializeHiveBD();
  var format = DateFormat("HH:mm");

  //Revisamos si tenemos alguna cita y procesamos la información para notificar a los contactos

  ///Consultamos en la base de datos las actividades o inactividad del usuario
  List<ActivityDayBD> listActividad =
      await const HiveData().listUserActivitiesbd;

  ///Consultamos en la base de datos las horas de descanso del usuario
  List<RestDayBD> listRest = await const HiveData().listUserRestDaybd;

  ///Utilizamos el IdleLogic().whatDayIs() para verificar con el DateTime.now el dia actual y
  ///lo convertimos de numero a dia de la semana (Lunes, Martes, etc..).
  var day = IdleLogic().whatDayIs();

  for (var element in listActividad) {
    DateTime start = format.parse(element.timeStart);
    DateTime end = format.parse(element.timeFinish);
    if (day == element.day &&
        now.hour.compareTo(start.hour) == 0 &&
        now.hour.compareTo(end.hour) <= 1) {
      return;
    }
  }

  for (var element in listRest) {
    DateTime start = parseDuration(element.timeSleep);
    DateTime end = parseDuration(element.timeWakeup);

    if (day == element.day &&
        now.hour.compareTo(start.hour) == 0 &&
        now.hour.compareTo(end.hour) <= 1) {
      return;
    } else if (day == element.day &&
        now.hour.compareTo(start.hour) == 0 &&
        now.hour.compareTo(end.hour) == 1 &&
        now.hour.compareTo(end.minute) <= 1) {}
  }

  if (timerActive) {
    timerActive = false;
    Duration useMobil = await IdleLogic().convertStringToDuration("5 min");
    _timer = Timer(useMobil, () {
      timerActive = false;

      RedirectViewNotifier.showNotifications();
      mainController.saveUserLog("Inactividad ", now);
      mainController.saveActivityLog(DateTime.now(), "Inactividad");
    });
  }
}

void sendMessageContact() async {
  Duration useMobil =
      await IdleLogic().convertStringToDuration(_prefs.getHabitsTime);
  timerSendSMS = Timer(useMobil, () {
    timerActive = false;

    IdleLogic().notifyContact();
    mainController.saveUserLog("Envio de SMS a contacto ", now);
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

    FirebaseMessaging.onMessage.listen(showFlutterNotification);
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

Future<Position> determinePosition() async {
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

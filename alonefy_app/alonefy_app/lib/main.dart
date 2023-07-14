import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
// import 'package:all_sensors2/all_sensors2.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Controllers/mainController.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';

import 'package:ifeelefine/Model/userbd.dart';

import 'package:ifeelefine/Page/RestoreMyConfiguration/Controller/restoreController.dart';

import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/PageView/riskDatePage.dart';
import 'package:ifeelefine/Services/mainService.dart';

import 'package:ifeelefine/Common/idleLogic.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logAlerts.dart';

import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Routes/routes.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'Common/Firebase/firebaseManager.dart';

import 'Page/Geolocator/Controller/configGeolocatorController.dart';
import 'Page/LogActivity/Controller/logActivity_controller.dart';
import 'Page/Premium/Controller/premium_controller.dart';
import 'Page/UserEdit/Controller/getUserController.dart';

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

bool ismove = true;
bool timerActive = true;

bool isMovRude = false;
Timer timerSendSMS = Timer(const Duration(seconds: 20), () {});

final LogActivityController logActivityController =
    Get.put(LogActivityController());

final MainController mainController = Get.put(MainController());
int _logActivityTimer = 60;
int _logRudeMovementTimer = 60;
const int _logActivityTimerRefresh = 60;
const int _logRudeMovementTimerRefresh = 60;

final _locationController = Get.put(ConfigGeolocatorController());

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

  if (user != null) {
    var userApi = await GetUserController().getUser(user!.telephone);

    if (userApi != null && userApi.idUser != user!.idUser) {
      await RestoreController().deleteAllData();

      user = null;
    }
  }

  var premiumController = Get.put(PremiumController());
  _prefs.setDemoActive = false;
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
    'AlertFriends – PERSONAL PROTECTION', // title
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
      initialNotificationTitle: 'AlertFriends – PERSONAL PROTECTION',
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

  if (_prefs.getAcceptedNotification == PreferencePermission.allow ||
      _prefs.getDetectedFall ||
      _prefs.getAcceptedSendLocation == PreferencePermission.allow) {
    service.startService();
  } else {
    service.invoke("stopService");
  }

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
            String taskIds =
                notificationResponse.actionId!.replaceAll("Inactived_", "");
            var taskIdList = getTaskIdList(taskIds);
            MainService().cancelAllNotifications(taskIdList);
          }
          if (notificationResponse.actionId != null &&
              notificationResponse.actionId!.contains("DateRisk")) {
            String taskIds = notificationResponse.actionId!
                .substring(0, notificationResponse.actionId!.indexOf('id='));
            taskIds = taskIds.replaceAll("DateRisk_", "");
            String id = notificationResponse.actionId!.substring(
                notificationResponse.actionId!.indexOf('id='),
                notificationResponse.actionId!.length);
            id = id.replaceAll("id=", "");

            var taskIdList = getTaskIdList(taskIds);
            RedirectViewNotifier.onTapNotification(
                notificationResponse, taskIdList, int.parse(id));
          }
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId != null &&
              notificationResponse.actionId!.contains("helpID")) {
            String taskIds =
                notificationResponse.actionId!.replaceAll("helpID_", "");
            var taskIdList = getTaskIdList(taskIds);
            MainService().sendAlertToContactImmediately(taskIdList);
          }
          if (notificationResponse.actionId != null &&
              notificationResponse.actionId!.contains("imgoodId")) {
            String taskIds =
                notificationResponse.actionId!.replaceAll("imgoodId_", "");
            var taskIdList = getTaskIdList(taskIds);
            ismove = false;
            timerActive = true;
            MainService().cancelAllNotifications(taskIdList);
          }
          if (notificationResponse.actionId != null &&
              notificationResponse.actionId!.contains("dateHelp")) {
            String taskIds =
                notificationResponse.actionId!.replaceAll("dateHelp_", "");
            var taskIdList = getTaskIdList(taskIds);
            MainService().sendAlertToContactImmediately(taskIdList);
          }
          if (notificationResponse.actionId != null &&
              notificationResponse.actionId!.contains("dateImgood")) {
            String taskIds = notificationResponse.actionId!
                .substring(0, notificationResponse.actionId!.indexOf('id='));
            taskIds = taskIds.replaceAll("dateImgood_", "");
            String id = notificationResponse.actionId!.substring(
                notificationResponse.actionId!.indexOf('id='),
                notificationResponse.actionId!.length);
            id = id.replaceAll("id=", "");

            var taskIdList = getTaskIdList(taskIds);
            RedirectViewNotifier.onTapNotification(
                notificationResponse, taskIdList, int.parse(id));
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
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
  activateService();
}

///Funcion utilizada para el momento de detectar que la app esta en segundo plano y activar o invocar el servicio.
///Variables:
///isMovRude: valor booleano para asignar si se detecto un movimiento brusco en el dispositivo y proceder a notificar de dicho movimiento.
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  await inicializeHiveBD();
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
    _logRudeMovementTimer += 5;
    //getDateRisk();

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });

  Timer.periodic(const Duration(minutes: 2), (timer) async {
    sendLocation();
  });

  Timer.periodic(const Duration(hours: 6), (timer) async {
    updateFirebaseToken();
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

  var enableIFF = await getEnableIFF();

  if (!enableIFF && !_prefs.getDetectedFall && !_prefs.getUserPremium) return;

  _streamSubscriptions.add(
    accelerometerEvents.listen((AccelerometerEvent event) {
      double accelerationMagnitude =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (accelerationMagnitude > 21) {
        isMovRude = true;
        print("movimiento rudo $accelerationMagnitude");
        if (_logRudeMovementTimer >= _logRudeMovementTimerRefresh) {
          mainController.saveDrop();
          _logRudeMovementTimer = 0;
        }
      } else {
        isMovRude = false;
        if (accelerationMagnitude < 21 && accelerationMagnitude > 10) {
          print("me movi");
          if (_logActivityTimer >= _logActivityTimerRefresh) {
            print("Movimiento normal");
            mainController.saveActivityLog(DateTime.now(), "Movimiento normal");
            _logActivityTimer = 0;
          }
          ismove = false;
          timerActive = true;
        }
      }
    }),
  );
}

/*Future getDateRisk() async {
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
        //RedirectViewNotifier.showDateNotifications();
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
            //RedirectViewNotifier.showDateFinishNotifications();
          }
        }
      }
      NotificationCenter().notify('getContactRisk');
    }
  }
}*/

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

void sendLocation() async {
  //PermissionStatus permission = await Permission.location.request();

  //if (permission.isPermanentlyDenied) {
  //  _locationController.activateLocation(PreferencePermission.deniedForever);
  //  showPermissionDialog(RedirectViewNotifier.context!, Constant.enablePermission);
  //} else if (permission.isDenied) {
  //  _locationController.activateLocation(PreferencePermission.denied);
  //} else {
  //  if (_prefs.getAcceptedSendLocation != PreferencePermission.allow) {
  //    _locationController.activateLocation(PreferencePermission.allow);
  //  }
  //  var position = await determinePosition();
  //  _locationController.sendLocation(position.latitude.toString(), position.longitude.toString());
  //}

  if (_prefs.getAcceptedSendLocation == PreferencePermission.allow) {
    var position = await determinePosition();
    _locationController.sendLocation(
        position.latitude.toString(), position.longitude.toString());
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  return await Geolocator.getCurrentPosition();
}

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'dart:math';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Page/Contact/PageView/addContact_page.dart';
import 'package:ifeelefine/Page/EditUseMobil/Page/editUseMobil.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:ifeelefine/Page/UseMobil/PageView/configurationUseMobile_page.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';
import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';
import 'package:ifeelefine/Page/UserRest/PageView/configurationUserRest_page.dart';
import 'package:ifeelefine/Views/menuconfig_page.dart';

import 'package:notification_center/notification_center.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sensors_plus/sensors_plus.dart';

import 'package:geolocator/geolocator.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Controllers/mainController.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';

import 'package:ifeelefine/Model/userbd.dart';

import 'package:ifeelefine/Page/RestoreMyConfiguration/Controller/restoreController.dart';

import 'package:ifeelefine/Services/mainService.dart';

import 'package:ifeelefine/Common/idleLogic.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logAlerts.dart';

import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Routes/routes.dart';

import 'package:flutter/material.dart';

import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/src/date_time.dart';

import 'Common/Firebase/firebaseManager.dart';

import 'Page/Geolocator/Controller/configGeolocatorController.dart';
import 'Page/LogActivity/Controller/logActivity_controller.dart';
import 'Page/Premium/Controller/premium_controller.dart';

import 'Page/UserEdit/Controller/getUserController.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

DateTime now = DateTime.now();

var accelerometerValues = <double>[];
List<double> userAccelerometerValues = <double>[];
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// OPTIONAL when use custom notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final service = FlutterBackgroundService();
final List<StreamSubscription<dynamic>> _streamSubscriptions =
    <StreamSubscription<dynamic>>[];

Duration dismbleTime = const Duration();
PreferenceUser _prefs = PreferenceUser();

bool ismove = true;
bool timerActive = true;

bool isMovRude = false;

bool notActionPush = false;
String idTask = "";
List<String> listTask = [];
RxList<String> rxlistTask = [''].obs;
RxString rxIdTask = ''.obs;
RxString name = "".obs;

final countTimer = RxInt(60);
Timer timerSendSMS = Timer(const Duration(seconds: 20), () {});
Timer timerSendDropNotification = Timer(const Duration(minutes: 5), () {});
Timer desactivedtimerSendDropNotification =
    Timer(const Duration(seconds: 10), () {});
Timer timerSendLocation = Timer(const Duration(seconds: 15), () {});

Timer timerTempDown = Timer(const Duration(seconds: 1), () {});
int countdown = 300;

final MainController mainController = Get.put(MainController());
int _logActivityTimer = 0;
int _logRudeMovementTimer = 20;
const int _logActivityTimerRefresh = 60;
const int _logRudeMovementTimerRefresh = 20;
int increaceTimerDisamble = 0;
int increaceSendLocations = 0;
int increaceUpdateFirebase = 0;
final _locationController = Get.put(ConfigGeolocatorController());

String? device;
String? initApp;
UserBD? user;
int time = 120;
int timeRevert = 300;
double timeUpdateFirebase = (36000);
double timeSendlocation = (120);
List<bool> menuConfig = [
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  false,
  false,
  false,
  false
];

List<MenuConfigModel> permissionStatusI = [
  MenuConfigModel(
      "Configurar tus datos", 'assets/images/VectorUser.png', 22, 19.25, true),
  MenuConfigModel("Configurar tiempo de sueño", 'assets/images/EllipseMenu.png',
      22, 22, true),
  MenuConfigModel(
      "Configurar tiempo uso", 'assets/images/Group 1084.png', 22, 16.93, true),
  MenuConfigModel(
      "Actividades", 'assets/images/Group 1084.png', 22, 16.93, true),
  MenuConfigModel("Seleccionar contacto de aviso",
      'assets/images/Group 1083.png', 22, 25.52, true),
  MenuConfigModel(
      "Configurar caída", 'assets/images/Group 506.png', 26, 22.76, true),
  MenuConfigModel(
      "Cambiar envío ubicación", 'assets/images/Group 1082.png', 24, 24, true),
  MenuConfigModel("Cambiar tiempo notificaciónes",
      'assets/images/Group 1099.png', 22, 17.15, true),
  MenuConfigModel("Cambiar sonido notificaciones",
      'assets/images/Group 1102.png', 22, 22.08, false),
  MenuConfigModel(
      "Ajustes de mi smartphone", 'assets/images/mobile.png', 22, 19.66, false),
  MenuConfigModel("Restaurar mi configuración", 'assets/images/Vector-2.png',
      22, 22, false),
  MenuConfigModel("Desactivar mi instalación", 'assets/images/Group 533.png',
      21, 17, false),
];

final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

List<Contact> contactlist = [];
List<String> taskdIds = [];
bool isCancelZone = true;

int secondsRemaining = 60; //5 minutes = 300 seconds
const platform = MethodChannel('custom_notification');

Timer? timerCancelZone;
TZDateTime? datetime;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _prefs.initPrefs();
  _prefs.setProtected =
      'AlertFriends está activada y estamos comprobando que te encuentres bien';

  datetime = await mainConvertTimeTZ(1);

  await inicializeHiveBD();
  await initializeFirebase();
  await activateService();
  _prefs.setNameZone = await locateZone();

  user = await mainController.getUserData();

  if (user != null && user!.idUser != '-1') {
    var userApi = await GetUserController().getUser(
        user!.telephone.contains('+34')
            ? user!.telephone.replaceAll("+34", "")
            : user!.telephone);
    name.value = user!.name;

    // _prefs.setUserFree = true;
    // _prefs.setUserPremium = false;
    // var premiumController = Get.put(PremiumController());
    // premiumController.updatePremiumAPI(true);
    if (userApi != null && userApi.idUser != user!.idUser) {
      await RestoreController().deleteAllData();

      user = null;
    }
  }

  Get.put(PremiumController()).initPlatformState();
// Recupera la última ruta de pantalla visitada
  final lastRoute = await _prefs.getLastScreenRoute();
  initApp = _prefs.isFirstConfig == false ? 'onboarding' : lastRoute;

  _prefs.setHabitsEnable = false;
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await requestPermission(Permission.notification);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          // Esta función se ejecutará cuando se toque cualquier parte de la aplicación.

          starTap();
        },
        child: MyApp(
          initApp: initApp!,
        ),
      ),
    ),
  );
}

Future<void> startCustomNotification() async {
  try {
    await platform.invokeMethod('startCustomNotification');
  } on PlatformException catch (e) {
    print("Error: ${e.message}");
  }
}

void starTap() {
  if (timerSendLocation.isActive) {
    print('timer active ${timerSendLocation.isActive}');
    timerSendLocation.cancel();
  }
  timerSendLocation = Timer(const Duration(seconds: 15), () {
    print('Movimiento normal');
    mainController.saveActivityLog(DateTime.now(), "Movimiento normal");
    timerSendLocation.cancel();
  });
}

///Esta funcion se utiliza para activar los servicios en segundo plano
///se utilizan las variables getAceptedSendLocation, getDetectedFall para permitir o no su activación.
///VARIABLES: Esta variable sale de preferer donde almacenamos su valor booleano
///getAceptedSendLocation:  indica que el usuario acepto el envio de la ubicacion actual a su contacto
///getDetectedFall:  indica que el usuario acepto la funcionalidad del acelerometro para poder detectar movimientos bruscos
Future<void> activateService() async {
  var textDescrip =
      'AlertFriends está activada y estamos comprobando que te encuentres bien';

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    "my_foreground", // id
    'AlertFriends – Personal Protection', // title
    description:
        'AlertFriends está activada y estamos comprobando que te encuentres bien.', // description
    importance: Importance.max, // importance must be at low or higher level
    playSound: true,
    showBadge: false,
    enableLights: true,
    // sound: RawResourceAndroidNotificationSound(sound)
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: "my_foreground",
      initialNotificationTitle: 'AlertFriends – Personal Protection',
      initialNotificationContent: textDescrip,
      foregroundServiceNotificationId: 788,
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

  // if (_prefs.getAcceptedNotification == PreferencePermission.allow ||
  //     _prefs.getDetectedFall ||
  //     _prefs.getAcceptedSendLocation == PreferencePermission.allow) {
  service.startService();
  // }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_bg_service_small');

  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          '90',
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
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
      onDidReceiveBackgroundNotificationResponse(notificationResponse);
    },
    onDidReceiveBackgroundNotificationResponse:
        onDidReceiveBackgroundNotificationResponse,
  );

  final details =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (details != null && details.didNotificationLaunchApp) {
    print("object ${details.notificationResponse!.payload}");
    await inicializeHiveBD();
    await _prefs.initPrefs();
    onDidReceiveBackgroundNotificationResponse(details.notificationResponse!);
  }
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse notificationResponse) async {
  mainController.saveActivityLog(DateTime.now(), "Movimiento normal");
  _logRudeMovementTimer = 0;

  switch (notificationResponse.notificationResponseType) {
    case NotificationResponseType.selectedNotification:
      if (notificationResponse.payload!.contains('ContactResponse')) {
        NotificationCenter().notify('getContact');
      }
      if (notificationResponse.payload!.contains("free")) {
        RedirectViewNotifier.onTapFreeNotification(notificationResponse);
      }
      if (notificationResponse.payload!.contains("premium")) {
        RedirectViewNotifier.onTapPremiumNotification(notificationResponse);
      }
      if (notificationResponse.payload!.contains("Drop_")) {
        ismove = false;
        timerActive = true;
        String taskIds = notificationResponse.payload!.replaceAll("Drop_", "");
        var taskIdList = getTaskIdList(taskIds);
        idTask = taskIds;
        rxIdTask.value = taskIds;
        rxlistTask.value = taskIdList;
        listTask = taskIdList;
        notActionPush = true;

        RedirectViewNotifier.onTapNotificationBody(
            notificationResponse, taskIdList);
        // MainService().cancelAllNotifications(taskIdList);
        await flutterLocalNotificationsPlugin.cancel(notificationResponse.id!);
      }
      if (notificationResponse.payload!.contains("Inactived_")) {
        ismove = false;
        timerActive = true;
        _prefs.setEnableIFF = true;

        _prefs.setDisambleIFF = "0 hora";
        String taskIds =
            notificationResponse.payload!.replaceAll("Inactived_", "");
        var taskIdList = getTaskIdList(taskIds);
        idTask = taskIds;
        listTask = taskIdList;
        rxIdTask.value = taskIds;
        rxlistTask.value = taskIdList;
        notActionPush = true;

        RedirectViewNotifier.onTapNotificationBody(
            notificationResponse, taskIdList);
        // RedirectViewNotifier.showAlertDialog(taskIds, taskIdList);
        // MainService().cancelAllNotifications(taskIdList);
        await flutterLocalNotificationsPlugin.cancel(notificationResponse.id!);
      }
      if (notificationResponse.actionId == "Inactived") {
        ismove = false;
        timerActive = true;
        String taskIds =
            notificationResponse.actionId!.replaceAll("Inactived_", "");
        var taskIdList = getTaskIdList(taskIds);

        MainService().cancelAllNotifications(taskIdList);
      }
      if (notificationResponse.payload!.contains("DateRisk_")) {
        String taskIds =
            notificationResponse.payload!.replaceAll("DateRisk_", "");
        _prefs.saveLastScreenRoute("cancelDate");
        // NotificationCenter().notify('getContactRisk');
        var taskIdList = getTaskIdList(taskIds);
        idTask = taskIds;
        listTask = taskIdList;
        rxIdTask.value = taskIds;
        rxlistTask.value = taskIdList;
        notActionPush = true;
        var contactRisk = await const HiveDataRisk().getcontactRiskbd;
        for (var element in contactRisk) {
          if (element.isActived && element.isFinishTime) {
            RedirectViewNotifier.onTapNotification(
                notificationResponse, taskIdList, (element.id));
          }
        }
        await flutterLocalNotificationsPlugin.cancel(notificationResponse.id!);
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

        await flutterLocalNotificationsPlugin.cancel(notificationResponse.id!);
      }
      if (notificationResponse.actionId != null &&
          notificationResponse.actionId!.contains("dateHelp")) {
        String taskIds =
            notificationResponse.actionId!.replaceAll("dateHelp_", "");
        var taskIdList = getTaskIdList(taskIds);
        NotificationCenter().notify('getContactRisk');

        MainService().sendAlertToContactImmediately(taskIdList);
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
        NotificationCenter().notify('getContactRisk');
        var taskIdList = getTaskIdList(taskIds);
        RedirectViewNotifier.onTapNotification(
            notificationResponse, taskIdList, int.parse(id));
      }
      if (notificationResponse.actionId!.contains("premium")) {
        RedirectViewNotifier.onTapPremiumNotification(notificationResponse);
      }
      if (notificationResponse.actionId!.contains("ok")) {
        RedirectViewNotifier.onTapFreeNotification(notificationResponse);
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
        // NotificationCenter().notify('getContactRisk');
        var taskIdList = getTaskIdList(taskIds);
        RedirectViewNotifier.onTapNotification(
            notificationResponse, taskIdList, int.parse(id));
      }

      break;
  }
}

Future<TZDateTime> mainConvertTimeTZ(int hour) async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  // tz.setLocalLocation(tz.getLocation(timeZoneName));
  final TZDateTime now = TZDateTime.now(tz.getLocation(timeZoneName));

  TZDateTime scheduleDate =
      TZDateTime(tz.local, now.year, now.month, now.day, 0, hour);

  return scheduleDate;
}

tz.TZDateTime _nextInstanceOfTenAM() {
  tz.initializeTimeZones();
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, now.hour, now.minute + 1, 30);
  print(scheduledDate);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(minutes: 1));
  }
  return scheduledDate;
}

// Inicializar el ID de la notificación
int notificationId = 1110;
StreamController<String> notificationContentController =
    StreamController<String>();

// void updateNotification(String updatedContent) async {
//   await flutterLocalNotificationsPlugin.show(
//     notificationId,
//     'Título',
//     updatedContent,
//     const NotificationDetails(
//         android: AndroidNotificationDetails(
//       'full screen channel id',
//       'full screen channel name',
//       channelDescription: 'full screen channel description',
//       priority: Priority.max,
//       importance: Importance.high,
//       playSound: false,
//       onlyAlertOnce: true,
//       enableVibration: false,
//     )),
//     payload: 'notification payload',
//   );
// }

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
  /// OPTIONAL when use custom notification

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

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (Platform.isAndroid) {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          if (isMovRude) {}

          // flutterLocalNotificationsPlugin.show(
          //   888,
          //   'COOL SERVICE',
          //   'Awesome ${DateTime.now()}',
          //   const NotificationDetails(
          //     android: AndroidNotificationDetails(
          //         'my_foreground', 'MY FOREGROUND SERVICE',
          //         icon: 'ic_bg_service_small',
          //         ongoing: true,
          //         importance: Importance.high),
          //   ),
          // );

          // // if you don't using custom notification, uncomment this
          // service.setForegroundNotificationInfo(
          //   title: "My App Service",
          //   content: "Updated at ${DateTime.now()}",
          // );
        }
      }
    }

    var timeGetDisamble = _prefs.getDisambleIFF;
    var timeDisamble = deactivateTimeToMinutes(timeGetDisamble) * 60;
    print(timer.tick.toString());
    if (!timeDisamble.isEqual(0)) {
      if (increaceTimerDisamble >= timeDisamble) {
        _prefs.setEnableIFF = true;
        increaceTimerDisamble = 0;
        _prefs.setDisambleIFF = "0 hora";
      }
    }

    Timer.periodic(
      const Duration(days: 30),
      (timer) {
        _prefs.refreshData();
        if (_prefs.getUsedFreeDays == false &&
            _prefs.getDayFree != "0" &&
            _prefs.getUserFree) {
          DateTime dateTime = DateTime.parse(_prefs.getDayFree);

          DateTime fechaActual = DateTime.now();

          // Calcular la diferencia entre las fechas en días
          int diferenciaEnDias = fechaActual.difference(dateTime).inDays;

          // Verificar si han pasado 30 días
          bool hanPasado30Dias = diferenciaEnDias >= 30;

          if (hanPasado30Dias) {
            _prefs.setUsedFreeDays = true;
            _prefs.setUserFree = true;
            _prefs.setUserPremium = false;
            _prefs.setDayFree = "0";
            var premiumController = Get.put(PremiumController());
            premiumController.updatePremiumAPI(false);
          }
        }
      },
    );

    // Timer.periodic(
    //   const Duration(days: 3),
    //   (timer) {
    //     if (_prefs.getUserFree && !_prefs.getUserPremium) {
    //       if (_prefs.getUsedFreeDays) {
    //         RedirectViewNotifier.showPremiumNotification();
    //       } else {
    //         RedirectViewNotifier.showFreeeNotification();
    //       }
    //     }
    //   },
    // );

    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //     0,
    //     'scheduled title',
    //     'scheduled body',
    //     _nextInstanceOfTenAM(),
    //     const NotificationDetails(
    //         android: AndroidNotificationDetails(
    //             'full screen channel id', 'full screen channel name',
    //             channelDescription: 'full screen channel description',
    //             priority: Priority.high,
    //             importance: Importance.high,
    //             fullScreenIntent: true)),
    //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime);

    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   100,
    //   'Cuenta Regresiva',
    //   'Tiempo restante: ${secondsRemaining ~/ 60}:${(secondsRemaining % 60).toString().padLeft(2, '0')}',
    //   _nextInstanceOfTenAM(),
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //         'my_foreground', 'MY FOREGROUND SERVICE',
    //         icon: 'ic_bg_service_small',
    //         ongoing: false,
    //         priority: Priority.high,
    //         importance: Importance.high,
    //         playSound: false),
    //   ),
    //   payload: 'notification payload',
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    //   matchDateTimeComponents: DateTimeComponents.time,
    // );

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (Platform.isAndroid) {
        if (service is AndroidServiceInstance) {
          if (await service.isForegroundService()) {
            var timerTemp = timeRevert - 1;
            // flutterLocalNotificationsPlugin.show(
            //   888,
            //   'COOL SERVICE',
            //   'Awesome ${timerTemp}',
            //   const NotificationDetails(
            //     android: AndroidNotificationDetails(
            //         'my_foreground', 'MY FOREGROUND SERVICE',
            //         icon: 'ic_bg_service_small',
            //         ongoing: false,
            //         priority: Priority.high,
            //         importance: Importance.high,
            //         playSound: false),
            //   ),
            // );
          }
        }
      }
    });

    if (increaceUpdateFirebase >= timeUpdateFirebase) {
      updateFirebaseToken();
      increaceUpdateFirebase = 0;
    }
    if (increaceSendLocations >= timeSendlocation) {
      sendLocation();
      increaceSendLocations = 0;
    }
    increaceUpdateFirebase += 5;
    increaceSendLocations += 5;
    increaceTimerDisamble += 5;
    _logActivityTimer += 5;
    _logRudeMovementTimer += 5;
  });
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

// Future<void> movimientoBrusco() async {
//   await _prefs.initPrefs();
//   await _prefs.refreshData();
//   var enableIFF = await getEnableIFF();

//   if (_prefs.getUserFree) return;
//   if (enableIFF && !_prefs.getDetectedFall && !_prefs.getUserPremium) return;

//   if (_logRudeMovementTimer >= _logRudeMovementTimerRefresh) {
//     mainController.saveDrop();
//     _logRudeMovementTimer = 0;
//   }
// }

// Future<void> movimientoNormal() async {
//   await _prefs.initPrefs();
//   await _prefs.refreshData();
//   var enableIFF = await getEnableIFF();

//   if (_prefs.getUserFree) return;
//   if (enableIFF && !_prefs.getDetectedFall && !_prefs.getUserPremium) return;

//   if (_logRudeMovementTimer >= _logRudeMovementTimerRefresh) {
//     mainController.saveDrop();
//     _logRudeMovementTimer = 0;
//   }
// }

// List<double> accelerationHistory = [];
// Timer? fallDetectionTimer;

// void onData(double accelerationMagnitude) {
//   // Agregar el nuevo valor a la lista de historial
//   accelerationHistory.add(accelerationMagnitude);

//   // Mantener un límite en el tamaño del historial (por ejemplo, 10 elementos)
//   if (accelerationHistory.length > 10) {
//     accelerationHistory.removeAt(0);
//   }

//   // Verificar si se ha alcanzado el límite de aceleración para considerarlo una caída
//   if (accelerationMagnitude >= 45) {
//     print('Movimiento brusco');
//     // Iniciar el temporizador de detección de caídas
//     if (fallDetectionTimer == null) {
//       fallDetectionTimer = Timer(Duration(seconds: 15), () {
//         // Notificar la caída después del tiempo especificado
//         notifyFall();
//       });
//     }
//   } else if (fallDetectionTimer != null) {
//     // Si la aceleración ha disminuido después de una posible caída,
//     // cancelar el temporizador de detección de caídas
//     if (isAccelerationDecreasing()) {
//       fallDetectionTimer?.cancel();
//       fallDetectionTimer = null;
//     }
//   }
// }

// bool isAccelerationDecreasing() {
//   // Verificar si la aceleración está disminuyendo en los últimos valores del historial
//   if (accelerationHistory.length >= 2) {
//     final lastIndex = accelerationHistory.length - 1;
//     final secondToLastIndex = accelerationHistory.length - 2;
//     return accelerationHistory[lastIndex] <
//         accelerationHistory[secondToLastIndex];
//   }
//   return false;
// }

// void notifyFall() {
//   // Aquí puedes implementar la notificación de caída
//   // Restablecer el historial y el temporizador después de notificar
//   accelerationHistory.clear();
//   fallDetectionTimer = null;
//   mainController.saveDrop();
// }

void accelerometer() async {
  //Initialization Settings for Android
  await _prefs.initPrefs();

  _streamSubscriptions.add(
    accelerometerEvents.listen(
      (AccelerometerEvent event) {
        double accelerationMagnitude =
            sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
        _prefs.refreshData();
        // onData(accelerationMagnitude);
        if (accelerationMagnitude > 25) {
          isMovRude = true;
          print('_prefs.getUserFree ${_prefs.getUserFree}');
          print('_prefs.getDetectedFall ${_prefs.getDetectedFall}');
          print('_prefs.getEnableIFF ${_prefs.getEnableIFF}');
          if (_prefs.getUserFree) return;
          if (_prefs.getDetectedFall == false) return;
          if (_prefs.getEnableIFF == false) return;

          if (_logRudeMovementTimer >= _logRudeMovementTimerRefresh) {
            mainController.saveDrop();
            _logRudeMovementTimer = 0;
          }
        } else {
          if (isMovRude) {
            desactivedtimerSendDropNotification =
                Timer(const Duration(seconds: 20), () async {
              isMovRude = false;
              desactivedtimerSendDropNotification.cancel();
            });
            return;
          }
          if (accelerationMagnitude < 45 && accelerationMagnitude > 12) {
            if (_prefs.getEnableIFF &&
                _logActivityTimer >= _logActivityTimerRefresh) {
              if (_prefs.getUseMobilConfig) {
                print('Movimiento normal');
                mainController.saveActivityLog(
                    DateTime.now(), "Movimiento normal");
                isMovRude = false;
              }
              _logActivityTimer = 0;
            }

            ismove = false;
            timerActive = true;
          }
        }
      },
    ),
  );
}

// void sendMessageContact() async {
//   Duration useMobil =
//       await IdleLogic().convertStringToDuration(_prefs.getHabitsTime);
//   timerSendSMS = Timer(useMobil, () {
//     timerActive = false;

//     IdleLogic().notifyContact();
//     mainController.saveUserLog("Envío de SMS a contacto ", now);
//   });
// }

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((_) {
      DeviceOrientation.portraitUp;
    });
  }

  void getContactList(BuildContext context) async {
    if (user != null && user!.idUser != '-1') {
      contactlist = await getContacts(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.sync(() => RedirectViewNotifier.setStoredContext(context));
    getContactList(context);
    return MaterialApp(
      builder: (context, child) {
        // Configura el factor de escala de texto a 1.0 para evitar el escalado de texto
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: appRoute,
      initialRoute: widget.initApp,
    );
  }
}

void sendLocation() async {
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

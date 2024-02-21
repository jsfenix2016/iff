import 'dart:async';
import 'dart:io';

import 'dart:math';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/recived_notification.dart';
import 'package:ifeelefine/Page/Alerts/Controller/alertsController.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';

import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';
import 'package:ifeelefine/Page/UseMobil/PageView/configurationUseMobile_page.dart';
import 'package:ifeelefine/Page/UserConfig2/Page/configuration2_page.dart';

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

import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Routes/routes.dart';

import 'package:flutter/material.dart';

import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/src/date_time.dart';
import 'package:uuid/uuid.dart';

import 'Common/Firebase/firebaseManager.dart';

import 'Page/Geolocator/Controller/configGeolocatorController.dart';

import 'Page/Premium/Controller/premium_controller.dart';

import 'Page/UserEdit/Controller/getUserController.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

DateTime now = DateTime.now();

var accelerometerValues = <double>[];
List<double> userAccelerometerValues = <double>[];
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// OPTIONAL when use custom notification
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final List<StreamSubscription<dynamic>> _streamSubscriptions2 =
    <StreamSubscription<dynamic>>[];
Duration dismbleTime = const Duration();
PreferenceUser _prefs = PreferenceUser();

bool ismove = true;
bool timerActive = true;

bool isMovRude = false;

bool notActionPush = false;
RxString rxIdTask = ''.obs;
RxString name = "".obs;

final countTimer = RxInt(60);
Timer timerSendSMS = Timer(const Duration(seconds: 20), () {});
Timer timerSendDropNotification = Timer(const Duration(minutes: 5), () {});
Timer desactivedtimerSendDropNotification =
    Timer(const Duration(seconds: 10), () {});
Timer timerSendLocation = Timer(const Duration(seconds: 15), () {});

Timer? timerTempDown = Timer(const Duration(seconds: 1), () {});
Timer timerDropTempDown = Timer(const Duration(seconds: 1), () {});
int countdown = 60;
int countdownDrop = 60;

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
      "Cambiar envió ubicación", 'assets/images/Group 1082.png', 24, 24, true),
  MenuConfigModel("Cambiar tiempo notificaciones",
      'assets/images/Group 1099.png', 22, 17.15, false),
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

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

List<Contact> contactlist = [];
List<String> taskdIds = [];
bool isCancelZone = true;

int secondsRemaining = 30; //5 minutes = 300 seconds
const platform = MethodChannel('custom_notification');
int accelerometerMoveNormal = 10;
Timer? timerCancelZone;
StreamController<int> controllerTimer = StreamController<int>.broadcast();
Stream subscription = Stream.periodic(const Duration(hours: 1));

TZDateTime? datetime;

ContactBD? contactTemp;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _prefs.initPrefs();
  _prefs.refreshData();
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

  // await requestPermission(Permission.notification);
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;

  if (androidInfo.brand == 'samsung' && androidInfo.model.contains("SM-G")) {
    accelerometerMoveNormal = 15;
  }
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          // Esta función se ejecutará cuando se toque cualquier parte de la aplicación.

          starTap();
        },
        child: MyApp(initApp: initApp!),
      ),
    ),
  );
}

// Future<void> startCustomNotification() async {
//   try {
//     await platform.invokeMethod('startCustomNotification');
//   } on PlatformException catch (e) {
//     print("Error: ${e.message}");
//   }
// }

///Esta funcion se utiliza para activar los servicios en segundo plano
///se utilizan las variables getAceptedSendLocation, getDetectedFall para permitir o no su activación.
///VARIABLES: Esta variable sale de preferer donde almacenamos su valor booleano
///getAceptedSendLocation:  indica que el usuario acepto el envio de la ubicacion actual a su contacto
///getDetectedFall:  indica que el usuario acepto la funcionalidad del acelerometro para poder detectar movimientos bruscos
Future<void> activateService() async {
  if (_prefs.isFirstConfig == false) {
    return;
  }

  var textDescrip =
      'AlertFriends está activada y estamos comprobando que te encuentres bien';

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    "my_foreground", // id
    'AlertFriends – Personal Protection', // title
    description:
        'AlertFriends está activada y estamos comprobando que te encuentres bien', // description
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
  final service = FlutterBackgroundService();
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

  service.startService();

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
        onDidReceiveBackgroundNotificationResponse,
    onDidReceiveBackgroundNotificationResponse:
        onDidReceiveBackgroundNotificationResponse,
  );

  final details =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (details != null && details.didNotificationLaunchApp) {
    await inicializeHiveBD();
    await _prefs.initPrefs();
    onDidReceiveBackgroundNotificationResponse(details.notificationResponse!);
  }
}

void cancelTimersNotify() {
  _prefs.setEnableTimer = false;
  _prefs.setEnableTimerDrop = false;
  if (timerTempDown!.isActive) {
    timerTempDown!.cancel();
  }
  if (timerDropTempDown.isActive) {
    timerDropTempDown.cancel();
  }
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse notificationResponse) async {
  await inicializeHiveBD();
  await prefs.initPrefs();
  var aid = Uuid().v4().toString();
  mainController.saveActivityLog(DateTime.now(), "Movimiento normal", aid);
  _logRudeMovementTimer = 0;

  cancelTimersNotify();
  mainController.refreshHome();

  await flutterLocalNotificationsPlugin.cancel(notificationResponse.id!);

  switch (notificationResponse.notificationResponseType) {
    case NotificationResponseType.selectedNotification:
      if (notificationResponse.payload!.contains('ContactResponse')) {
        RedirectViewNotifier.onRefreshContact(notificationResponse);
        return;
      }
      if (notificationResponse.payload!.contains("free")) {
        RedirectViewNotifier.onTapFreeNotification(notificationResponse);
        return;
      }
      if (notificationResponse.payload!.contains("premium")) {
        RedirectViewNotifier.onTapPremiumNotification(notificationResponse);
        return;
      }
      if (notificationResponse.payload!.contains("Drop_")) {
        ismove = false;
        timerActive = true;
        _prefs.setEnableTimerDrop = false;
        String taskIds = notificationResponse.payload!.replaceAll("Drop_", "");
        var taskIdList = getTaskIdList(taskIds);

        rxIdTask.value = taskIds;

        notActionPush = true;

        RedirectViewNotifier.onTapNotificationBody(
            notificationResponse, taskIdList);

        await flutterLocalNotificationsPlugin.cancel(notificationResponse.id!);
        prefs.setNotificationType = "";
        mainController.refreshHome();
        return;
      }
      if (notificationResponse.payload!.contains("Inactived_")) {
        ismove = false;
        timerActive = true;
        _prefs.setEnableIFF = true;

        _prefs.setDisambleIFF = "0 hora";
        String taskIds =
            notificationResponse.payload!.replaceAll("Inactived_", "");
        var taskIdList = getTaskIdList(taskIds);

        rxIdTask.value = taskIds;

        _prefs.setlistTaskIdsCancel = taskIdList;
        notActionPush = true;
        cancelTimersNotify();
        RedirectViewNotifier.onTapNotificationBody(
            notificationResponse, taskIdList);

        await flutterLocalNotificationsPlugin.cancel(notificationResponse.id!);
        prefs.setNotificationType = "";
        mainController.refreshHome();
        return;
      }
      if (notificationResponse.actionId == "Inactived") {
        ismove = false;
        timerActive = true;
        String taskIds =
            notificationResponse.actionId!.replaceAll("Inactived_", "");
        var taskIdList = getTaskIdList(taskIds);

        cancelTimersNotify();
        if (notificationResponse.payload!.contains("Inactived_")) {
          mainController.saveUserLog("Inactividad - solicito ayuda",
              DateTime.now(), prefs.getIdInactiveGroup);
        }

        if (notificationResponse.payload!.contains("Drop_")) {
          mainController.saveUserLog(
              "Caida  - solicito ayuda", DateTime.now(), prefs.getIdDropGroup);
        }

        MainService().cancelAllNotifications(taskIdList);
        await flutterLocalNotificationsPlugin.cancel(notificationResponse.id!);
        prefs.setNotificationType = "";
        mainController.refreshHome();
        return;
      }
      if (notificationResponse.payload!.contains("DateRisk_")) {
        String taskIds =
            notificationResponse.payload!.replaceAll("DateRisk_", "");

        var taskIdList = getTaskIdList(taskIds);

        rxIdTask.value = taskIds;
        _prefs.setlistTaskIdsCancel = taskIdList;
        notActionPush = true;

        var contactRisk = await const HiveDataRisk().getcontactRiskbd;

        if (taskIds.isEmpty) {
          EditRiskController erisk = Get.put(EditRiskController());
          RiskController risk = Get.put(RiskController());
          var resp = await risk.getContactsRisk();
          ContactRiskBD tempcontact = initContactRisk();

          for (var temp in resp) {
            DateTime starTime = parseContactRiskDate(temp.timeinit);
            bool isafter = DateTime.now().isAfter(starTime);
            if (!temp.isActived &&
                temp.isprogrammed &&
                isafter &&
                !temp.isFinishTime) {
              tempcontact = temp;
            }
          }

          if (tempcontact.id != -1) {
            await erisk.updateContactRisk(tempcontact);
          }

          return;
        }

        _prefs.saveLastScreenRoute("cancelDate");

        for (var element in contactRisk) {
          if (element.isActived || element.isFinishTime) {
            RedirectViewNotifier.onTapNotification(taskIdList, element.id);
          }
        }

        await flutterLocalNotificationsPlugin.cancel(notificationResponse.id!);
        prefs.setNotificationType = "";
        mainController.refreshHome();
      }

      break;
    case NotificationResponseType.selectedNotificationAction:
      if (notificationResponse.actionId != null &&
          notificationResponse.actionId!.contains("helpID")) {
        String taskIds =
            notificationResponse.actionId!.replaceAll("helpID_", "");
        var taskIdList = getTaskIdList(taskIds);

        if (notificationResponse.payload!.contains("DateRisk_")) {
          mainController.saveUserLog(
              "Cita - solicito ayuda", DateTime.now(), prefs.getIdDateGroup);
        }
        if (notificationResponse.payload!.contains("Inactived_")) {
          mainController.saveUserLog("Inactividad - solicito ayuda",
              DateTime.now(), prefs.getIdInactiveGroup);
        }

        if (notificationResponse.payload!.contains("Drop_")) {
          mainController.saveUserLog(
              "Caida  - solicito ayuda", DateTime.now(), prefs.getIdDropGroup);
        }
        cancelTimersNotify();
        MainService().sendAlertToContactImmediately(taskIdList);
        prefs.setNotificationType = "";
        mainController.refreshHome();
        return;
      }

      if (notificationResponse.actionId != null &&
          notificationResponse.actionId!.contains("imgoodId")) {
        cancelTimersNotify();
        String taskIds =
            notificationResponse.actionId!.replaceAll("imgoodId_", "");
        var taskIdList = getTaskIdList(taskIds);
        ismove = false;
        timerActive = true;

        if (notificationResponse.payload!.contains("DateRisk_")) {
          RiskController riskVC = Get.find<RiskController>();
          riskVC.update();
        }

        if (notificationResponse.payload!.contains("Inactived_")) {
          mainController.saveUserLog("Inactividad - Actividad detectada ",
              DateTime.now(), prefs.getIdInactiveGroup);
        }

        if (notificationResponse.payload!.contains("Drop_")) {
          mainController.saveUserLog(
              "Caida cancelada", DateTime.now(), prefs.getIdDropGroup);
        }

        MainService().cancelAllNotifications(taskIdList);
        // await flutterLocalNotificationsPlugin.cancel(100);
        prefs.setNotificationType = "";
        mainController.refreshHome();
        return;
      }
      if (notificationResponse.actionId != null &&
          notificationResponse.actionId!.contains("dateHelp")) {
        String taskIds =
            notificationResponse.actionId!.replaceAll("dateHelp_", "");
        var taskIdList = getTaskIdList(taskIds);
        String id = notificationResponse.actionId!.substring(
            notificationResponse.actionId!.indexOf('id='),
            notificationResponse.actionId!.length);

        if (notificationResponse.payload!.contains("Inactived_")) {
          mainController.saveUserLog("Inactividad - solicito ayuda",
              DateTime.now(), prefs.getIdInactiveGroup);
        }

        if (notificationResponse.payload!.contains("Drop_")) {
          mainController.saveUserLog(
              "Caida - solicito ayuda", DateTime.now(), prefs.getIdDropGroup);
        }

        if (notificationResponse.payload!.contains("DateRisk_")) {
          mainController.saveUserLog(
              "Cita - solicito ayuda", DateTime.now(), prefs.getIdDateGroup);
        }

        cancelTimersNotify();
        MainService().sendAlertToContactImmediately(taskIdList);
        prefs.setNotificationType = "";
        mainController.refreshHome();
        return;
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
        EditRiskController erisk = Get.put(EditRiskController());
        RiskController risk = Get.put(RiskController());
        var resp = await risk.getContactsRisk();
        ContactRiskBD tempcontact = initContactRisk();
        for (var temp in resp) {
          if (temp.id == int.parse(id)) {
            tempcontact = temp;
          }
        }

        var contactRiskTemp = tempcontact;
        contactRiskTemp.id = int.parse(id);
        contactRiskTemp.isActived = false;
        contactRiskTemp.isprogrammed = false;
        contactRiskTemp.isFinishTime = true;
        await erisk.updateContactRisk(contactRiskTemp);
        var taskIdList = getTaskIdList(taskIds);
        if (notificationResponse.payload!.contains("DateRisk_")) {
          mainController.saveUserLog(
              "Cita - Cancelada", DateTime.now(), prefs.getIdDateGroup);
        }
        MainService().cancelAllNotifications(taskIdList);
        prefs.setNotificationType = "";
        mainController.refreshHome();
        try {
          NotificationCenter().notify('refreshView');
        } catch (e) {
          print(e);
        }

        return;
      }
      if (notificationResponse.actionId!.contains("premium")) {
        RedirectViewNotifier.onTapPremiumNotification(notificationResponse);
        return;
      }
      if (notificationResponse.actionId!.contains("ok")) {
        RedirectViewNotifier.onTapFreeNotification(notificationResponse);
        return;
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
        if (notificationResponse.payload!.contains("DateRisk_")) {
          _prefs.saveLastScreenRoute("home");
          EditRiskController erisk = Get.put(EditRiskController());
          RiskController riskVC = Get.put(RiskController());

          var resp = await riskVC.getContactsRisk();
          ContactRiskBD tempcontact = initContactRisk();
          for (var temp in resp) {
            if (temp.id == int.parse(id)) {
              tempcontact = temp;
            }
          }

          var contactRiskTemp = tempcontact;
          contactRiskTemp.id = int.parse(id);

          contactRiskTemp.isFinishTime = true;
          await erisk.updateContactRisk(contactRiskTemp);
          riskVC.update();
          RedirectViewNotifier.onTapNotification(taskIdList, int.parse(id));
        }

        if (notificationResponse.payload!.contains("Drop_")) {
          mainController.saveUserLog(
              "Caida - estoy bien", DateTime.now(), prefs.getIdDropGroup);
          MainService().cancelAllNotifications(taskIdList);
        }

        if (notificationResponse.payload!.contains("Inactived_")) {
          mainController.saveUserLog("Inactividad -  estoy bien",
              DateTime.now(), prefs.getIdDropGroup);
          MainService().cancelAllNotifications(taskIdList);
        }

        prefs.setNotificationType = "";
        mainController.refreshHome();

        try {
          NotificationCenter().notify('refreshView');
        } catch (e) {
          print(e);
        }
        return Future.value();
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

// Inicializar el ID de la notificación
int notificationId = 1110;
StreamController<String> notificationContentController =
    StreamController<String>();

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
    var timerRest = timeDurationActivation(_prefs.getDisambleTimeIFF).inSeconds;
    var timeGetDisamble = _prefs.getDisambleIFF;
    var timeDisamble = deactivateTimeToMinutes(timeGetDisamble) * 60;

    if (timerRest.isEqual(0) && !_prefs.getEnableIFF) {
      if (increaceTimerDisamble >= timerRest) {
        _prefs.setEnableIFF = true;
        increaceTimerDisamble = 0;
        _prefs.setDisambleIFF = "0 hora";
        _prefs.setDisambleTimeIFF = "";
      }
    }

    // Timer.periodic(const Duration(seconds: 1), (timer) async {
    //   if (Platform.isAndroid) {
    //     if (service is AndroidServiceInstance) {
    //       if (await service.isForegroundService()) {
    //         var timerTemp = timeRevert - 1;
    //         // flutterLocalNotificationsPlugin.show(
    //         //   888,
    //         //   'COOL SERVICE',
    //         //   'Awesome ${timerTemp}',
    //         //   const NotificationDetails(
    //         //     android: AndroidNotificationDetails(
    //         //         'my_foreground', 'MY FOREGROUND SERVICE',
    //         //         icon: 'ic_bg_service_small',
    //         //         ongoing: false,
    //         //         priority: Priority.high,
    //         //         importance: Importance.high,
    //         //         playSound: false),
    //         //   ),
    //         // );
    //       }
    //     }
    //   }
    // });

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

void accelerometer() {
  //Initialization Settings for Android
  Duration sensorInterval = SensorInterval.normalInterval;
  Future.microtask(() async => {await _prefs.initPrefs()});

  try {
    _streamSubscriptions2.add(
      accelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (AccelerometerEvent event) {
          double accelerationMagnitude =
              sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

          if (accelerationMagnitude > 45) {
            isMovRude = true;
            print("2 -> $accelerationMagnitude");

            if (_prefs.getEnableIFF == false ||
                _prefs.getUseMobilConfig == false ||
                _prefs.getDetectedFall == false ||
                _prefs.getUserPremium == false ||
                _prefs.getUserFree) return;

            if (_logRudeMovementTimer >= _logRudeMovementTimerRefresh) {
              print('Movimiento brusco');
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

            if (accelerationMagnitude < 45 &&
                accelerationMagnitude > accelerometerMoveNormal) {
              _prefs.refreshData();
              if (_prefs.getEnableIFF &&
                  _logActivityTimer >= _logActivityTimerRefresh) {
                if (_prefs.getUseMobilConfig) {
                  print('Movimiento normal');

                  mainController.saveActivityLog(DateTime.now(),
                      "Movimiento normal", Uuid().v4().toString());
                  isMovRude = false;
                }
                _logActivityTimer = 0;
              }

              ismove = false;
              timerActive = true;
            }
          }
        },
        onError: (e) {
          print(e);
        },
        cancelOnError: true,
      ),
    );
  } catch (e) {
    print('Error al suscribirse al acelerómetro: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.initApp});

  final String initApp;

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
    RedirectViewNotifier.setStoredContext(context);
    getContactList(context);
    return MaterialApp(
      theme: ThemeData(
        focusColor: Colors.white,
        useMaterial3: true,
        primaryColor: Colors.white,
      ),
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
    var locationenabled =
        await PermissionService.requestPermission(Permission.location);
    if (locationenabled) {}
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
    return Future.error('Location services are disabled');
  }

  return await Geolocator.getCurrentPosition();
}

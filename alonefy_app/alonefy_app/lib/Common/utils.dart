import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Model/ApiRest/ContactApi.dart';
import 'package:ifeelefine/Model/ApiRest/ZoneRiskApi.dart';
import 'package:ifeelefine/Page/Geolocator/Controller/configGeolocatorController.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Views/menuconfig_page.dart';
import 'package:ifeelefine/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification_center/notification_center.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../Model/ApiRest/AlertApi.dart';
import '../Model/ApiRest/ContactRiskApi.dart';
import '../Model/ApiRest/UseMobilApi.dart';
import '../Model/ApiRest/UserRestApi.dart';
import '../Model/ApiRest/activityDayApiResponse.dart';
import 'package:flutter_countries/flutter_countries.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final _prefs = PreferenceUser();
final _locationController = Get.put(ConfigGeolocatorController());

class Utils {}

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

Map<String, String> getAge() {
  Map<String, String> ages = {};
  for (var i = 18; i < 100; i++) {
    ages.addEntries({i.toString(): i.toString()}.entries);
  }

  return ages;
}

void resetServicesBackground() async {
  final service = FlutterBackgroundService();
  var isRunning = await service.isRunning();
  if (isRunning) {
    service.invoke("stopService");
  }
  await service.startService();
  await activateService();
}

void starTap() {
  if (timerSendLocation.isActive) {
    timerSendLocation.cancel();
  }
  timerSendLocation = Timer(const Duration(seconds: 15), () {
    mainController.saveActivityLog(
        DateTime.now(), "Movimiento normal", Uuid().v4().toString());
    timerSendLocation.cancel();
  });
}

void refreshMenu(String menu) async {
  List<String>? temp = [];

  temp = await _prefs.getlistConfigPage;
  if (temp!.isEmpty) {
    temp.add(menu);
  } else {
    for (var element in temp) {
      if (element.contains(menu) == false) {
        temp.insert(0, menu);
        print(menu);
        break;
      }
    }
  }
  _prefs.setlistConfigPage = temp;
  try {
    NotificationCenter().notify('refreshMenu');
    NotificationCenter().notify('refreshView');
  } catch (e) {
    print(e);
  }
}

Future<List<MenuConfigModel>> validateConfig() async {
  List<String>? temp = await _prefs.getlistConfigPage;

  if (temp!.isEmpty) {
    return permissionStatusI;
  }

  for (var element in temp) {
    switch (element) {
      case "config2":
        menuConfig[0] = (false);
        break;
      case "restDay":
        menuConfig[1] = (false);
        break;
      case "useMobil":
        menuConfig[2] = (false);
        break;
      case "previewActivity":
        menuConfig[3] = (false);
        break;

      case "addContact":
        menuConfig[4] = (false);
        break;
      case "fallActivation":
        menuConfig[5] = (false);
        break;
      case "configGeo":
        menuConfig[6] = (false);
        break;
      case "inactivityDay":
        menuConfig[7] = (false);
        break;

      default:
    }
  }

  permissionStatusI = [
    MenuConfigModel("Configurar tus datos", 'assets/images/VectorUser.png', 22,
        19.25, menuConfig[0]),
    MenuConfigModel("Configurar tiempo de sueño",
        'assets/images/EllipseMenu.png', 22, 22, menuConfig[1]),
    MenuConfigModel("Configurar tiempo uso", 'assets/images/Group 1084.png', 22,
        16.93, menuConfig[2]),
    MenuConfigModel("Actividades", 'assets/images/Group 1084.png', 22, 16.93,
        menuConfig[3]),
    MenuConfigModel("Seleccionar contacto de aviso",
        'assets/images/Group 1083.png', 22, 25.52, menuConfig[4]),
    MenuConfigModel("Configurar caída", 'assets/images/Group 506.png', 26,
        22.76, menuConfig[5]),
    MenuConfigModel("Cambiar envío ubicación", 'assets/images/Group 1082.png',
        24, 24, menuConfig[6]),
    MenuConfigModel("Cambiar tiempo notificaciónes",
        'assets/images/Group 1099.png', 22, 17.15, false),
    MenuConfigModel("Cambiar sonido notificaciones",
        'assets/images/Group 1102.png', 22, 22.08, false),
    MenuConfigModel("Ajustes de mi smartphone", 'assets/images/mobile.png', 22,
        19.66, false),
    MenuConfigModel("Restaurar mi configuración", 'assets/images/Vector-2.png',
        22, 22, false),
    MenuConfigModel("Desactivar mi instalación", 'assets/images/Group 533.png',
        21, 17, false),
    // MenuConfigModel("Cambiar sonido notificaciones",
    //     'assets/images/Group 1102.png', 22, 22.08),
  ];

  var contieneTrue = permissionStatusI.any((element) => element.config == true);

  // Verifica el resultado
  if (contieneTrue) {
    print('La lista contiene al menos un true');
    _prefs.config = false;
  } else {
    print('La lista no contiene ningún true');
    _prefs.config = true;
  }

  return permissionStatusI;
}

void diveceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    // Android-specific code
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
  } else if (Platform.isIOS) {
    // iOS-specific code
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
  }
}

String diaConvert(String dia) {
  const map = {
    "L": 'Lunes',
    "M": 'Martes',
    "X": 'Miercoles',
    "J": 'Jueves',
    "V": 'Viernes',
    "S": 'Sabado',
    "D": 'Domingo',
  };

  return map[dia] ?? 'error';
}

String initialdayConvertDay(String dia) {
  const map = {
    "Lunes": 'L',
    "Martes": 'M',
    "Miercoles": 'X',
    "Jueves": 'J',
    "Viernes": 'V',
    "Sabado": 'S',
    "Domingo": 'D',
  };

  return map[dia] ?? 'error';
}

String weekDayToString(int weekDay) {
  const map = {
    1: 'Lunes',
    2: 'Martes',
    3: 'Miercoles',
    4: 'Jueves',
    5: 'Viernes',
    6: 'Sabado',
    7: 'Domingo',
  };

  return map[weekDay] ?? 'error';
}

String calculateAge(DateTime birthDate) {
  if (birthDate == null) {
    return "";
  }
  var edad = '';
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  if (age >= 2) {
    edad = "$age años";
  } else if (age == 1) {
    edad = "$age año";
  } else if (age < 1) {
    edad = "$age meses";
  }
  return edad;
}

Image getImage(String urlImage) {
  try {
    Uint8List bytesImages = const Base64Decoder().convert(urlImage);

    return Image.memory(bytesImages,
        fit: BoxFit.cover, width: double.infinity, height: 250.0);
  } catch (e) {
    return Image(image: FileImage(File(urlImage)));
  }
}

Future<File> procesarImagen(ImageSource origen) async {
  final XFile? image = await ImagePicker().pickImage(source: origen);

  File file = File("");
  if (image == null) {
    return file;
  }
  file = File(image.path);
  return file;
}

Future<File> convertUint8ToFile(Uint8List bytes) async {
  return File.fromRawPath(bytes);
}

Future<String> saveImageFromUrl(Uint8List bytes, String imageName) async {
  var documentDirectory = await getApplicationDocumentsDirectory();
  var firstPath = "${documentDirectory.path}/images";
  var filePathAndName = '${documentDirectory.path}/images/$imageName';
  await Directory(firstPath).create(recursive: true);
  File file = File(filePathAndName);
  file.writeAsBytesSync(bytes);

  return filePathAndName;
}

Future<String> displayTimePicker(BuildContext context, String key) async {
  var time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, childWidget) {
        return MediaQuery(
            key: Key(key),
            data: MediaQuery.of(context).copyWith(
                // Using 24-Hour format
                alwaysUse24HourFormat: true),
            // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
            child: childWidget!);
      });
  if (time != null) {
    // ignore: use_build_context_synchronously
    return time.format(context);
  }
  return "00:00";
}

Duration getDuration(List<String> parts) {
  int hours = 0;
  int minutes = 0;
  int micros;

  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  var temp = Duration(hours: hours, minutes: minutes, microseconds: micros);

  return temp;
}

Future<String> locateZone() async {
  var zone = await localizeStringName();
  return zone.toString();
}

DateTime parseDurationRow(String s) {
  List<String> parts;
  Duration temp;
  tz.initializeTimeZones();

  if (s == "00:00") {
    parts = s.split(':');
    temp = getDurationNew(parts);
  } else {
    parts = s.split(' ');
    parts = parts[1].split(':');
    temp = getDurationNew(parts);
  }

  DateTime currentTime = DateTime.now();
  var dateTimed = DateFormat("yyyy-MM-dd HH:mm:ss")
      .parse("${currentTime.toString().split(" ")[0]} $temp", true);

  // Obtener la zona horaria de Madrid
  tz.Location madridLocation = tz.getLocation(_prefs.getNameZone);
  var tine = dateTimed
      .subtract(Duration(milliseconds: madridLocation.currentTimeZone.offset));
  return tine;
}

Future<String> localizeStringName() async {
  tz.initializeTimeZones(); // Inicializar las zonas horarias
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  return timeZoneName;
}

Future<tz.TZDateTime> convertTimeTZ(int hour) async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  // tz.setLocalLocation(tz.getLocation(timeZoneName));
  final tz.TZDateTime now = tz.TZDateTime.now(tz.getLocation(timeZoneName));

  tz.TZDateTime scheduleDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, 47);

  return scheduleDate;
}

Duration getDurationNew(List<String> parts) {
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);

  return Duration(hours: hours, minutes: minutes);
}

DateTime parseStringHours(String s) {
  List<String> parts = [];

  Duration temp = Duration.zero;

  if (s == "00:00") {
    parts = s.split(':');
    temp = getDuration(parts);
  } else {
    parts = s.split(':');

    temp = getDuration(parts);
  }

  var format = DateFormat("HH:mm");

  String sDuration =
      "${temp.inHours.toString().padLeft(2, '0')}:${temp.inMinutes.remainder(60).toString().padLeft(2, '0')}";
  DateTime pastDateTime = format.parse(sDuration);
  return pastDateTime;
}

DateTime parseContactRiskDate(String contactRiskDate) {
  tz.initializeTimeZones();
  var day = contactRiskDate.substring(0, contactRiskDate.indexOf('-'));
  contactRiskDate = contactRiskDate.substring(
      contactRiskDate.indexOf('-') + 1, contactRiskDate.length);

  var month = contactRiskDate.substring(0, contactRiskDate.indexOf('-'));
  contactRiskDate = contactRiskDate.substring(
      contactRiskDate.indexOf('-') + 1, contactRiskDate.length);

  var year = contactRiskDate.substring(0, contactRiskDate.indexOf(' '));
  contactRiskDate = contactRiskDate.substring(
      contactRiskDate.indexOf(' ') + 1, contactRiskDate.length);

  var hour = contactRiskDate.substring(0, contactRiskDate.indexOf(':'));
  contactRiskDate = contactRiskDate.substring(
      contactRiskDate.indexOf(':') + 1, contactRiskDate.length);

  var minutes = contactRiskDate.substring(0, 2);

  // Obtener una zona horaria específica, por ejemplo, la zona horaria de Nueva York
  Future.sync(() async => {await _prefs.initPrefs()});
  // Obtener la zona horaria de Madrid
  tz.Location madridLocation = tz.getLocation(_prefs.getNameZone);

// Crear un TZDateTime con información de zona horaria
  final datetime = tz.TZDateTime(madridLocation, int.parse(year),
      int.parse(month), int.parse(day), int.parse(hour), int.parse(minutes));

  return datetime;
}

String parseTimeString(String s) {
  List<String> parts = [];
  List<String> parts2 = [];
  Duration temp = Duration.zero;

  if (s == "00:00") {
    parts = s.split(':');
    temp = getDuration(parts);
  } else {
    parts = s.split(' ');
    parts2 = parts[1].split(':');
    temp = getDuration(parts2);
  }

  String sDuration =
      "${temp.inHours.toString().padLeft(2, '0')}:${temp.inMinutes.remainder(60).toString().padLeft(2, '0')}";

  return sDuration;
}

DateTime parseDuration(String s) {
  List<String> parts = [];
  List<String> parts2 = [];
  Duration temp = Duration.zero;

  if (s == "00:00") {
    parts = s.split(':');
    temp = getDuration(parts);
  } else {
    parts = s.split(' ');
    parts2 = parts[1].split(':');
    temp = getDuration(parts2);
  }

  var format = DateFormat("HH:mm");

  String sDuration =
      "${temp.inHours.toString().padLeft(2, '0')}:${temp.inMinutes.remainder(60).toString().padLeft(2, '0')}";
  DateTime pastDateTime = format.parse(sDuration);
  return pastDateTime;
}

DateTime parseTime(String str, DateTime dateTime) {
  var hour = int.parse(str.substring(0, 2));
  var minute = int.parse(str.substring(3, 5));

  var time =
      DateTime(dateTime.year, dateTime.month, dateTime.day, hour, minute);
  return time;
}

Future<String> convertDateTimeToStringTime(DateTime dateTime) async {
  await Jiffy.locale('es');

  var hour = dateTime.hour;
  var minutes = dateTime.minute;

  var strHour = '$hour';
  var strMinutes = '$minutes';

  if (hour < 10) strHour = '0$hour';
  if (minutes < 10) strMinutes = '0$minutes';

  //var dateTime = Jiffy(time).format(getTimePattern());
  return '$strHour:$strMinutes';
}

void showAlert(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Información "),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              child: Text("OK", style: textBold16Black()),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

Future getResponse() async {
  var res = await rootBundle
      .loadString('packages/country_state_city_picker/lib/assets/country.json');

  return jsonDecode(res);
}

Future getProvince() async {
  var res = await rootBundle.loadString('assets/json/province_spain.json');

  return jsonDecode(res);
}

RxList<String> liststate = <String>[].obs;

// Función para remover las diacríticas de un texto (tildes, diéresis, etc.)
String removeDiacritics(String text) {
  return text.replaceAllMapped(
      RegExp(r'[ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝàáâãäåçèéêëìíîïðñòóôõöøùúûüýÿ]'),
      (match) {
    switch (match.group(0)) {
      case 'À':
      case 'Á':
      case 'Â':
      case 'Ã':
      case 'Ä':
      case 'Å':
        return 'A';
      case 'Ç':
        return 'C';
      case 'È':
      case 'É':
      case 'Ê':
      case 'Ë':
        return 'E';
      case 'Ì':
      case 'Í':
      case 'Î':
      case 'Ï':
        return 'I';
      case 'Ð':
        return 'D';
      case 'Ñ':
        return 'N';
      case 'Ò':
      case 'Ó':
      case 'Ô':
      case 'Õ':
      case 'Ö':
      case 'Ø':
        return 'O';
      case 'Ù':
      case 'Ú':
      case 'Û':
      case 'Ü':
        return 'U';
      case 'Ý':
        return 'Y';
      case 'à':
      case 'á':
      case 'â':
      case 'ã':
      case 'ä':
      case 'å':
        return 'a';
      case 'ç':
        return 'c';
      case 'è':
      case 'é':
      case 'ê':
      case 'ë':
        return 'e';
      case 'ì':
      case 'í':
      case 'î':
      case 'ï':
        return 'i';
      case 'ð':
        return 'd';
      case 'ñ':
        return 'n';
      case 'ò':
      case 'ó':
      case 'ô':
      case 'õ':
      case 'ö':
      case 'ø':
        return 'o';
      case 'ù':
      case 'ú':
      case 'û':
      case 'ü':
        return 'u';
      case 'ý':
      case 'ÿ':
        return 'y';
    }
    return '';
  });
}

Future<List<String>> getTraslateState(Country countryId) async {
  List<String> states = [];

  var province = await getProvince() as List;
  List<Map<String, dynamic>> jsonList = province.cast<Map<String, dynamic>>();

  jsonList.sort((a, b) =>
      removeDiacritics(a['name']).compareTo(removeDiacritics(b['name'])));

  var list = await States.byCountryId(countryId.id.toString());
  if (countryId.name!.contains("Spain")) {
    for (var f in jsonList) {
      states.add(f["name"].toString());
    }
    liststate.value = states;
    return liststate;
  }
  for (var f in list) {
    if (countryId.id == f.countryId) {
      states.add(f.name.toString());
    } else {
      states.remove(f.name);
    }
  }

  liststate.value = states;
  return states;
}

Future<List<Country>> getTraslateCountry() async {
  var list = await Countries.all;

  return list;
}

Container searchImageForIcon(String typeAction) {
  AssetImage name = const AssetImage('assets/images/Warning.png');
  if (typeAction.contains("SMS")) {
    name = const AssetImage('assets/images/Email.png');
  } else if (typeAction.contains("cancelada")) {
    name = const AssetImage('assets/images/Group 1283.png');
  } else if (typeAction.contains("Inactividad")) {
    name = const AssetImage('assets/images/Warning.png');
  } else if (typeAction.contains("Notificación")) {
    name = const AssetImage('assets/images/Group 1283.png');
  } else if (typeAction.contains("Movimiento")) {
    name = const AssetImage('assets/images/actividad 1.png');
  }

  return Container(
    height: 32,
    width: 31.2,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: name,
      ),
      color: Colors.transparent,
    ),
  );
}

Container searchImageForIcona(String typeAction) {
  AssetImage name = const AssetImage('assets/images/Warning.png');
  if (typeAction.contains("SMS")) {
    name = const AssetImage('assets/images/Email.png');
  } else if (typeAction.contains("Inactividad")) {
    name = const AssetImage('assets/images/Warning.png');
  } else if (typeAction.contains("Notificación")) {
    name = const AssetImage('assets/images/Group 1283.png');
  }

  return Container(
    height: 32,
    width: 31.2,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: name,
      ),
      color: Colors.transparent,
    ),
  );
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  if (_prefs.getAcceptedSendLocation == PreferencePermission.allow &&
      _prefs.getUserPremium) {
    Geolocator.openAppSettings();
  }
  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    //_prefs.setAcceptedSendLocation = PreferencePermission.noAccepted;
    _locationController.activateLocation(PreferencePermission.noAccepted);
    return Future.error('Location services are disabled');
  }

  if (_prefs.getAcceptedSendLocation != PreferencePermission.allow &&
      !_prefs.getUserPremium) {
    return Future.error('');
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
      //_prefs.setAcceptedSendLocation = PreferencePermission.noAccepted;
      _locationController.activateLocation(PreferencePermission.noAccepted);
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    //_prefs.setAcceptedSendLocation = PreferencePermission.noAccepted;
    _locationController.activateLocation(PreferencePermission.noAccepted);
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.

  return await Geolocator.getCurrentPosition();
}

Future<bool> cameraPermissions(PreferencePermission acceptedCamera) async {
  PermissionStatus permission = await Permission.camera.status;
  PreferencePermission prefsCamera = acceptedCamera;

  if (permission == PermissionStatus.denied &&
      prefsCamera == PreferencePermission.deniedForever) {
    showPermissionDialog(
        RedirectViewNotifier.storedContext!, Constant.enablePermission);

    return false;
  } else if (permission == PermissionStatus.denied) {
    Map<Permission, PermissionStatus> permissionStatus =
        await [Permission.camera].request();
    if (permissionStatus[Permission.camera] ==
        PermissionStatus.permanentlyDenied) {
      _prefs.setAcceptedCamera = PreferencePermission.deniedForever;
    }

    if (permissionStatus[Permission.camera] == PermissionStatus.granted) {
      _prefs.setAcceptedCamera = PreferencePermission.allow;
    }

    return permissionStatus[Permission.camera] == PermissionStatus.granted;
  } else {
    return _prefs.getAcceptedCamera == PreferencePermission.allow;
  }
}

Future<RxList<Contact>> getContactsMobil(BuildContext context) async {
  RxList<Contact> contactList = <Contact>[].obs;

  PermissionStatus permission = await Permission.contacts.request();

  if (permission.isPermanentlyDenied) {
    // ignore: use_build_context_synchronously
    showPermissionDialog(context, "Permitir acceder a los contactos");
    return contactList;
  } else if (permission.isDenied) {
    return contactList;
  } else {
    // Retrieve the list of contacts from the device
    // var contacts = await FlutterContacts.getContacts();
    // Set the list of contacts in the state
    var contacts = await FlutterContacts.getContacts(
        withProperties: true, withPhoto: true);
    contactList.value = contacts;

    return contactList;
  }
}

Future<List<Contact>> getContacts(BuildContext context) async {
  PermissionStatus permission = await Permission.contacts.request();

  if (permission.isPermanentlyDenied) {
    // ignore: use_build_context_synchronously
    showPermissionDialog(context, "Permitir acceder a los contactos");
    return [];
  } else if (permission.isDenied) {
    return [];
  } else {
    // Retrieve the list of contacts from the device
    // var contacts = await FlutterContacts.getContacts();
    // Set the list of contacts in the state
    var contacts = await FlutterContacts.getContacts(
        withProperties: true, withPhoto: true);

    return contacts;
  }
}

Future<List<Contact>> getContactsListWithoutPermission() async {
  var contacts = await FlutterContacts.getContacts(
        withProperties: true, withPhoto: true);

  return contacts;
}

String getDefaultPattern() {
  return 'EEEE, d MMMM yyyy';
}

String getShortPattern() {
  return 'EEEE dd/MM/yyyy';
}

String getDatePattern() {
  return 'dd/MM/yyyy';
}

String getTimePattern() {
  return 'hh:mm';
}

Future<String> dateTimeToString(DateTime dateTime) async {
  await Jiffy.locale("es");

  String hour = Jiffy(dateTime).hour < 10
      ? '0${Jiffy(dateTime).hour}'
      : '${Jiffy(dateTime).hour}';
  String minute = Jiffy(dateTime).minute < 10
      ? '0${Jiffy(dateTime).minute}'
      : '${Jiffy(dateTime).minute}';
  String second = Jiffy(dateTime).second < 10
      ? '0${Jiffy(dateTime).second}'
      : '${Jiffy(dateTime).second}';

  var date = Jiffy(dateTime).format(getDatePattern());

  return '$date ${hour.padLeft(2, '0')}:${minute.padLeft(2, '0')}:$second';
}

String rangeTimeToString(String from, String to) {
  var rangeTime = '$to-$from';
  rangeTime = rangeTime.replaceAll(' ', '');
  return rangeTime;
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

Future<String> rangeDateTimeToString(DateTime? from, DateTime? to) async {
  var rangeDateText = "";

  await Jiffy.locale("es");

  if (from != null && to != null) {
    if (from.year == to.year) {
      if (from.month == to.month) {
        if (from.day == to.day) {
          rangeDateText = Jiffy(from).format('d [de] MMMM [de] yyyy');
        } else {
          var month = Jiffy(from).format('MMMM');
          var year = Jiffy(from).format('yyyy');
          rangeDateText = 'Del ${from.day} al ${to.day} de $month de $year';
        }
      } else {
        var monthFrom = Jiffy(from).format('MMMM');
        var monthTo = Jiffy(to).format('MMMM');
        var year = Jiffy(from).format('yyyy');
        rangeDateText =
            'Del ${from.day} de $monthFrom al ${to.day} de $monthTo de $year';
      }
    } else {
      var monthFrom = Jiffy(from).format('MMMM');
      var monthTo = Jiffy(to).format('MMMM');
      var yearFrom = Jiffy(from).format('yyyy');
      var yearTo = Jiffy(to).format('yyyy');
      rangeDateText =
          'Del ${from.day} de $monthFrom de $yearFrom al ${to.day} de $monthTo de $yearTo';
    }
  } else {
    rangeDateText = Jiffy().format('d [de] MMMM [de] yyyy');
  }

  return rangeDateText;
}

int minToInt(String time) {
  var min = int.parse(time.replaceAll(" min", ""));
  return min;
}

int hourToInt(String time) {
  var hour = int.parse(time.replaceAll(" hora", ""));
  return hour;
}

int stringTimeToInt(String strTime) {
  if (strTime.isEmpty) {
    return -1;
  }
  var time = strTime.replaceAll(" min", "");
  time = time.replaceAll(" hora", "");

  if (strTime.contains('hora')) {
    return int.parse(time) * 60;
  }

  return int.parse(time);
}

int deactivateTimeToMinutes(String strTime) {
  if (strTime.isEmpty) {
    strTime = '0 horas';
  }
  if (strTime.contains('Siempre')) {
    return 2 * 60 * 24 * 365 * 10;
  }
  var time = strTime.replaceAll("hora", "");
  time = strTime.replaceAll(" horas", "");
  time = strTime.replaceAll(" semana", "");
  time = strTime.replaceAll(" mes", "");
  time = strTime.replaceAll(" año", "");

  if (strTime.contains("hora")) {
    var time = strTime.replaceAll(" hora", "");
    return int.parse(time.replaceAll(" hora", "").replaceAll("s", "")) * 60;
  } else if (strTime.contains('horas')) {
    var time = strTime.replaceAll(" horas", "");
    return int.parse(time) * 60;
  } else if (strTime.contains('semana')) {
    var time = strTime.replaceAll(" semana", "");
    return int.parse(time) * 60 * 24 * 7;
  } else if (strTime.contains('mes')) {
    var time = strTime.replaceAll(" mes", "");
    return int.parse(time) * 60 * 24 * 30;
  } else if (strTime.contains('año')) {
    var time = strTime.replaceAll(" año", "");
    return int.parse(time) * 60 * 24 * 365;
  } else {
    return int.parse(time) * 60 * 24 * 365 * 10;
  }
}

String convertDateTimeToDisamble(DateTime dateTime) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  // Convertimos la diferencia de tiempo a horas
  double differenceInHours = difference.inHours.toDouble();

  if (differenceInHours >= 0 && differenceInHours <= 1) {
    return "1 hora";
  } else if (differenceInHours >= 0 && differenceInHours <= 2) {
    return "2 horas";
  } else if (differenceInHours >= 0 && differenceInHours <= 3) {
    return "3 horas";
  } else if (differenceInHours >= 0 && differenceInHours <= 8) {
    return "8 horas";
  } else if (differenceInHours >= 0 && differenceInHours <= 24) {
    return "24 horas";
  } else if (differenceInHours >= 0 && differenceInHours <= 24 * 7) {
    // 1 semana
    return "1 semana";
  } else if (differenceInHours >= 0 && differenceInHours <= 24 * 30) {
    // 1 mes
    return "1 mes";
  } else if (differenceInHours >= 0 && differenceInHours <= 24 * 365) {
    // 1 año
    return "1 año";
  } else {
    return "Siempre";
  }
}

String calculateTimeToActivation(String deactivatedTimeString) {
  if (_prefs.getDisambleTimeIFF == "") {
    return "";
  }
  // Parseamos el string desactivado a un DateTime
  DateTime deactivatedTime = DateTime.parse(deactivatedTimeString).toLocal();

  // Obtenemos el DateTime actual
  DateTime now = DateTime.now();

  // Calculamos la diferencia entre el tiempo desactivado y el actual
  Duration difference = deactivatedTime.difference(now);

  // Verificamos si el tiempo desactivado es mayor que el actual
  if (difference.isNegative) {
    return 'El tiempo de activación ha pasado';
  }

  // Formateamos el tiempo restante en horas, minutos y segundos
  int hours = difference.inHours;
  int minutes = difference.inMinutes.remainder(60);
  int seconds = difference.inSeconds.remainder(60);

  String formattedTime = 'Tiempo restante: ';

  if (hours > 0) {
    formattedTime += '$hours horas';
  }

  if (hours > 0 && minutes > 0) {
    formattedTime += ', ';
  }

  if (minutes > 0) {
    formattedTime += '$minutes minutos';
  }

  if ((hours > 0 || minutes > 0) && seconds > 0) {
    formattedTime += '';
  }

  // if (seconds > 0) {
  //   formattedTime += '$seconds segundos';
  // }

  return formattedTime;
}

Duration timeDurationActivation(String deactivatedTimeString) {
  if (_prefs.getDisambleTimeIFF == "") {
    return const Duration(seconds: 0);
  }
  // Parseamos el string desactivado a un DateTime
  DateTime deactivatedTime = DateTime.parse(deactivatedTimeString).toLocal();

  // Obtenemos el DateTime actual
  DateTime now = DateTime.now();

  // Calculamos la diferencia entre el tiempo desactivado y el actual
  Duration difference = deactivatedTime.difference(now);

  // Verificamos si el tiempo desactivado es mayor que el actual
  if (difference.isNegative) {
    return const Duration(seconds: 0);
  }

  // Formateamos el tiempo restante en horas, minutos y segundos
  int hourst = difference.inHours;
  int minutes = difference.inMinutes.remainder(60);
  int seconds = difference.inSeconds.remainder(60);
  return Duration(hours: hourst, minutes: minutes);
}

String minutesToString(int minutes) {
  var hours = minutes / 60;

  if (hours > 0 && minutes > 0) {
    return '$minutes min';
  } else if (hours > 0) {
    return '$hours hora';
  } else {
    return '$minutes min';
  }
}

String uint8ListToString(String str) {
  List<int> list = str.codeUnits;
  Uint8List bytes = Uint8List.fromList(list);
  String string = String.fromCharCodes(bytes);

  return string;
}

Uint8List stringToUint8List(String str) {
  List<int> list = str.codeUnits;
  Uint8List bytes = Uint8List.fromList(list);

  return bytes;
}

String convertMinutesToHourAndMinutes(int minutes) {
  var hours = minutes / 60;
  var min = minutes % 60;

  return '${hours.toInt()} hora y $min min';
}

String jsonToString(String json, String format) {
  Jiffy.locale('es');

  var date = DateTime.parse(json);
  return date.toString();
}

DateTime jsonToDatetime(String json, String format) {
  Jiffy.locale('es');

  var date = DateTime.parse(json);
  return date;
}

List<String> dynamicToStringList(List<dynamic> dynamicList) {
  List<String> stringList = [];

  for (var d in dynamicList) {
    stringList.add(d);
  }

  return stringList;
}

List<String> getTaskIdList(String taskIdsJson) {
  List<String> taskIds = [];

  if (taskIdsJson.isNotEmpty) {
    taskIds = taskIdsJson.split(',');
    print('task_ids');
    print(taskIds);
  }

  return taskIds;
}

String getTaskIds(Map<String, dynamic> data) {
  String taskIds = "";

  if (data.isNotEmpty && data.values.isNotEmpty) {
    var taskIdJson = data['task_ids'].toString();
    if (taskIdJson != null && taskIdJson.isNotEmpty) {
      var taskIdList = taskIdJson.split(',');
      for (var taskId in taskIdList) {
        taskIds += '$taskId;';
      }
      if (taskIds.isNotEmpty) {
        taskIds = taskIds.substring(0, taskIds.length - 1);
      }
    }
  }

  return taskIds;
}

List<DateTime> dynamicToDateTimeList(List<dynamic> dynamicList) {
  List<DateTime> datetimeList = [];

  for (var d in dynamicList) {
    datetimeList.add(jsonToDatetime(d, getDefaultPattern()));
  }

  return datetimeList;
}

List<T> jsonToGenericList<T>(Map<String, dynamic> json, String name) {
  List<T> genericApiList = [];

  var genericList = json[name];

  for (var obj in genericList) {
    var jsonObj;
    if (name == "zoneRisk") {
      jsonObj = ZoneRiskApi.fromJson(obj);
    } else if (name == "contactRisk") {
      jsonObj = ContactRiskApi.fromJson(obj);
    } else if (name == "contact") {
      jsonObj = ContactApi.fromJson(obj);
    } else if (name == "activities") {
      jsonObj = ActivityDayApiResponse.fromJson(obj);
    } else if (name == "inactivityTimes") {
      jsonObj = UseMobilApi.fromJson(obj);
    } else if (name == "sleepHours") {
      jsonObj = UserRestApi.fromJson(obj);
    } else if (name == "logAlert") {
      jsonObj = AlertApi.fromJson(obj);
    }
    genericApiList.add(jsonObj as T);
  }

  return genericApiList;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

bool validatePhoneNumber(String phoneNumber) {
  // Expresión regular para validar el número de teléfono (formato internacional)
  final RegExp regex = RegExp(r'^\+(?:[0-9]●?){6,14}[0-9]$');
  return regex.hasMatch(phoneNumber);
}

bool validateEmail(String email) {
  // Expresión regular para validar el correo electrónico
  final RegExp regex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([a-z0-9]+(\.[a-z0-9]+)*\.)+[a-z]{2,}$');
  return regex.hasMatch(email);
}

Future<bool> getEnableIFF() async {
  await Jiffy.locale('es');
  var strDatetime = _prefs.getStartDateTimeDisambleIFF;
  if (strDatetime != "") {
    String deactivatedTime = _prefs.getDisambleIFF;

    if (deactivatedTime.isNotEmpty) {
      var minutes = deactivateTimeToMinutes(deactivatedTime);
      var datetime = Jiffy(strDatetime, getDefaultPattern()).dateTime;
      datetime.add(Duration(minutes: minutes));

      if (DateTime.now().isAfter(datetime)) {
        _prefs.setEnableIFF = true;
      }
    } else {
      _prefs.setEnableIFF = true;
    }
  }

  return _prefs.getEnableIFF;
}

Future<bool> requestPermission(Permission permission) async {
  bool permissionGranted = false;
  const maxRetryAttempts = 10;
  int retryAttempts = 0;

  while (!permissionGranted && retryAttempts < maxRetryAttempts) {
    try {
      PermissionStatus status = await permission.request();

      if (status.isPermanentlyDenied || status.isDenied) {
        // Permiso denegado o denegado permanentemente.
        // No se concede el permiso.
        permissionGranted = false;
      } else {
        // Permiso concedido.
        permissionGranted = true;
      }
    } catch (e) {
      // Manejar cualquier error que ocurra durante la solicitud de permisos.
      print(
          'Error al solicitar permisos: $e, cual fallo:${permission.toString()}');
      retryAttempts++;
      // Esperar un tiempo antes de intentar nuevamente (opcional).
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  return permissionGranted;
}

class PermissionService {
  static Completer<void>? _permissionSemaphore;

  static Future<bool> requestPermission(Permission permission) async {
    _permissionSemaphore ??= Completer<void>();
    // bool permissionGranted = false;
    // Esperar a que se libere el semáforo antes de continuar.
    await _permissionSemaphore!.future;

    try {
      // Establecer el semáforo como ocupado para bloquear otras solicitudes.
      _permissionSemaphore!.complete();

      // Realizar la solicitud de permisos.
      PermissionStatus status = await permission.request();

      // Manejar el resultado de la solicitud de permisos aquí.
      // ...
      if (status.isPermanentlyDenied || status.isDenied) {
        // Permiso denegado o denegado permanentemente.
        // No se concede el permiso.
        // permissionGranted = false;
        return false;
      } else {
        // Permiso concedido.
        // permissionGranted = true;
        return true;
      }
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante la solicitud de permisos.
      print('Error al solicitar permisos: $e');
      return false;
    } finally {
      // Reiniciar el semáforo para permitir que otras solicitudes continúen.
      _permissionSemaphore = Completer<void>();
    }
  }
}

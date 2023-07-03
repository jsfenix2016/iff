import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Page/Geolocator/Controller/configGeolocatorController.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

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

void makePayment() async {
  // FlutterPay flutterPay = FlutterPay();

  // String result = "Result will be shown here";
  // List<PaymentItem> items = [PaymentItem(name: "Premium user", price: 2.98)];

  // flutterPay.setEnvironment(environment: PaymentEnvironment.Test);

  // flutterPay.requestPayment(
  //   googleParameters: GoogleParameters(
  //     gatewayName: "example",
  //     gatewayMerchantId: "example_id",
  //   ),
  //   appleParameters:
  //       AppleParameters(merchantIdentifier: "merchant.flutterpay.example"),
  //   currencyCode: "USD",
  //   countryCode: "US",
  //   paymentItems: items,
  // );
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
  Uint8List bytesImages = const Base64Decoder().convert(urlImage);

  return Image.memory(bytesImages,
      fit: BoxFit.cover, width: double.infinity, height: 250.0);
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

DateTime parseDurationRow(String s) {
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

  String sDuration = "${temp.inHours}:${temp.inMinutes.remainder(60)}";
  DateTime pastDateTime = format.parse(sDuration);
  return pastDateTime;
}

DateTime parseContactRiskDate(String contactRiskDate) {
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

  var minutes = contactRiskDate;

  return DateTime(int.parse(year), int.parse(month), int.parse(day),
          int.parse(hour), int.parse(minutes))
      .toUtc();
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

  String sDuration = "${temp.inHours}:${temp.inMinutes.remainder(60)}";

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

  String sDuration = "${temp.inHours}:${temp.inMinutes.remainder(60)}";
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
          title: const Text("Informacion "),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              child: const Text("Ok"),
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

Container searchImageForIcon(String typeAction) {
  AssetImage name = const AssetImage('assets/images/Email.png');
  if (typeAction.contains("SMS")) {
    name = const AssetImage('assets/images/Email.png');
  } else if (typeAction.contains("inactividad")) {
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
  AssetImage name = const AssetImage('assets/images/Email.png');
  if (typeAction.contains("SMS")) {
    name = const AssetImage('assets/images/Email.png');
  } else if (typeAction.contains("inactividad")) {
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
    return Future.error('Location services are disabled.');
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
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.

  return await Geolocator.getCurrentPosition();
}

Future<bool> cameraPermissions(
    PreferencePermission acceptedCamera, BuildContext context) async {
  PermissionStatus permission = await Permission.camera.status;
  PreferencePermission prefsCamera = acceptedCamera;

  if (permission == PermissionStatus.denied &&
      prefsCamera == PreferencePermission.deniedForever) {
    showPermissionDialog(context, Constant.enablePermission);

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
    var contacts = await FlutterContacts.getContacts();
    // Set the list of contacts in the state
    contacts = await FlutterContacts.getContacts(
        withProperties: true, withPhoto: true);

    return contacts;
  }
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

  return '$date $hour:$minute:$second';
}

String rangeTimeToString(String from, String to) {
  var rangeTime = '$from-$to';
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
  var time = strTime.replaceAll(" min", "");
  time = time.replaceAll(" hora", "");

  if (strTime.contains('hora')) {
    return int.parse(time) * 60;
  }

  return int.parse(time);
}

int deactivateTimeToMinutes(String strTime) {
  var time = strTime.replaceAll(" hora", "");
  time = time.replaceAll(" horas", "");
  time = time.replaceAll(" semana", "");
  time = time.replaceAll(" mes", "");
  time = time.replaceAll(" año", "");

  if (strTime.contains('hora')) {
    return int.parse(time) * 60;
  } else if (strTime.contains('semana')) {
    return int.parse(time) * 60 * 24 * 7;
  } else if (strTime.contains('mes')) {
    return int.parse(time) * 60 * 24 * 30;
  } else if (strTime.contains('año')) {
    return int.parse(time) * 60 * 24 * 365;
  } else {
    return int.parse(time) * 60 * 24 * 365 * 10;
  }
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
    var minutes = deactivateTimeToMinutes(deactivatedTime);
    var datetime = Jiffy(strDatetime, getDefaultPattern()).dateTime;
    datetime.add(Duration(minutes: minutes));

    if (DateTime.now().isAfter(datetime)) {
      _prefs.setEnableIFF = true;
    }
  }

  return _prefs.getEnableIFF;
}

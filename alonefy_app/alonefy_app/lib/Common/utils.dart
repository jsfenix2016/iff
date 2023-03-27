import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Model/activitydaybd.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userPosition.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Model/userpositionbd.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Constant.dart';

// import 'package:flutter_pay/flutter_pay.dart';
final _prefs = PreferenceUser();

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
  var edad;
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

  var file;
  if (image == null) {
    return file;
  }
  file = File(image.path);
  return file;
}

Future inicializeHiveBD() async {
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDirectory.path);
  if (!Hive.isAdapterRegistered(UserPositionBDAdapter().typeId)) {
    Hive.registerAdapter(UserPositionBDAdapter());
  }

  if (!Hive.isAdapterRegistered(UserBDAdapter().typeId)) {
    Hive.registerAdapter(UserBDAdapter());
  }

  if (!Hive.isAdapterRegistered(ActivityDayBDAdapter().typeId)) {
    Hive.registerAdapter(ActivityDayBDAdapter());
  }

  if (!Hive.isAdapterRegistered(RestDayBDAdapter().typeId)) {
    Hive.registerAdapter(RestDayBDAdapter());
  }
  if (!Hive.isAdapterRegistered(ContactBDAdapter().typeId)) {
    Hive.registerAdapter(ContactBDAdapter());
  }
  if (!Hive.isAdapterRegistered(ContactRiskBDAdapter().typeId)) {
    Hive.registerAdapter(ContactRiskBDAdapter());
  }
  if (!Hive.isAdapterRegistered(ContactZoneRiskBDAdapter().typeId)) {
    Hive.registerAdapter(ContactZoneRiskBDAdapter());
  }
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
  int hours = 0;
  int minutes = 0;
  int micros;
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

  DateTime now = DateTime.now();
  var format = DateFormat("HH:mm");
  Duration durationAgo = Duration(days: 5, hours: 2, minutes: 30);
  String sDuration = "${temp.inHours}:${temp.inMinutes.remainder(60)}";
  DateTime pastDateTime = format.parse(sDuration);
  return pastDateTime;
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
  int hours = 0;
  int minutes = 0;
  int micros;
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

void mostrarAlerta(BuildContext context, String mensaje) {
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

User initUser() {
  return User(
      idUser: "0",
      name: "",
      lastname: "",
      email: "",
      telephone: "",
      gender: "",
      maritalStatus: "",
      styleLife: "",
      pathImage: "",
      age: '',
      country: '',
      city: '');
}

BoxDecoration decorationCustom() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment(0, 2),
      colors: <Color>[
        ColorPalette.principalView,
        ColorPalette.secondView,
      ],
      tileMode: TileMode.mirror,
    ),
  );
}

BoxDecoration decorationCustom2() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment(1, 0),
      colors: <Color>[
        ColorPalette.principalView,
        ColorPalette.secondView,
        ColorPalette.principalView,
      ],
      tileMode: TileMode.mirror,
    ),
  );
}

LinearGradient linerGradientButtonFilling() {
  return const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment(1, 0),
    colors: <Color>[
      ColorPalette.linerGradientText,
      ColorPalette.principal,
    ],
    tileMode: TileMode.mirror,
  );
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  if (_prefs.getAceptedSendLocation && _prefs.getUserPremium) {
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

  if (!_prefs.getAceptedSendLocation && !_prefs.getUserPremium) {
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

void showPermissionDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Abrir permisos"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text("Cerrar"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Abrir"),
            onPressed: () => openAppSettings(),
          )
        ],
      );
    },
  );
}

void showSaveAlert(BuildContext context, String title, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("Ok"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

String getDefaultPattern() {
  return 'EEEE, d MMMM yyyy';
}

String getShortPattern() {
  return 'EEEE dd/MM/yyyy';
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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

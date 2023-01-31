import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ifeelefine/Model/activitydaybd.dart';
import 'package:ifeelefine/Model/restdaybd.dart';
import 'package:ifeelefine/Model/userPosition.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Model/userpositionbd.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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

String diaConvert(String dia) {
  var tempDia = '';
  switch (dia) {
    case "L":
      return 'Lunes';
    case "M":
      return 'Martes';
    case "X":
      return 'Miercoles';
    case "J":
      return 'Jueves';
    case "V":
      return 'Viernes';
    case "S":
      return 'Sabado';
    case "D":
      return 'Domingo';
    default:
  }
  return tempDia;
}

// List<UserPosition> tempPosition = <UserPosition>[];

// List<UserPosition> get getlistPositionTemp {
//   return tempPosition;
// }

// void slistPositionTemp(List<UserPosition> value) {
//   tempPosition = value;
// }

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

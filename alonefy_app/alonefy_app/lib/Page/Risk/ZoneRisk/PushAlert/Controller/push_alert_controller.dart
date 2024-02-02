import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Model/ApiRest/ZoneRiskApi.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/CancelAlert/PageView/cancelAlert.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/Service/zone_risk_service.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import '../../../../../Controllers/mainController.dart';
import '../../../../../Data/hive_constant_adapterInit.dart';

class PushAlertController extends GetxController {
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

  void _saveVideoInBackground(String path) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(
      _backgroundTask,
      {'path': path, 'port': receivePort.sendPort},
    );

    receivePort.listen((data) {
      print('Mensaje del isolate: $data');
    });
  }

  void _backgroundTask(dynamic message) async {
    final String path = message['path'];
    final SendPort sendPort = message['port'];
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    try {
      // Realiza la tarea en segundo plano, como guardar el video.

      // Supongamos que GallerySaver.saveVideo lanza una excepción si falla
      await GallerySaver.saveVideo(path);

      // Envía un mensaje de vuelta al hilo principal
      sendPort.send('Video guardado exitosamente');
    } catch (error) {
      // Maneja cualquier excepción aquí
      sendPort.send('Error al guardar el video: $error');
    }
  }

  void _saveBDInBackground(ContactZoneRiskBD contact, UserBD user) async {
    final receivePort = ReceivePort();
    // await Isolate.spawn(
    //   _backgroundTaskSaveBD,
    //   {'contact': contact, 'UserBD': user, 'port': receivePort.sendPort},
    // );

    // receivePort.listen((data) {
    //   print('Mensaje del isolate: $data');
    // });

    try {
      await Isolate.run(readAndParseJson(
          {'contact': contact, 'UserBD': user, 'port': receivePort.sendPort}));
    } on StateError catch (e, s) {
      print(e.message); // In a bad state!
      // Contains "eventualError"
      print(s);
    }
  }

  static readAndParseJson(dynamic message) async {
    final ContactZoneRiskBD contact = message['contact'];
    final UserBD user = message['UserBD'];
    final SendPort sendPort = message['port'];

    try {
      // Realiza la tarea en segundo plano, como guardar el video.
      await inicializeHiveBD();
      // Supongamos que GallerySaver.saveVideo lanza una excepción si falla
      await const HiveDataRisk().updateContactZoneRisk(contact);

      var url = await ZoneRiskService().getVideoUrl(
          user.telephone.contains('+34')
              ? user.telephone.replaceAll("+34", "")
              : user.telephone,
          contact.id);

      if (url != null && url.isNotEmpty) {
        ZoneRiskService().updateVideo(url, contact.video);
      }

      // Envía un mensaje de vuelta al hilo principal
      sendPort.send('user guardado exitosamente');
    } catch (error) {
      // Maneja cualquier excepción aquí
      sendPort.send('Error al guardar el user: $error');
    }
  }

  void _backgroundTaskSaveBD(dynamic message) async {
    final ContactZoneRiskBD contact = message['contact'];
    final UserBD user = message['UserBD'];
    final SendPort sendPort = message['port'];
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    try {
      // Realiza la tarea en segundo plano, como guardar el video.
      await inicializeHiveBD();
      // Supongamos que GallerySaver.saveVideo lanza una excepción si falla
      await const HiveDataRisk().updateContactZoneRisk(contact);

      var url = await ZoneRiskService().getVideoUrl(
          user.telephone.contains('+34')
              ? user.telephone.replaceAll("+34", "")
              : user.telephone,
          contact.id);

      if (url != null && url.isNotEmpty) {
        ZoneRiskService().updateVideo(url, contact.video);
      }

      // Envía un mensaje de vuelta al hilo principal
      sendPort.send('user guardado exitosamente');
    } catch (error) {
      // Maneja cualquier excepción aquí
      sendPort.send('Error al guardar el user: $error');
    }
  }

  Future<List<String>> updateVideo(
      ContactZoneRiskBD contact, String path, String pathFront) async {
    PreferenceUser _prefs = PreferenceUser();
    await _prefs.initPrefs();
    if (path.isNotEmpty) {
      _saveVideoInBackground(path);
      contact.video = await convertImageData(path);
    }
    if (pathFront.isNotEmpty) {
      // await GallerySaver.saveVideo(pathFront);
      _saveVideoInBackground(pathFront);
      // contact.video = await convertImageData(pathFront);
    }
    _prefs.setSelectContactRisk = contact.id;
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();

    var taskIds = await ZoneRiskService()
        .createZoneRiskAlert(ZoneRiskApi.fromZoneRisk(contact, user.telephone));
    if (taskIds.isNotEmpty) {
      Get.offAll(
        CancelAlertPage(taskIds: taskIds),
      );
    }
    if (contact.save) {
      _saveBDInBackground(contact, user);
    }

    return taskIds;
  }

  Future<Uint8List> convertImageData(String pathv) async {
    Uint8List? bytes;

    var path = File(pathv);

    bytes = path.readAsBytesSync();

    return bytes;
  }
}

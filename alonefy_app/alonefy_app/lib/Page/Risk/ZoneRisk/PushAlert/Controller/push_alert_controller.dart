import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/ApiRest/ZoneRiskApi.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Model/historialbd.dart';

import 'package:ifeelefine/Model/videopresignedbd.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/CancelAlert/PageView/cancelAlert.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/Service/zone_risk_service.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:uuid/uuid.dart';

import '../../../../../Controllers/mainController.dart';
import '../../../../../Data/hive_constant_adapterInit.dart';

class PushAlertController extends GetxController {
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  Future<void> saveActivityLog(ContactZoneRiskBD contact) async {
    PreferenceUser prefs = PreferenceUser();
    var uuid = const Uuid().v4();
    HistorialBD mov = HistorialBD(
        id: 0,
        type: "Zona - Iniciada",
        time: DateTime.now(),
        video: contact.video,
        listVideosPresigned: contact.listVideosPresigned,
        groupBy: uuid);
    // MainController().saveActivityLog(mov);
    const HiveData().saveLogsHistorialBD(mov);
    prefs.setIdZoneGroup = uuid;
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

  // void _saveBDInBackground(ContactZoneRiskBD contact, UserBD user) async {
  //   final receivePort = ReceivePort();

  //   try {
  //     await Isolate.spawn(
  //       _backgroundTaskSaveBD,
  //       {'contact': contact, 'UserBD': user, 'port': receivePort.sendPort},
  //     );

  //     receivePort.listen((data) {
  //       print('Mensaje del isolate: $data');
  //     });
  //   } catch (e, s) {
  //     print(e); // Imprime el error
  //     print(s); // Imprime el stack trace
  //   }
  // }

  // void _backgroundTaskSaveBD(dynamic message) async {
  //   final ContactZoneRiskBD contact = message['contact'];
  //   final UserBD user = message['UserBD'];
  //   final SendPort sendPort = message['port'];

  //   try {
  //     await readAndParseJson(
  //         {'contact': contact, 'UserBD': user, 'port': sendPort});
  //   } catch (e) {
  //     print(e); // Maneja cualquier excepción aquí
  //   }
  // }

  // Future<void> readAndParseJson(dynamic message) async {
  //   final ContactZoneRiskBD contact = message['contact'];
  //   final UserBD user = message['UserBD'];
  //   final SendPort sendPort = message['port'];

  //   try {
  //     // Realiza la tarea en segundo plano, como guardar el video.
  //     await inicializeHiveBD();
  //     await const HiveDataRisk().updateContactZoneRisk(contact);

  //     var url = await ZoneRiskService().getVideoUrl(
  //       user.telephone.contains('+34')
  //           ? user.telephone.replaceAll("+34", "")
  //           : user.telephone,
  //       contact.id,
  //     );

  //     if (url != null && url.isNotEmpty) {
  //       ZoneRiskService().updateVideoApi(url, contact.video);
  //     }

  //     // Envía un mensaje de vuelta al hilo principal
  //     sendPort.send('user guardado exitosamente');
  //   } catch (error) {
  //     // Maneja cualquier excepción aquí
  //     sendPort.send('Error al guardar el user: $error');
  //   }
  // }

  // void _backgroundTaskSaveBD2(dynamic message) async {
  //   final ContactZoneRiskBD contact = message['contact'];
  //   final UserBD user = message['UserBD'];
  //   final SendPort sendPort = message['port'];
  //   BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  //   try {
  //     // Realiza la tarea en segundo plano, como guardar el video.
  //     await inicializeHiveBD();
  //     // Supongamos que GallerySaver.saveVideo lanza una excepción si falla
  //     await const HiveDataRisk().updateContactZoneRisk(contact);

  //     var url = await ZoneRiskService().getVideoUrl(
  //         user.telephone.contains('+34')
  //             ? user.telephone.replaceAll("+34", "")
  //             : user.telephone,
  //         contact.id);

  //     if (url != null && url.isNotEmpty) {
  //       ZoneRiskService().updateVideoApi(url, contact.video);
  //     }

  //     // Envía un mensaje de vuelta al hilo principal
  //     sendPort.send('user guardado exitosamente');
  //   } catch (error) {
  //     // Maneja cualquier excepción aquí
  //     sendPort.send('Error al guardar el user: $error');
  //   }
  // }

  Future<List<String>> updateVideo(
      ContactZoneRiskBD contact, String path, String pathFront) async {
    PreferenceUser prefs = PreferenceUser();
    await prefs.initPrefs();
    final receivePort = ReceivePort();
    var zonaTemp = await const HiveDataRisk().getcontactZoneRiskbdID(contact);
    if (path.isNotEmpty) {
      // _saveVideoInBackground(path);

      zonaTemp.video = await convertImageData(path);
      VideoPresignedBD tempPre = VideoPresignedBD(
          modified: zonaTemp.createDate.toString(),
          url: path,
          videoDown: await convertImageData(path));

      List<VideoPresignedBD> listvideobd = [];
      listvideobd.insert(0, tempPre);

      if (zonaTemp.listVideosPresigned == null) {
        zonaTemp.listVideosPresigned = listvideobd;
      } else {
        zonaTemp.listVideosPresigned!.add(tempPre);
      }

      // await saveActivityLog(contact);

      await Isolate.spawn(
        _backgroundTask,
        {'path': path, 'port': receivePort.sendPort},
      );
    }
    if (pathFront.isNotEmpty) {
      // _saveVideoInBackground(pathFront);
      await Isolate.spawn(
        _backgroundTask,
        {'path': pathFront, 'port': receivePort.sendPort},
      );
    }

    receivePort.listen((data) {
      if (kDebugMode) {
        print('Mensaje del isolate: $data');
      }
    });

    prefs.setSelectContactRisk = contact.id;
    final MainController mainController = Get.put(MainController());
    var user = await mainController.getUserData();
    if (contact.save) {
      // _saveBDInBackground(contact, user);
      await inicializeHiveBD();
      await const HiveDataRisk().updateContactZoneRisk(zonaTemp);

      var url = await ZoneRiskService().getVideoUrl(
        user.telephone.contains('+34')
            ? user.telephone.replaceAll("+34", "")
            : user.telephone,
        contact.id,
      );

      if (url != null && url.isNotEmpty) {
        ZoneRiskService().updateVideoApi(url, contact.video);
      }
    }
    await saveActivityLog(contact);
    var taskIds = await ZoneRiskService().createZoneRiskAlert(
        ZoneRiskApi.fromZoneRisk(zonaTemp, user.telephone));
    if (taskIds.isNotEmpty) {
      Get.offAll(
        CancelAlertPage(taskIds: taskIds),
      );
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

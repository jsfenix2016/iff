import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:get/get.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Data/hiveRisk_data.dart';
import 'package:ifeelefine/Data/hive_constant_adapterInit.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/VideoPresignedUrls.dart';

import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Model/videopresignedbd.dart';
import 'package:ifeelefine/Page/Disamble/Controller/disambleController.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/Service/zone_risk_service.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import 'package:uuid/uuid.dart';

import '../../../../../Controllers/mainController.dart';
import '../../../../../Model/ApiRest/ZoneRiskApi.dart';

class EditZoneController extends GetxController {
  Future<void> saveActivityLog(ContactZoneRiskBD contact) async {
    var uuid = Uuid().v4();
    LogAlertsBD mov = LogAlertsBD(
        id: 0,
        type: "Zona de riesgo",
        time: DateTime.now(),
        video: contact.video,
        groupBy: uuid);
    MainController().saveUserRiskLog(mov);
    prefs.setIdZoneGroup = uuid;
    await const HiveData().saveUserPositionBD(mov);
  }

  Future<bool> saveContactZoneRisk(
      BuildContext context, ContactZoneRiskBD contact) async {
    try {
      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      var con = ZoneRiskApi.fromZoneRisk(contact, user.telephone);
      var contactZoneRiskApi =
          await ZoneRiskService().createContactZoneRisk(con);
      if (contact.photo != null &&
          contactZoneRiskApi != null &&
          contactZoneRiskApi.awsUploadCustomContactPresignedUrl.isNotEmpty) {
        await ZoneRiskService().updateImage(
            contactZoneRiskApi.awsUploadCustomContactPresignedUrl,
            contact.photo);
      }
      if (contactZoneRiskApi != null) {
        contact.id = contactZoneRiskApi.id;
        await const HiveDataRisk().saveContactZoneRisk(contact);

        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> updateContactZoneRisk(
      BuildContext context, ContactZoneRiskBD contact) async {
    try {
      final MainController mainController = Get.put(MainController());
      var user = await mainController.getUserData();
      var con = ZoneRiskApi.fromZoneRisk(contact, user.telephone);
      var zoneRiskApiResponse =
          await ZoneRiskService().updateZoneRisk(con, contact.id);

      if (contact.photo != null &&
          zoneRiskApiResponse != null &&
          zoneRiskApiResponse.awsUploadCustomContactPresignedUrl.isNotEmpty) {
        await ZoneRiskService().updateImage(
            zoneRiskApiResponse.awsUploadCustomContactPresignedUrl,
            contact.photo);
      }

      var save = await const HiveDataRisk().updateContactZoneRisk(contact);

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  late List<VideoPresignedBD> listvideobd = [];
  Future<void> saveFromApi(List<ZoneRiskApi> contactsZoneRiskApi) async {
    for (var contactZoneRiskApi in contactsZoneRiskApi) {
      var bytes;
      if (contactZoneRiskApi.awsDownloadCustomContactPresignedUrl != null &&
          contactZoneRiskApi.awsDownloadCustomContactPresignedUrl.isNotEmpty) {
        bytes = await ZoneRiskService().getZoneRiskImage(
            contactZoneRiskApi.awsDownloadCustomContactPresignedUrl);
        print(bytes);
      }
      Uint8List? videoBytes;

      VideoPresignedBD tempPre = VideoPresignedBD(modified: '', url: '');
      if (contactZoneRiskApi.awsDownloadVideoPresignedUrls != null &&
          contactZoneRiskApi.awsDownloadVideoPresignedUrls.isNotEmpty) {
        videoBytes = await ZoneRiskService().getZoneRiskImage(
            contactZoneRiskApi.awsDownloadVideoPresignedUrls.first.url);

        for (var element in contactZoneRiskApi.awsDownloadVideoPresignedUrls) {
          Uint8List? videoDown =
              await ZoneRiskService().getZoneRiskImage(element.url);
          tempPre = VideoPresignedBD(
              modified: element.modified,
              url: element.url,
              videoDown: videoDown);
          listvideobd.add(tempPre);
        }
      }
      ContactZoneRiskBD contact = ContactZoneRiskBD(
          id: contactZoneRiskApi.id,
          photo: bytes,
          name: contactZoneRiskApi.name,
          phones: contactZoneRiskApi.customContactPhoneNumber,
          sendLocation: contactZoneRiskApi.sendlocation,
          sendWhatsapp: contactZoneRiskApi.notifyPredefinedContacts,
          code: "",
          isActived: true,
          sendWhatsappContact:
              contactZoneRiskApi.customContactWhatsappNotification,
          callme: contactZoneRiskApi.customContactVoiceNotification,
          save: false,
          createDate: DateTime.now(),
          video: videoBytes,
          listVideosPresigned: listvideobd);
      await inicializeHiveBD();
      await const HiveDataRisk().saveContactZoneRisk(contact);
    }
  }
}

 // RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
//final receivePort = ReceivePort();

  // void _backgroundTask(dynamic message) async {
  //   final String path = message['path'];
  //   final SendPort sendPort = message['port'];
  //   final ContactZoneRiskBD contact = message['ContactZoneRiskBD'];
  //   ZoneRiskApi zonerisk = message['contactZoneRiskApi'];
  //   BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  //   try {
  //     // Realiza la tarea en segundo plano, como guardar el video.

  //     // Supongamos que GallerySaver.saveVideo lanza una excepción si falla
  //     // await GallerySaver.saveVideo(path);

  //     var videoBytes = await ZoneRiskService()
  //         .getZoneRiskImage(zonerisk.awsDownloadVideoPresignedUrls.first.url);

  //     contact.video = videoBytes;

  //     await const HiveDataRisk().updateContactZoneRisk(contact);
  //     // Envía un mensaje de vuelta al hilo principal
  //     sendPort.send('Video guardado exitosamente');
  //   } catch (error) {
  //     // Maneja cualquier excepción aquí
  //     sendPort.send('Error al guardar el video: $error');
  //   }
  // }
 // print(videoBytes);
        // videoBytes = await ZoneRiskService().getZoneRiskImage(
        //     contactZoneRiskApi.awsDownloadVideoPresignedUrls.first.url);
        // await inicializeHiveBD();
        // await Isolate.spawn(
        //   _backgroundTask,
        //   {
        //     'path': contactZoneRiskApi.awsDownloadVideoPresignedUrls.first.url,
        //     'port': receivePort.sendPort,
        //     'contactZoneRiskApi': contactZoneRiskApi,
        //     'ContactZoneRiskBD': contact,
        //   },
        // );
        // receivePort.listen((data) {
        //   print('Mensaje del isolate: $data');
        // });
        // listvideobd = await Future.wait(
        //     contactZoneRiskApi.awsDownloadVideoPresignedUrls.map((video) async {
        //   // Aquí realizas la conversión de VideoPresigned a VideoPresignedBD
        //   return VideoPresignedBD(
        //     // Asigna los valores adecuados a los campos de VideoPresignedBD
        //     // por ejemplo:
        //     url: video.url,
        //     modified: video.modified,
        //     videoDown: await ZoneRiskService().getZoneRiskImage(video.url),
        //     // Puedes agregar cualquier otra lógica necesaria para la conversión
        //   );
        // }).toList());
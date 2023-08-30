import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/PermissionUser/Controller/permission_controller.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Geolocator/Controller/configGeolocatorController.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

final _prefs = PreferenceUser();
final _locationController = Get.put(ConfigGeolocatorController());

class PermitionUserPage extends StatefulWidget {
  const PermitionUserPage({super.key});

  @override
  State<PermitionUserPage> createState() => _PermitionUserPageState();
}

class _PermitionUserPageState extends State<PermitionUserPage> {
  List<String> permissionsName = [
    //'Permitir trabajar la App en segundo plano',
    'Permitir notificaciones',
    'Permitir el uso de la cámara',
    'Permitir acceso a contactos',
    'Permitir compartir ubicación del smartphone',
    'Permitir emitir sonido de alerta en el estado silencio',
    'Permitir envío de SMS y llamadas'
  ];
  List<Permission> permissions = [
    //Permission.accessMediaLocation,
    Permission.notification,
    Permission.camera,
    Permission.contacts,
    Permission.location,
    Permission.scheduleExactAlarm,
    Permission.sms
  ];
  late bool accessContact = false;
  List<bool> permissionStatus = [
    //false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  void requestPermission(int index) async {
    PermissionStatus permission = await permissions[index].request();

    if (permission.isPermanentlyDenied) {
      showPermissionDialog(context, Constant.enablePermission);
    } else if (permission.isDenied) {
    } else {
      setState(() {
        permissionStatus[index] = true;
      });
    }

    if (permissions[index] == Permission.scheduleExactAlarm) {
      if (await checkScheduleExactAlarmPermission()) {
        setState(() {
          permissionStatus[index] = true;
        });
      }
    }

    if (permissions[index] == Permission.sms) {
      setState(() {
        permissionStatus[index] = true;
      });
    }
  }

  Future<bool> checkScheduleExactAlarmPermission() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var sdkInt = androidInfo.version.sdkInt;
      print('Android (SDK $sdkInt)');

      return sdkInt < 33;
    }

    return true;
  }

  void savePermissions() async {
    var response =
        await PermissionController().savePermissions(permissionStatus);

    if (response) {
      showSaveAlert(context, "Permisos guardados",
          "Los permisos se han guardado correctamente.");
    }
  }

  void getPermissions() async {
    for (var i = 0; i < permissions.length; i++) {
      PermissionStatus status = await permissions[i].status;
      switch (i) {
        case 0:
          permissionStatus[i] = status.isGranted &&
              _prefs.getAcceptedNotification == PreferencePermission.allow;
          break;
        case 1:
          permissionStatus[i] = status.isGranted &&
              _prefs.getAcceptedCamera == PreferencePermission.allow;
          break;
        case 2:
          permissionStatus[i] = status.isGranted &&
              _prefs.getAcceptedContacts == PreferencePermission.allow;
          break;
        case 3:
          permissionStatus[i] = status.isGranted &&
              _prefs.getAcceptedSendLocation == PreferencePermission.allow;
          break;
        case 4:
          permissionStatus[i] = _prefs.getAcceptedScheduleExactAlarm ==
              PreferencePermission.allow;
          break;
        case 5:
          permissionStatus[i] = _prefs.getAceptedSendSMS;
          break;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermissions();
    // _getContacts();
    //showPermition();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    RedirectViewNotifier.setStoredContext(context);
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Configuración",
          style: textForTitleApp(),
        ),
      ),
      body: Container(
        decoration: decorationCustom(),
        child: Stack(
          children: [
            Positioned(
              top: 32,
              width: size.width,
              child: Center(
                child: Text('Ajustar mi Smartphone',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 22.0,
                      wordSpacing: 1,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
              child: ListView.builder(
                itemCount: permissionsName.length,
                itemBuilder: (context, index) {
                  String permission = permissionsName[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: permissionStatus[index],
                        activeColor: ColorPalette.activeSwitch,
                        trackColor: CupertinoColors.inactiveGray,
                        onChanged: (bool value) {
                          if (value) {
                            requestPermission(index);
                          } else {
                            setState(() {
                              permissionStatus[index] = value;
                            });
                            //savePermission(index, value);
                          }
                        },
                      ),
                    ),
                    title: Text(
                        style: GoogleFonts.barlow(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: CupertinoColors.white,
                        ),
                        permissionsName[index]),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 20,
              right: 32,
              child: Container(
                decoration: const BoxDecoration(
                  color: ColorPalette.principal,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                width: 138,
                height: 42,
                child: Center(
                  child: TextButton(
                    child: Text('Guardar',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 16.0,
                          wordSpacing: 1,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        )),
                    onPressed: () async {
                      savePermissions();
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 32,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: ColorPalette.principal),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                width: 138,
                height: 42,
                child: Center(
                  child: TextButton(
                    child: Text('Cancelar',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 16.0,
                          wordSpacing: 1,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

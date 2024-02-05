import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/PermissionUser/Controller/permission_controller.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Geolocator/Controller/configGeolocatorController.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

final _prefs = PreferenceUser();

class PermitionUserPage extends StatefulWidget {
  const PermitionUserPage({super.key});

  @override
  State<PermitionUserPage> createState() => _PermitionUserPageState();
}

class _PermitionUserPageState extends State<PermitionUserPage> {
  final List<String> permissionsName = [
    //'Permitir trabajar la App en segundo plano',
    'Permitir notificaciones',
    'Permitir el uso de la cámara',
    'Permitir acceso a contactos',
    'Permitir compartir ubicación del smartphone',
    'Permitir emitir sonido de alerta en el estado silencio',
  ];

  final List<Permission> permissions = [
    Permission.notification,
    Permission.camera,
    Permission.contacts,
    Permission.location,
    Permission.scheduleExactAlarm,
  ];

  late List<bool> permissionStatus;

  @override
  void initState() {
    super.initState();
    NotificationCenter().subscribe('refreshPermission', _refreshPermission);
    permissionStatus = List.generate(permissions.length, (_) => false);
    getPermissions();
    _refreshPermission();
    starTap();
  }

  void _refreshPermission() async {
    // Retrieve the list of contacts from the device
    // var contacts = await FlutterContacts.getContacts();
    // Set the list of contacts in the state
    await _prefs.initPrefs();
    // permissionStatusI = _prefs.getlistConfigPage;
    _prefs.refreshData();
  }

  void requestPermission(int index) async {
    final PermissionStatus permission = await permissions[index].request();

    if (permission.isPermanentlyDenied) {
      showPermissionDialog(context, Constant.enablePermission);
    } else if (permission.isGranted) {
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

    if (permissions[index] == Permission.contacts) {
      contactlist = await getContacts(context);
      setState(() {
        permissionStatus[index] = true;
      });
    }
  }

  void requestPermissionDenied(int index) async {
    final PermissionStatus permission = await permissions[index].request();

    if (permission.isPermanentlyDenied) {
      showPermissionDialog(context, Constant.enablePermission);
    } else if (permission.isDenied) {
    } else {
      setState(() {
        permissionStatus[index] = false;
      });
    }

    if (permissions[index] == Permission.contacts) {
      contactlist = [];
      _prefs.getAcceptedContacts == PreferencePermission.denied;
      setState(() {
        permissionStatus[index] = false;
      });
    }
  }

  Future<bool> checkScheduleExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      print('Android (SDK $sdkInt)');

      return sdkInt < 33;
    }

    return true;
  }

  void savePermissions() async {
    final response =
        await PermissionController().savePermissions(permissionStatus);

    if (response) {
      showSaveAlert(context, "Permisos guardados",
          "Los permisos se han guardado correctamente.");
    }
  }

  void getPermissions() async {
    for (var i = 0; i < permissions.length; i++) {
      final PermissionStatus status = await permissions[i].status;
      switch (i) {
        case 0:
          print(
              "Notification: ${_prefs.getAcceptedNotification}, isGranted: ${status.isGranted}");
          permissionStatus[i] = status.isGranted;
          print("Notification: ${permissionStatus[i]}");
          break;
        case 1:
          print(
              "AcceptedCamera: ${_prefs.getAcceptedCamera}, isGranted: ${status.isGranted}");
          permissionStatus[i] = status.isGranted &&
                  _prefs.getAcceptedCamera == PreferencePermission.allow ||
              _prefs.getAcceptedCamera == PreferencePermission.init;
          print("AcceptedCamera: ${permissionStatus[i]}");
          break;
        case 2:
          print(
              "getAcceptedContacts: ${_prefs.getAcceptedContacts}, isGranted: ${status.isGranted}");
          final si = status.isGranted;
          permissionStatus[i] = si;
          print("getAcceptedContacts: ${permissionStatus[i]}");
          break;
        case 3:
          print(
              "getAcceptedSendLocation: ${_prefs.getAcceptedSendLocation}, isGranted: ${status.isGranted}");
          permissionStatus[i] = status.isGranted;
          print("getAcceptedSendLocation: ${permissionStatus[i]}");
          break;
        case 4:
          print(
              "getAcceptedScheduleExactAlarm: ${_prefs.getAcceptedScheduleExactAlarm}, isGranted: ${status.isGranted}");
          permissionStatus[i] = status.isGranted;
          print("getAcceptedScheduleExactAlarm: ${permissionStatus[i]}");
          break;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    RedirectViewNotifier.setStoredContext(context);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.brown,
        title: Text(
          Constant.titleNavBar,
          style: textForTitleApp(),
        ),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
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
                    return ListTile(
                      contentPadding:
                          const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
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
                              requestPermissionDenied(index);
                              setState(() {
                                permissionStatus[index] = value;
                              });
                            }
                          },
                        ),
                      ),
                      title: Text(permissionsName[index],
                          style: GoogleFonts.barlow(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: CupertinoColors.white,
                          )),
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
      ),
    );
  }
}

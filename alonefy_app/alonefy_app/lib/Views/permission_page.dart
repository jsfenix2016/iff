import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:permission_handler/permission_handler.dart';

class PermitionUserPage extends StatefulWidget {
  const PermitionUserPage({super.key});

  @override
  State<PermitionUserPage> createState() => _PermitionUserPageState();
}

class _PermitionUserPageState extends State<PermitionUserPage> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  late final Permission _permission;
  List<String> permissions = [
    'Camera',
    'Location',
    'Acceso a mis contacts',
    'Permitir uso en segundo plano',
    'Permitir notificaciones',
    'Compartir mi ubicacion',
    'Sonido en silencio',
    'Permitir acceso a fotos'
  ];
  late bool accessContact = false;
  Map<String, bool> permissionStatus = {
    'Camera': false,
    'Location': false,
    'Acceso a mis contacts': false,
    'Permitir uso en segundo plano': false,
    'Permitir notificaciones': false,
    'Compartir mi ubicacion': false,
    'Sonido en silencio': false,
    'Permitir acceso a fotos': false
  };

  void togglePermission(String permission) {
    setState(() {
      permissionStatus[permission] = !permissionStatus[permission]!;
    });
  }

  void showPermition() async {
    // var status = await Permission.camera.status;
    // var statusContacts = await Permission.contacts.status;
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.contacts,
      Permission.camera,
      Permission.notification,
      Permission.scheduleExactAlarm,
      Permission.mediaLibrary
    ].request();

    print(statuses[Permission.location]);
    var allpermition = print(statuses);

    PermissionStatus result;
    // In Android we need to request the storage permission,
    // while in iOS is the photos permission
    if (Platform.isAndroid) {
      result = await Permission.contacts.request();
    } else {
      result = await Permission.contacts.request();
    }

    PermissionStatus status = await Permission.contacts.request();
    if (status.isDenied == true) {
      print("preguntar");
    } else {
      print(status.isDenied);
    }

    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      print(result.isDenied);
    }
    final hasPermission = await _geolocatorPlatform.checkPermission();
    print(hasPermission);

    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      // Use location.
      print(result.isDenied);
    }
    print(result.isDenied);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getContacts();
    showPermition();
  }

  Widget _createButtonSave() {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.principal)),
      label: const Text("Guardar"),
      icon: const Icon(
        Icons.save,
      ),
      onPressed: (() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PermitionUserPage()),
        );
      }),
    );
  }

  Widget _createButtonNext() {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.principal)),
      label: const Text("Cancel"),
      icon: const Icon(
        Icons.cancel,
      ),
      onPressed: (() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PermitionUserPage()),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Permisos que se usan en la app'),
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: permissions.length,
              itemBuilder: (context, index) {
                String permission = permissions[index];
                return SwitchListTile(
                  title: Text(permission),
                  value: permissionStatus[permission]!,
                  onChanged: (value) => togglePermission(permission),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                width: size.width,
                height: 100,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _createButtonNext(),
                        const SizedBox(
                          width: 50,
                        ),
                        _createButtonSave(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

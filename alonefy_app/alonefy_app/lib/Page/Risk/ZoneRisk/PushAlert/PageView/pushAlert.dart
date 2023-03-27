import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Page/FallDetected/Controller/fall_detectedController.dart';

import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/CancelAlert/PageView/cancelAlert.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

class PushAlertPage extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const PushAlertPage({Key? key, required this.contactZone}) : super(key: key);

  /// Utility method to create a page with the Baseflow templating.
  final ContactZoneRiskBD contactZone;
  @override
  State<PushAlertPage> createState() => _PushAlertPageState();
}

class _PushAlertPageState extends State<PushAlertPage> {
  final FallDetectedController fallVC = Get.put(FallDetectedController());

  late bool isActive = false;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<void> _determinePosition() async {}

  Future _checkPermission() async {}

  @override
  void initState() {
    super.initState();

    _checkPermission();
  }

  bool isMenu = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: isMenu
          ? AppBar(
              backgroundColor: Colors.black,
              title: const Text('Alerta zona de riesgo'),
            )
          : null,
      body: GestureDetector(
        onTapDown: (details) {
          // El usuario ha tocado la pantalla
          print('El usuario ha tocado la pantalla');
        },
        onTapUp: (details) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CancelAlertPage(
                contactRisk: widget.contactZone,
              ),
            ),
          );
          // El usuario ha dejado de tocar la pantalla
          print('El usuario ha dejado de tocar la pantalla');
        },
        onPanEnd: (details) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CancelAlertPage(
                contactRisk: widget.contactZone,
              ),
            ),
          );
          // El usuario ha dejado de tocar la pantalla después de haber arrastrado el dedo por la pantalla
          print(
              'El usuario ha dejado de tocar la pantalla después de haber arrastrado el dedo por la pantalla');
        },
        child: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Positioned(
                top: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 347,
                      width: size.width,
                      child: Image.asset(
                        fit: BoxFit.fill,
                        scale: 0.5,
                        'assets/images/alertButton.png',
                        height: 340,
                        width: 340,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 150,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    height: 100,
                    width: size.width,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Mantén pulsada la pantalla en todo momento.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 24.0,
                          wordSpacing: 1,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(75, 72, 72, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

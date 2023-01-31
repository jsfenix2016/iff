import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/FallDetected/Controller/fall_detectedController.dart';

import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

class FallActivationPage extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const FallActivationPage({Key? key}) : super(key: key);

  /// Utility method to create a page with the Baseflow templating.

  @override
  _FallActivationPageState createState() => _FallActivationPageState();
}

class _FallActivationPageState extends State<FallActivationPage> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: isMenu
            ? AppBar(
                backgroundColor: ColorPalette.secondView,
                title: const Text('Detectar caidas'),
              )
            : null,
        body: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 104.0),
                      child: Text(
                        'Detectar caidas.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 24.0,
                          wordSpacing: 1,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          child: Image.asset(
                            fit: BoxFit.fill,
                            scale: 0.5,
                            'assets/images/Group 1006.png',
                            height: 400,
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 40,
                left: 70,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevateButtonFilling(
                    onChanged: (value) {
                      fallVC.saveDetectedFall(context, value);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    mensaje: 'Activar',
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

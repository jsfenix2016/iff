import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Page/FallDetected/Controller/fall_detectedController.dart';

import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';

class FallActivationPager extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const FallActivationPager({Key? key}) : super(key: key);

  /// Utility method to create a page with the Baseflow templating.

  @override
  _FallActivationPagerState createState() => _FallActivationPagerState();
}

class _FallActivationPagerState extends State<FallActivationPager> {
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
                backgroundColor: const Color.fromARGB(255, 76, 52, 22),
                title: const Text('detectar caidas'),
              )
            : null,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment(0, 1),
              colors: <Color>[
                ColorPalette.principal,
                ColorPalette.second,
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
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
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'En caso de detectar movimientos fuertes se le notificara para verificar su estado.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.barlow(
                                fontSize: 16.0,
                                wordSpacing: 1,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromRGBO(219, 177, 42, 1),
                              ),
                            ),
                          ),
                          // Add the image here

                          Switch(
                            value: isActive,
                            onChanged: ((value) async {
                              isActive = value;
                              fallVC.saveDetectedFall(context, value);
                              // geoVC.saveSendLocation(context, value);
                              setState(() {});
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 130,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text(Constant.nextTxt),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
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

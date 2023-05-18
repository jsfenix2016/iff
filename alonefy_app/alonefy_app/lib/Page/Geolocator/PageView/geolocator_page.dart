import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/Geolocator/Controller/configGeolocatorController.dart';

import 'package:ifeelefine/Page/TermsAndConditions/PageView/conditionGeneral_page.dart';
import 'package:ifeelefine/Utils/Widgets/ImageGradient.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

import '../../../Common/colorsPalette.dart';
import '../../../Provider/prefencesUser.dart';
import '../../Premium/PageView/premium_page.dart';

class InitGeolocator extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const InitGeolocator({Key? key}) : super(key: key);

  /// Utility method to create a page with the Baseflow templating.

  @override
  State<InitGeolocator> createState() => _InitGeolocatorState();
}

class _InitGeolocatorState extends State<InitGeolocator> {
  final ConfigGeolocatorController geoVC =
      Get.put(ConfigGeolocatorController());

  late bool isActive = false;
  final _prefs = PreferenceUser();
  PreferencePermission preferencePermission = PreferencePermission.init;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    if (isActive) {
      Geolocator.openAppSettings();
    }
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      isActive = false;
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
        isActive = false;
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      isActive = false;
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return await Geolocator.getCurrentPosition();
  }

  Future<Position> getCurrentPosition() async {
    if (_prefs.getAcceptedSendLocation == PreferencePermission.allow) {
      return await Geolocator.getCurrentPosition();
    } else {
      return Future.error(
          'Location permissions are denied or you are not a premium user');
    }
  }

  Future _checkPermission() async {
    LocationPermission permission;
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      setState(() {
        isActive = false;
      });
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever &&
        preferencePermission == PreferencePermission.init) {
      setState(() {
        isActive = false;
      });
    } else {
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          isActive = false;
        });

        switch (preferencePermission) {
          case PreferencePermission.init:
            _prefs.setAcceptedSendLocation = PreferencePermission.denied;
            break;
          case PreferencePermission.denied:
            _prefs.setAcceptedSendLocation = PreferencePermission.deniedForever;
            break;
          case PreferencePermission.deniedForever:
            _prefs.setAcceptedSendLocation = PreferencePermission.deniedForever;
            if (permission == LocationPermission.deniedForever) {
              showPermissionDialog(context, Constant.enablePermission);
            }
            break;
          case PreferencePermission.allow:
            _prefs.setAcceptedSendLocation = PreferencePermission.deniedForever;
            break;
          case PreferencePermission.noAccepted:
            _prefs.setAcceptedSendLocation = PreferencePermission.deniedForever;
            break;
        }
      } else {
        _prefs.setAcceptedSendLocation = PreferencePermission.allow;

        setState(() {
          isActive = true;
        });
      }

      preferencePermission = _prefs.getAcceptedSendLocation;
    }
  }

  Future _isActivePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (preferencePermission == PreferencePermission.allow &&
        (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always)) {
      setState(() {
        isActive = true;
      });
    } else {
      setState(() {
        isActive = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    preferencePermission = _prefs.getAcceptedSendLocation;
    _isActivePermission();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                    Stack(
                      children: [
                        //SizedBox(
                        //  child: Image.asset(
                        //    fit: BoxFit.fill,
                        //    scale: 0.65,
                        //    'assets/images/Map.png',
                        //    height: 400,
                        //    width: double.infinity,
                        //  ),
                        //),
                        //getPremiumImageGradient('assets/images/Map.png'),
                        getMapImageGradient(),
                        Center(
                          heightFactor: 2.2,
                          child: SizedBox(
                            child: Image.asset(
                              fit: BoxFit.fill,
                              scale: 0.65,
                              'assets/images/Shape.png',
                              height: 171.92,
                              width: 133,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 8.0),
                            child: Text(
                              Constant.casefallText,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.barlow(
                                fontSize: 24.0,
                                wordSpacing: 1,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                          // Add the image here

                          CupertinoSwitch(
                            value: isActive,
                            activeColor: ColorPalette.activeSwitch,
                            trackColor: CupertinoColors.inactiveGray,
                            onChanged: ((value) async {
                              setState(() {
                                isActive = value;
                              });
                              if (value) {
                                await _checkPermission();
                                getCurrentPosition();
                              } else {
                                _prefs.setAcceptedSendLocation =
                                    PreferencePermission.noAccepted;
                              }
                              // geoVC.saveSendLocation(context, value);
                            }),
                          ),
                        ],
                      ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ConditionGeneralPage()),
                      );
                    },
                    mensaje: Constant.continueTxt,
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

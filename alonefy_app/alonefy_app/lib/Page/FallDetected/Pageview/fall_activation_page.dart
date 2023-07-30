import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Page/Contact/PageView/addContact_page.dart';

import 'package:ifeelefine/Page/FallDetected/Controller/fall_detectedController.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';

import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';

import 'package:ifeelefine/Common/decoration_custom.dart';

class FallActivationPage extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const FallActivationPage({Key? key}) : super(key: key);

  /// Utility method to create a page with the Baseflow templating.

  @override
  State<FallActivationPage> createState() => _FallActivationPageState();
}

class _FallActivationPageState extends State<FallActivationPage> {
  final FallDetectedController fallVC = Get.put(FallDetectedController());
  final PreferenceUser _prefs = PreferenceUser();
  bool isActive = false;

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
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const WidgetLogoApp(),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
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
                      SizedBox(
                        height: 360,
                        child: Image.asset(
                          fit: BoxFit.contain,
                          'assets/images/Group 1006.png',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: ElevateButtonFilling(
                          onChanged: (value) async {
                            if (_prefs.getUserFree && !_prefs.getUserPremium) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PremiumPage(
                                        isFreeTrial: false,
                                        img: 'pantalla3.png',
                                        title: Constant.premiumFallTitle,
                                        subtitle: '')),
                              ).then((value) {
                                if (value != null && value) {
                                  _prefs.setUserFree = false;
                                  _prefs.setUserPremium = true;
                                }
                              });

                              return;
                            }

                            isActive = !isActive;
                            fallVC.setDetectedFall(isActive);
                            setState(() {});
                          },
                          mensaje: isActive ? 'Desactivar' : 'Activar',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevateButtonFilling(
                    onChanged: (value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddContactPage(),
                        ),
                      );
                    },
                    mensaje: 'Continuar',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

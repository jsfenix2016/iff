import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

import 'package:ifeelefine/Page/Geolocator/Controller/configGeolocatorController.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';

import 'package:slidable_button/slidable_button.dart';

import '../../../Common/colorsPalette.dart';
import '../../../Provider/prefencesUser.dart';
import '../../Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

class ConfigGeolocator extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const ConfigGeolocator({Key? key, required this.isMenu}) : super(key: key);
  final bool isMenu;

  /// Utility method to create a page with the Baseflow templating.

  @override
  State<ConfigGeolocator> createState() => _ConfigGeolocatorState();
}

class _ConfigGeolocatorState extends State<ConfigGeolocator> {
  late bool isActive = false;
  final _prefs = PreferenceUser();
  final _locationController = Get.put(ConfigGeolocatorController());
  PreferencePermission preferencePermission = PreferencePermission.init;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  ///
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
            _locationController.activateLocation(PreferencePermission.denied);
            //_prefs.setAcceptedSendLocation = PreferencePermission.denied;
            break;
          case PreferencePermission.denied:
            _locationController
                .activateLocation(PreferencePermission.deniedForever);
            //_prefs.setAcceptedSendLocation = PreferencePermission.deniedForever;
            break;
          case PreferencePermission.deniedForever:
            _locationController
                .activateLocation(PreferencePermission.deniedForever);
            //_prefs.setAcceptedSendLocation = PreferencePermission.deniedForever;
            if (permission == LocationPermission.deniedForever) {
              showPermissionDialog(context, Constant.enablePermission);
            }
            break;
          case PreferencePermission.allow:
            _locationController
                .activateLocation(PreferencePermission.deniedForever);
            //_prefs.setAcceptedSendLocation = PreferencePermission.deniedForever;
            break;
          case PreferencePermission.noAccepted:
            _locationController
                .activateLocation(PreferencePermission.deniedForever);
            //_prefs.setAcceptedSendLocation = PreferencePermission.deniedForever;
            break;
        }
      } else {
        //_prefs.setAcceptedSendLocation = PreferencePermission.allow;

        setState(() {
          isActive = true;
        });
      }

      preferencePermission = _prefs.getAcceptedSendLocation;
    }
  }

  void savePermission() {
    if (isActive) {
      //_prefs.setAcceptedSendLocation = PreferencePermission.allow;
      _locationController.activateLocation(PreferencePermission.allow);
    } else {
      if (_prefs.getAcceptedSendLocation == PreferencePermission.allow) {
        _locationController.activateLocation(PreferencePermission.noAccepted);
        //_prefs.setAcceptedSendLocation = PreferencePermission.noAccepted;
      }
    }

    showSaveAlert(context, "Permiso guardado",
        "El permiso del mapa se ha guardado correctamente.");
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

  bool isMenu = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    RedirectViewNotifier.setContext(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Configuración",
          style: textForTitleApp(),
        ),
      ),
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Positioned(
              top: 32,
              width: size.width,
              child: Center(
                child: Text('Enviar mi ubicación',
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
            Positioned(
              top: 126,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  child: Image.asset(
                    fit: BoxFit.fill,
                    'assets/images/Shape.png',
                    height: 171.92,
                    width: 133,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 360,
              left: 32,
              right: 32,
              //padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: HorizontalSlidableButton(
                isRestart: true,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                height: 55,
                width: 296,
                buttonWidth: 60.0,
                color: ColorPalette.principal,
                buttonColor: const Color.fromRGBO(157, 123, 13, 1),
                dismissible: false,
                label: Image.asset(
                  scale: 1,
                  fit: BoxFit.fill,
                  'assets/images/Group 969.png',
                  height: 13,
                  width: 21,
                ),
                onChanged: (SlidableButtonPosition value) {
                  if (value == SlidableButtonPosition.end) {
                    if (_prefs.getUserPremium) {
                      if (!isActive)
                        _checkPermission();
                      else {
                        setState(() {
                          isActive = false;
                          //_prefs.setAcceptedSendLocation = PreferencePermission.noAccepted;
                        });
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PremiumPage(
                                isFreeTrial: false,
                                img: 'Pantalla4.jpg',
                                title:
                                    'Protege tu Seguridad Personal las 24h:\n\n',
                                subtitle:
                                    'Activa para enviar tu última ubicación')),
                      ).then(
                        (value) {
                          if (value != null && value) {
                            _prefs.setUserPremium = true;
                            _prefs.setUserFree = false;
                            var premiumController =
                                Get.put(PremiumController());
                            premiumController.updatePremiumAPI(true);
                          }
                        },
                      );
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Center(
                          child: Text(
                            isActive ? 'Desactivar' : "Activar",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(
                              fontSize: 16.0,
                              wordSpacing: 1,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 32,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(219, 177, 42, 1),
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
                      saveGeo();
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
                  border: Border.all(color: Color.fromRGBO(219, 177, 42, 1)),
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
            ),
          ],
        ),
      ),
    );
  }

  void saveGeo() async {
    if (_prefs.getUserFree && !_prefs.getUserPremium) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PremiumPage(
              isFreeTrial: false,
              img: 'pantalla3.png',
              title: Constant.premiumMapTitle,
              subtitle: ''),
        ),
      ).then((value) {
        if (value != null && value) {
          _prefs.setUserFree = false;
          _prefs.setUserPremium = true;
          var premiumController = Get.put(PremiumController());
          premiumController.updatePremiumAPI(true);

          savePermission();
        }
      });
    } else {
      savePermission();
    }
  }
}

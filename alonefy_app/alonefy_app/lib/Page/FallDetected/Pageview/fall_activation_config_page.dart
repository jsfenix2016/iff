import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Page/FallDetected/Controller/fall_detectedController.dart';

import 'package:ifeelefine/Provider/prefencesUser.dart';

import 'package:slidable_button/slidable_button.dart';

import '../../Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class FallActivationConfigPage extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const FallActivationConfigPage({Key? key}) : super(key: key);

  /// Utility method to create a page with the Baseflow templating.

  @override
  State<FallActivationConfigPage> createState() =>
      _FallActivationConfigPageState();
}

class _FallActivationConfigPageState extends State<FallActivationConfigPage> {
  final _prefs = PreferenceUser();
  final _fallController = Get.put(FallDetectedController());

  late bool isActive = false;

  int fallPosition = 2;
  String fallTime = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      isActive = _prefs.getDetectedFall;

      Constant.timeDic.forEach((key, value) {
        if (value == _prefs.getFallTime) {
          fallPosition = int.parse(key);
          fallTime = value;
        }
      });
    });
  }

  bool isMenu = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.backgroundAppBar,
        title: const Text("Configuración"),
      ),
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Positioned(
              top: 32,
              left: 0,
              right: 0,
              child: Center(
                child: Text('Activar caídas',
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
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 94.0),
                    child: Text(
                      'Tiempo sin reacción',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.barlow(
                        fontSize: 20.0,
                        wordSpacing: 1,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: getPicker(fallPosition)),
                  Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: getSlideableActivate()),
                ],
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
                      saveFall();
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
                  border:
                      Border.all(color: const Color.fromRGBO(219, 177, 42, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
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

  Widget getPicker(int initialPosition) {
    return SizedBox(
      height: 120,
      child: CupertinoPicker(
        diameterRatio: 1.4,
        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
            background: Colors.transparent),
        backgroundColor: Colors.transparent,
        onSelectedItemChanged: (int value) {
          fallTime = Constant.timeDic[value.toString()]!;
        },
        scrollController:
            FixedExtentScrollController(initialItem: initialPosition),
        itemExtent: 60.0,
        children: [
          for (var i = 0; i < Constant.timeDic.length; i++)
            Container(
              height: 24,
              width: 120,
              color: Colors.transparent,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    Constant.timeDic[i.toString()]!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 24.0,
                      wordSpacing: 1,
                      letterSpacing: 0.001,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: 2,
                    width: 120,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget getSlideableActivate() {
    return HorizontalSlidableButton(
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
        if (value == SlidableButtonPosition.end && _prefs.getUserPremium) {
          setState(() {
            isActive = !isActive;
          });
        } else if (value == SlidableButtonPosition.end) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PremiumPage(
                    isFreeTrial: false,
                    img: 'pantalla2.png',
                    title: Constant.premiumFallTitle,
                    subtitle: '')),
          );
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
    );
  }

  void saveFall() async {
    if (_prefs.getUserFree) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PremiumPage(
              isFreeTrial: false,
              img: 'pantalla3.png',
              title: Constant.premiumFallTitle,
              subtitle: ''),
        ),
      ).then((value) {
        if (value != null && value) {
          _prefs.setUserFree = false;
          saveChange();
        }
      });
    } else {
      saveChange();
    }
  }

  Future<void> saveChange() async {
    _fallController.setDetectedFall(isActive);
    //_prefs.setDetectedFall = isActive;
    _fallController.setFallTime(fallTime);
    //_prefs.setFallTime = fallTime;

    showSaveAlert(context, "Tiempo de caída",
        "El tiempo de caída se ha guardado correctamente");
  }
}

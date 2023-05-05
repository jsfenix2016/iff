
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:slidable_button/slidable_button.dart';

import '../../../Common/Constant.dart';
import '../../../Common/colorsPalette.dart';
import '../../../Common/utils.dart';
import '../../Onboarding/Widget/widgetColumnOnboarding.dart';

class PremiumPage extends StatefulWidget {

  const PremiumPage({super.key,
    required this.img,
    required this.title,
    required this.subtitle});

  final String img;
  final String title;
  final String subtitle;

  @override
  State<StatefulWidget> createState() => _PremiumPageState();

}

class _PremiumPageState extends State<PremiumPage> {

  var premiumController = Get.put(PremiumController());
  final _prefs = PreferenceUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: decorationCustom(),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                child: Image.asset(
                  fit: BoxFit.fitHeight,
                  widget.img,
                  height: 400,
                ),
              ),
            ),
            Positioned(
              top: 24,
              left: 32,
              right: 32,
              child: Center(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.barlow(
                    fontSize: 22.0,
                    wordSpacing: 1,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.principal,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 370,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      width: 180,
                      height: 127,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: ColorPalette.backgroundDarkGrey
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                            child: Text(
                              'Seguridad ilimitada',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.barlow(
                                fontSize: 22.0,
                                wordSpacing: 1,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                            child: Text(
                              _prefs.getPremiumPrice,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.barlow(
                                fontSize: 24.0,
                                wordSpacing: 1,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              )
            ),
            Positioned(
                bottom: 32,
                left: 32,
                right: 32,
                child: getHorizontalSlide()
            )
          ],
        ),
      ),
    );
  }

  Widget getHorizontalSlide() {
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
      onChanged: (SlidableButtonPosition value) async {
        if (value == SlidableButtonPosition.end) {
          premiumController.requestPurchaseByProductId(PremiumController.subscriptionId, responseSubscription());
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 48.0),
              child: Center(
                child: Text(
                  "Pasar a Premium",
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

  Function responseSubscription() {
    return (bool response) => {
      if (response) {
        Navigator.pop(context)
      }
    };
  }

}
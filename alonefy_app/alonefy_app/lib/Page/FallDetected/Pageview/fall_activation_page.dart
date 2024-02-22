import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/Contact/PageView/addContact_page.dart';
import 'package:ifeelefine/Page/Disamble/Controller/disambleController.dart';

import 'package:ifeelefine/Page/FallDetected/Controller/fall_detectedController.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Page/PreviewActivitiesFilteredByDate/PageView/previewActivitiesByDate_page.dart';
import 'package:ifeelefine/Page/UseMobil/Controller/useMobileController.dart';

import 'package:ifeelefine/Provider/prefencesUser.dart';

import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';

import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';

import 'package:slidable_button/slidable_button.dart';

class FallActivationPage extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const FallActivationPage({Key? key}) : super(key: key);

  /// Utility method to create a page with the Baseflow templating.

  @override
  State<FallActivationPage> createState() => _FallActivationPageState();
}

class _FallActivationPageState extends State<FallActivationPage> {
  final FallDetectedController fallVC = Get.put(FallDetectedController());
  final UseMobilController useMobilVC = Get.put(UseMobilController());
  final PreferenceUser _prefs = PreferenceUser();
  bool isActive = false;
  bool isMenu = false;

  @override
  void initState() {
    super.initState();
    // _prefs.saveLastScreenRoute("fallActivation");
    starTap();
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
          if (_prefs.getUserFree && !_prefs.getUserPremium) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PremiumPage(
                      isFreeTrial: false,
                      img: 'pantalla2.png',
                      title: Constant.premiumFallTitle,
                      subtitle: '')),
            ).then((value) {
              if (value != null && value) {
                _prefs.setUserFree = false;
                _prefs.setUserPremium = true;
                var premiumController = Get.put(PremiumController());
                premiumController.updatePremiumAPI(true);
                refreshMenu("fallActivation");

                setState(() {});
              }
            });

            return;
          }

          isActive = !isActive;
          fallVC.setDetectedFall(isActive);
          setState(() {});
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Center(
                child: Text(
                  !_prefs.getUserPremium
                      ? "Obtener Premium"
                      : isActive
                          ? 'Desactivar'
                          : 'Activar',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.barlow(
                    fontSize: 16.0,
                    wordSpacing: 1,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateHeight(double desiredHeight) {
    double screenHeight = MediaQuery.of(context).size.height;
    return (desiredHeight * 100) / screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        // Aquí puedes ejecutar acciones personalizadas antes de volver atrás
        // Por ejemplo, mostrar un diálogo de confirmación
        if (isMenu) {
          Get.off(PreviewActivitiesByDate(
            isMenu: false,
          ));
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: isMenu
            ? AppBar(
                backgroundColor: Colors.brown,
                title: Text(
                  "Detectar caídas",
                  style: textForTitleApp(),
                ),
              )
            : null,
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
            decoration: decorationCustom(),
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 36,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const WidgetLogoApp(),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Detectar caídas',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(
                              fontSize: 24.0,
                              wordSpacing: 1,
                              letterSpacing: 0.001,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          height: 301,
                          width: 315,
                          child: Image.asset(
                            fit: BoxFit.cover,
                            'assets/images/Group 1006.png',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: getHorizontalSlide(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevateButtonFilling(
                      showIcon: false,
                      onChanged: (value) {
                        // Get.off(const AddContactPage());
                        if (prefs.getUserPremium) {
                          refreshMenu("fallActivation");
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddContactPage(),
                          ),
                        );
                      },
                      mensaje: 'Continuar',
                      img: '',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

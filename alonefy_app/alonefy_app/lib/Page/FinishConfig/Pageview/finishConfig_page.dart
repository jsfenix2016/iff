import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';
import 'package:ifeelefine/main.dart';

class FinishConfigPage extends StatefulWidget {
  const FinishConfigPage({super.key});

  @override
  State<FinishConfigPage> createState() => _FinishConfigPageState();
}

class _FinishConfigPageState extends State<FinishConfigPage> {
  final _prefs = PreferenceUser();

  @override
  void initState() {
    _prefs.saveLastScreenRoute("finishConfig");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: decorationCustom(),
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 36,
                      ),
                      const WidgetLogoApp(),
                      const SizedBox(
                        height: 80,
                      ),
                      SizedBox(
                        child: Column(
                          children: <Widget>[
                            Text(
                              '¡¡ Enhorabuena !!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.barlow(
                                fontSize: 22.0,
                                wordSpacing: 1,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: ColorPalette.principal,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            Container(
                              color: Colors.transparent,
                              height: 142,
                              width: 300,
                              child: Stack(
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: "AlertFriends ",
                                      style: GoogleFonts.barlow(
                                        fontSize: 22.0,
                                        wordSpacing: 1,
                                        letterSpacing: 0.001,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'se ha configurado ',
                                          style: GoogleFonts.barlow(
                                            fontSize: 22.0,
                                            wordSpacing: 1,
                                            letterSpacing: 0.001,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'correctamente',
                                          style: GoogleFonts.barlow(
                                            fontSize: 22.0,
                                            wordSpacing: 1,
                                            letterSpacing: 0.001,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Center(
                              child: ElevateButtonFilling(
                                showIcon: false,
                                onChanged: ((value) async {
                                  final service = FlutterBackgroundService();
                                  var isRunning = await service.isRunning();
                                  if (isRunning) {
                                    service.invoke("stopService");
                                  }

                                  Future.sync(() => activateService());

                                  if (_prefs.getUserFree) {
                                    _prefs.config = false;
                                  } else {
                                    _prefs.config = true;
                                  }
                                  Get.off(() => const HomePage());
                                }),
                                mensaje: 'Acceder',
                                img: '',
                              ),
                            ),
                            // Add the image here
                          ],
                        ),
                      ),
                    ],
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

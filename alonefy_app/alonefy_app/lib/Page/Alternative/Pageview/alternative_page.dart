import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/button_style_custom.dart';

import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';
import 'package:ifeelefine/main.dart';

class AlternativePage extends StatefulWidget {
  const AlternativePage({super.key});
  @override
  State<AlternativePage> createState() => _AlternativePagePageState();
}

class _AlternativePagePageState extends State<AlternativePage> {
  final _prefs = PreferenceUser();

  @override
  void initState() {
    initPref();
    starTap();

    super.initState();
  }

  Future<void> initPref() async {
    await _prefs.initPrefs();
    _prefs.saveLastScreenRoute("alternative");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        // Configura el factor de escala de texto a 1.0 para evitar el escalado de texto
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: decorationCustom(),
          child: Center(
            child: Center(
              child: Column(
                children: [
                  SafeArea(
                    child: Container(
                      height: 150.0,
                    ),
                  ),
                  const WidgetLogoApp(),
                  const SizedBox(
                    height: 100,
                  ),
                  ElevatedButton(
                    style: styleColorClear(),
                    onPressed: () async {
                      _prefs.firstConfig = true;
                      _prefs.config = false;

                      Get.off(() => const HomePage());
                    },
                    child: FractionallySizedBox(
                      widthFactor: 0.66,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: linerGradientButtonFilling(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                        ),
                        height: 42,
                        width: 205,
                        child: Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: Constant.alternativePageButtonInit,
                              style: textNormal16Black(),
                              children: <TextSpan>[
                                TextSpan(
                                  text: " AlertFriends",
                                  style: GoogleFonts.barlow(
                                    fontSize: 16.0,
                                    wordSpacing: 1,
                                    letterSpacing: 0.001,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevateButtonCustomBorder(
                    onChanged: (value) {
                      _prefs.firstConfig = true;

                      Get.off(() => const UserConfigPage(isMenu: false));
                    },
                    mensaje: Constant.alternativePageButtonPersonalizar,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

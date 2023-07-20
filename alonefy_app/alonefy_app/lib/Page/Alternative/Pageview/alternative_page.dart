import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/button_style_custom.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

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
    super.initState();
  }

  Future<void> initPref() async {
    await _prefs.initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  Text(
                    "AlertFriend",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 44.5,
                      wordSpacing: 1,
                      letterSpacing: 0.001,
                      fontWeight: FontWeight.w100,
                      color: ColorPalette.principal,
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  ElevatedButton(
                    style: styleColorClear(),
                    onPressed: () {
                      _prefs.firstConfig = true;
                      _prefs.config = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: linerGradientButtonFilling(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                        ),
                        height: 42,
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: Constant.alternativePageButtonInit,
                                style: GoogleFonts.barlow(
                                  fontSize: 16.0,
                                  wordSpacing: 1,
                                  letterSpacing: 0.001,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: " AlertFriend",
                                    style: textNormal16Black(),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserConfigPage(),
                        ),
                      );
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

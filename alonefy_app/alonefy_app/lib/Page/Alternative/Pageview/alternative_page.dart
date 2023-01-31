import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

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
                    "I'm fine!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 44.0,
                      wordSpacing: 1,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal,
                      color: ColorPalette.principal,
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  ElevateButtonFilling(
                    onChanged: (value) {
                      _prefs.firstConfig = true;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    mensaje: Constant.alternativePageButtonPersonalizar,
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

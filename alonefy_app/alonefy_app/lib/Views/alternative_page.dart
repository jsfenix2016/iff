import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';
import 'package:google_fonts/google_fonts.dart';

final _prefs = PreferenceUser();

class AlternativePage extends StatefulWidget {
  const AlternativePage({super.key});
  @override
  State<AlternativePage> createState() => _AlternativePagePageState();
}

class _AlternativePagePageState extends State<AlternativePage> {
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment(0, 1),
              colors: <Color>[
                Color.fromRGBO(21, 14, 3, 1),
                Color.fromRGBO(115, 75, 24, 1),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
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
                      color: const Color.fromRGBO(219, 177, 42, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                    ),
                    child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(219, 177, 42, 1),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        height: 42,
                        width: 200,
                        child: const Center(
                            child: Text(Constant.alternativePageButtonInit))),
                    onPressed: () {
                      _prefs.notConfigUser = true;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          border: Border.all(
                              color: const Color.fromRGBO(219, 177, 42, 1)),
                        ),
                        height: 42,
                        width: 200,
                        child: const Center(
                            child: Text(
                                Constant.alternativePageButtonPersonalizar))),
                    onPressed: () {
                      _prefs.notConfigUser = true;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserConfigPage(),
                        ),
                      );
                    },
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

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';

class FinishConfigPage extends StatefulWidget {
  const FinishConfigPage({super.key});

  @override
  State<FinishConfigPage> createState() => _FinishConfigPageState();
}

class _FinishConfigPageState extends State<FinishConfigPage> {
  final _prefs = PreferenceUser();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              radius: 1,
              colors: [
                ColorPalette.secondView,
                ColorPalette.principalView,
              ],
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          WidgetLogoApp(),
                        ],
                      ),
                    ),
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
                                    text: "I'm fine ",
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
                                onChanged: ((value) async {
                                  final service = FlutterBackgroundService();
                                  var isRunning = await service.isRunning();
                                  if (isRunning) {
                                    service.invoke("stopService");
                                  } else {
                                    service.startService();
                                  }
                                  _prefs.config = true;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const HomePage()),
                                  );
                                }),
                                mensaje: 'Acceder'),
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
    );
  }
}

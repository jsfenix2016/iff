import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

class FinishConfigPage extends StatefulWidget {
  const FinishConfigPage({super.key});

  @override
  State<FinishConfigPage> createState() => _FinishConfigPageState();
}

class _FinishConfigPageState extends State<FinishConfigPage> {
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
                      child: Container(
                        height: 170.0,
                      ),
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
                                Positioned(
                                  left: 20,
                                  child: Row(
                                    children: [
                                      Text(
                                        "I'm fine ",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.barlow(
                                          fontSize: 22.0,
                                          wordSpacing: 1,
                                          letterSpacing: 0.001,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "se ha configurado ",
                                        textAlign: TextAlign.center,
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
                                Positioned(
                                  top: 30,
                                  left: 80,
                                  child: Text(
                                    "correctamente",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.barlow(
                                      fontSize: 22.0,
                                      wordSpacing: 1,
                                      letterSpacing: 0.001,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 58,
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

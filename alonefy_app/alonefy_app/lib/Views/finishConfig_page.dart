import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:flutter/material.dart';

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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Enhorabuena, IFeelFine se ha configurado correctamente.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.barlow(
                                fontSize: 22.0,
                                wordSpacing: 1,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 58,
                          ),
                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent,
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.transparent,
                                ),
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(219, 177, 42, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                                height: 42,
                                width: 200,
                                child: Center(
                                  child: Text('Acceder',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.barlow(
                                        fontSize: 16.0,
                                        wordSpacing: 1,
                                        letterSpacing: 1.2,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                );
                              },
                            ),
                          ),
                          // Add the image here
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Positioned(
              //   bottom: 0,
              //   right: 30,
              //   child: Padding(
              //     padding: const EdgeInsets.all(0.0),
              //     child: ElevatedButton(
              //       child: const Text(Constant.continueTxt),
              //       onPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(builder: (context) => HomePage()),
              //         );
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

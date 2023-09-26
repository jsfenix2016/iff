import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/initialize_models_bd.dart';
import 'package:ifeelefine/Model/userbd.dart';
import 'package:ifeelefine/Services/mainService.dart';
import 'package:ifeelefine/main.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({
    super.key,
  });

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  void initState() {
    super.initState();
    starTap();
    print(rxIdTask.value);
    print(rxlistTask);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 80,
                  width: size.width,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      'Hola ${user == null ? "NULL" : name.obs}\n¿Estas bien?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.barlow(
                        fontSize: 24.0,
                        wordSpacing: 1,
                        letterSpacing: 0.001,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      MainService().cancelAllNotifications(rxlistTask);

                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(219, 177, 42, 1),
                        border: Border.all(
                          color: const Color.fromRGBO(219, 177, 42, 1),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                      ),
                      height: 104,
                      width: 104,
                      child: Center(
                        child: Text(
                          "SÍ",
                          style: GoogleFonts.barlow(
                            fontSize: 48.0,
                            wordSpacing: 1,
                            letterSpacing: 0.001,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 100,
                  width: size.width,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'El proceso de notificar a tus contactos está inicializado.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.barlow(
                        fontSize: 24.0,
                        wordSpacing: 1,
                        letterSpacing: 0.001,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    MainService().sendAlertToContactImmediately(rxlistTask);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(200)),
                    ),
                    height: 142.89,
                    width: 146,
                    child: Center(
                      child: SizedBox(
                        width: 118,
                        height: 80,
                        child: Center(
                          child: Text(
                            "Necesito ayuda",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(
                              fontSize: 26.0,
                              wordSpacing: 1,
                              letterSpacing: 0.001,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
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

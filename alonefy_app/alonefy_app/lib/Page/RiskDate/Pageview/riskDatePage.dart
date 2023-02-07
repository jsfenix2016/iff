import 'dart:ffi';

import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/RiskDate/Pageview/editRiskDatePage.dart';
import 'package:ifeelefine/Page/RiskDate/Widgets/rowContact.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

class RiskPage extends StatefulWidget {
  const RiskPage({super.key});
  @override
  State<RiskPage> createState() => _RiskPageState();
}

class _RiskPageState extends State<RiskPage> {
  final _prefs = PreferenceUser();
  final List<String> listDisamble = <String>[
    "1 hora",
    "2 horas",
    "3 horas",
    "8 horas",
    "24 horas",
    "1 semana",
    "1 mes",
    "1 año",
    "Siempre",
  ];
  String desactiveIFeelFine = "1 hora";
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
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: const Center(child: Text("Cita de riesgo")),
        ),
        body: Container(
          decoration: decorationCustom(),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SafeArea(
                    child: Container(
                      height: 10.0,
                    ),
                  ),
                  Text(
                    "Cuando acabes tu cita, avisaremos a tu contacto sino desactivas esta alarma ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 24.0,
                      wordSpacing: 1,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Utilizar una configuración guardada o crear una nueva.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 20.0,
                      wordSpacing: 1,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listDisamble.length,
                    itemBuilder: (context, index) {
                      return RowContact(
                          onChanged: ((value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditRiskPage()),
                            );
                          }),
                          hoursIni: "hoursIni",
                          hoursFinish: "hoursFinish",
                          name: "name",
                          message: "message");
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ElevateButtonFilling(
                      onChanged: (value) {
                        _prefs.firstConfig = true;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      mensaje: "Crear nuevo",
                    ),
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

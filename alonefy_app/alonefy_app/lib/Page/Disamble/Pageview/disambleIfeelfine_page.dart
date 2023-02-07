import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/restday.dart';
import 'package:ifeelefine/Page/Disamble/Controller/disambleController.dart';
import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:flutter/material.dart';

class DesactivePage extends StatefulWidget {
  const DesactivePage({super.key, required this.isMenu});
  final bool isMenu;
  @override
  State<DesactivePage> createState() => _DesactivePageState();
}

class _DesactivePageState extends State<DesactivePage> {
  final DisambleController disambleVC = Get.put(DisambleController());

  final List<RestDay> tempDicRest = [];
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.brown,
        title: const Text('Desactivar IFeelFine'),
      ),
      // floatingActionButton:
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  color: Colors.transparent,
                  height: 105,
                  width: size.width,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Permite desactivar la aplicación por un tiempo determinado.",
                        style: GoogleFonts.barlow(
                          fontSize: 24.0,
                          wordSpacing: 1,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListView(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 20),
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listDisamble.length,
                      itemBuilder: (context, index) {
                        return RadioListTile(
                          activeColor: Colors.white,
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Text(
                            listDisamble[index],
                            style: GoogleFonts.barlow(
                              fontSize: 16.0,
                              wordSpacing: 1,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          value: listDisamble[index],
                          groupValue: desactiveIFeelFine,
                          onChanged: (value) {
                            setState(
                              () {
                                desactiveIFeelFine = value.toString();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevateButtonFilling(
                  onChanged: (bool value) {
                    disambleVC.saveDisamble(context, desactiveIFeelFine);
                  },
                  mensaje: "Guardar",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _createButtonNext() {
  //   return ElevatedButton.icon(
  //     style: ButtonStyle(
  //         backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
  //     label: const Text("Guardar"),
  //     icon: const Icon(
  //       Icons.save,
  //     ),
  //     onPressed: (() {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const UserInactivityPage()),
  //       );
  //     }),
  //   );
  // }
}

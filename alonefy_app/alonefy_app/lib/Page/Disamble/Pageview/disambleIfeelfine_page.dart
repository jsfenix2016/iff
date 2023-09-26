import 'package:flutter/cupertino.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

import 'package:ifeelefine/Model/restday.dart';
import 'package:ifeelefine/Page/Disamble/Controller/disambleController.dart';

import 'package:flutter/material.dart';
import 'package:ifeelefine/main.dart';

import '../../../Common/colorsPalette.dart';
import '../../../Provider/prefencesUser.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

final _prefs = PreferenceUser();

class DesactivePage extends StatefulWidget {
  const DesactivePage({super.key, required this.isMenu});
  final bool isMenu;
  @override
  State<DesactivePage> createState() => _DesactivePageState();
}

class _DesactivePageState extends State<DesactivePage> {
  //final DisambleController disambleVC = Get.put(DisambleController());

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
  List<bool> listDisambleEnabled = <bool>[
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  var indexDisamble = -1;

  String desactiveIFeelFine = "1 hora";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    starTap();
    getDisamble();
  }

  void getDisamble() {
    var count = 0;
    for (var disamble in listDisamble) {
      if (disamble == _prefs.getDisambleIFF) {
        setState(() {
          listDisambleEnabled[count] = true;
        });
        break;
      }
      count++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    RedirectViewNotifier.setStoredContext(context);
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Configuración",
          style: textForTitleApp(),
        ),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
            decoration: decorationCustom(),
            width: size.width,
            height: size.height,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 32,
                  width: size.width,
                  child: Center(
                    child: Text('Desactivar AlertFriends',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 22.0,
                          wordSpacing: 1,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 100, 0, 100),
                  child: ListView.builder(
                    itemCount: listDisamble.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          Expanded(
                              child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {
                                  desactiveIFeelFine = listDisamble[index];
                                  if (indexDisamble == index) {
                                    indexDisamble = -1;
                                  } else {
                                    indexDisamble = index;
                                  }
                                },
                                child: Text(listDisamble[index],
                                    style: GoogleFonts.barlow(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                      color: CupertinoColors.white,
                                    ))),
                          )),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: CupertinoSwitch(
                                  value: listDisambleEnabled[index],
                                  activeColor: ColorPalette.activeSwitch,
                                  trackColor: CupertinoColors.inactiveGray,
                                  onChanged: (bool? value) {
                                    desactiveIFeelFine = listDisamble[index];
                                    if (value!) {
                                      // _prefs.setEnableIFF = false;

                                      // enableApp.value = false;
                                    } else {
                                      // _prefs.setEnableIFF = true;
                                      // enableApp.value = true;
                                      _prefs.setDisambleIFF = "0 hora";
                                      desactiveIFeelFine = "0 hora";
                                    }
                                    var count = 0;
                                    for (var disambleEnabled
                                        in listDisambleEnabled) {
                                      listDisambleEnabled[count] = false;

                                      count++;
                                    }
                                    listDisambleEnabled[index] = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 32,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(219, 177, 42, 1),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    width: 138,
                    height: 42,
                    child: Center(
                      child: TextButton(
                        child: Text('Guardar',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(
                              fontSize: 16.0,
                              wordSpacing: 1,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            )),
                        onPressed: () async {
                          saveDisamble();
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 32,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: const Color.fromRGBO(219, 177, 42, 1)),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    width: 138,
                    height: 42,
                    child: Center(
                      child: TextButton(
                        child: Text('Cancelar',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(
                              fontSize: 16.0,
                              wordSpacing: 1,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  void saveDisamble() {
    DisambleController().saveDisamble(context, desactiveIFeelFine);
    setState(() {});
  }
}

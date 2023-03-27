import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/Calendar/calendarPopup.dart';
import 'package:ifeelefine/Page/Geolocator/Controller/configGeolocatorController.dart';

import 'package:ifeelefine/Page/TermsAndConditions/PageView/conditionGeneral_page.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

import '../../../Common/colorsPalette.dart';
import '../../../Provider/prefencesUser.dart';
import '../../../Utils/Widgets/textFieldFormCustomBorder.dart';

class RestoreMyConfigPage extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const RestoreMyConfigPage({Key? key}) : super(key: key);

  /// Utility method to create a page with the Baseflow templating.

  @override
  State<RestoreMyConfigPage> createState() => _RestoreMyConfigPageState();
}

class _RestoreMyConfigPageState extends State<RestoreMyConfigPage> {

  final _prefs = PreferenceUser();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.backgroundAppBar,
        title: const Text("Configuración"),
      ),
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: Stack(
            children: [
              Column(
                  children: [
                    SizedBox(height: 32),
                    Center(
                      child: Text('Restaurar mi configuración',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.barlow(
                            fontSize: 22.0,
                            wordSpacing: 1,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
                        child: Text('Teléfono',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.barlow(
                              fontSize: 20.0,
                              wordSpacing: 1,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
                      child: TextField(
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorPalette.principal),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: ColorPalette.principal),
                          ),
                        ),
                        style: GoogleFonts.barlow(
                          fontSize: 16.0,
                          wordSpacing: 1,
                          letterSpacing: 0.001,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 56),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
                        child: Text('Email',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.barlow(
                              fontSize: 20.0,
                              wordSpacing: 1,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
                      child: TextField(
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorPalette.principal),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: ColorPalette.principal),
                          ),
                        ),
                        style: GoogleFonts.barlow(
                          fontSize: 16.0,
                          wordSpacing: 1,
                          letterSpacing: 0.001,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
                            child: Text(
                              textAlign: TextAlign.center,
                              style: GoogleFonts.barlow(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: CupertinoColors.white,
                              ),
                              "Desactivar mi instalación en anterior Smartphone"
                            ),

                          )
                        ),
                        Positioned(
                          right: 32,
                          child: Container(
                            width: 120,
                            child: CupertinoSwitch(
                              value: false,
                              activeColor: ColorPalette.activeSwitch,
                              trackColor: CupertinoColors.inactiveGray,
                              onChanged: (bool? value) {

                              },
                            ),
                          )
                        ),
                      ],
                    )
                  ]
              ),
              Positioned(
                bottom: 20,
                right: 32,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(219, 177, 42, 1),
                    borderRadius:
                    BorderRadius.all(Radius.circular(8)),
                  ),
                  width: 138,
                  height: 42,
                  child: Center(
                    child: TextButton(
                      child: Text('Restaurar',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.barlow(
                            fontSize: 16.0,
                            wordSpacing: 1,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                      onPressed: () async {

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
                        color: Color.fromRGBO(219, 177, 42, 1)
                    ),
                    borderRadius:
                    BorderRadius.all(Radius.circular(8)),
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
              ),
          ],
        ),
      ),
    );
  }
}

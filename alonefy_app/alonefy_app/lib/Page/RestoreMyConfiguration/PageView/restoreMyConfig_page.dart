import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';

import 'package:ifeelefine/Page/RestoreMyConfiguration/Controller/restoreController.dart';

import '../../../Common/colorsPalette.dart';

import 'package:ifeelefine/Common/decoration_custom.dart';

class RestoreMyConfigPage extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const RestoreMyConfigPage({Key? key}) : super(key: key);

  /// Utility method to create a page with the Baseflow templating.

  @override
  State<RestoreMyConfigPage> createState() => _RestoreMyConfigPageState();
}

class _RestoreMyConfigPageState extends State<RestoreMyConfigPage> {
  final RestoreController restVC = Get.put(RestoreController());

  String phone = '';
  String email = '';

  bool _isRestoreInProgress = false;

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
      body: SingleChildScrollView(
        child: Container(
          decoration: decorationCustom(),
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              if (_isRestoreInProgress) ...[
                const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: ColorPalette.calendarNumber,
                  ),
                )
              ] else ...[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(height: 32),
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
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                        child: Text('Teléfono',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.barlow(
                              fontSize: 20.0,
                              wordSpacing: 1,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
                      child: TextField(
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          prefix: Text(
                            '+34',
                            style: textNormal16White(),
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorPalette.principal),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: ColorPalette.principal),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: textNormal16White(),
                        onChanged: (valor) {
                          if (valor.length == 9) {
                            // Solicita el siguiente enfoque solo si la longitud del valor es 1
                            // y el cuadro de texto actual no es el último en la lista
                            phone = valor;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 56),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                        child: Text('Email',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.barlow(
                              fontSize: 20.0,
                              wordSpacing: 1,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
                      child: TextField(
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorPalette.principal),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: ColorPalette.principal),
                          ),
                        ),
                        onChanged: (valor) {
                          email = valor;
                        },
                        style: textNormal16White(),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 50,
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
                        child: Text('Restaurar',
                            textAlign: TextAlign.center,
                            style: textNormal16White()),
                        onPressed: () async {
                          if (phone.length < 8 || phone.isEmpty) {
                            showSaveAlert(context, Constant.info,
                                Constant.validatePhoneNumber);

                            return;
                          }
                          if (email.isEmpty) {
                            return;
                          }
                          if (!validateEmail(email)) {
                            // El correo electrónico no es válido
                            showSaveAlert(
                                context, Constant.info, Constant.validateEmail);
                            return;
                          }

                          setState(() {
                            _isRestoreInProgress = true;
                          });
                          var result =
                              await restVC.sendData(context, phone, email);

                          if (result) {
                            setState(() {
                              Get.off(() => const HomePage());
                            });
                          }
                          setState(() {
                            _isRestoreInProgress = false;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
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
                            style: textNormal16White()),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

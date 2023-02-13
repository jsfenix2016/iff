import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/RiskDate/Widgets/contentCode.dart';
import 'package:ifeelefine/Page/RiskDate/Widgets/rowContact.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Page/HomePage/Pageview/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Page/UserConfig/PageView/userconfig_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

class EditRiskPage extends StatefulWidget {
  const EditRiskPage({super.key});
  @override
  State<EditRiskPage> createState() => _EditRiskPageState();
}

class _EditRiskPageState extends State<EditRiskPage> {
  @override
  void initState() {
    initPref();
    super.initState();
  }

  Future<void> initPref() async {}

  Widget _mostrarFoto() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 79,
        height: 79,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
              Radius.circular(79.0) //                 <--- border radius here
              ),
          border: Border.all(color: Colors.blueAccent),
          image: const DecorationImage(
            image: AssetImage("assets/images/icons8.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: const Center(child: Text("Edición de mensaje de cita")),
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
                  Card(
                    color: const Color.fromRGBO(169, 146, 125, 0.2),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Container(
                            height: 50.0,
                            color: Colors.transparent,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: size.width / 2.8,
                                  color: Colors.transparent,
                                  child: Text(
                                    "Hora inicio:",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.barlow(
                                      fontSize: 24.0,
                                      wordSpacing: 1,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                    width: size.width / 3,
                                    color: Colors.transparent,
                                    child: Text(
                                      "00:00",
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.barlow(
                                        fontSize: 24.0,
                                        wordSpacing: 1,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    )),
                                Container(
                                  width: size.width / 5,
                                  color: Colors.transparent,
                                  child: Switch(
                                    onChanged: (value) {},
                                    value: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Container(
                            height: 50.0,
                            color: Colors.transparent,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: size.width / 2.8,
                                  color: Colors.transparent,
                                  child: Text(
                                    "Hora fin:",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.barlow(
                                      fontSize: 24.0,
                                      wordSpacing: 1,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: size.width / 3,
                                  color: Colors.transparent,
                                  child: Text(
                                    "00:00",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.barlow(
                                      fontSize: 24.0,
                                      wordSpacing: 1,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: size.width / 5,
                                  color: Colors.transparent,
                                  child: Switch(
                                    onChanged: (value) {},
                                    value: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Establece tu clave de cancelación",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.barlow(
                        fontSize: 24.0,
                        wordSpacing: 1,
                        letterSpacing: 1,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ContentCode(
                    onChanged: (value) {},
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Text(
                        "Después de la hora de fin llamar a:",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 24.0,
                          wordSpacing: 1,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(169, 146, 125, 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(
                              100.0) //                 <--- border radius here
                          ),
                    ),
                    height: 79,
                    width: 280,
                    child: Stack(
                      children: [
                        _mostrarFoto(),
                        Positioned(
                          right: 0,
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(100),
                                  topRight: Radius.circular(100),
                                ),
                              ),
                              height: 79,
                              width: 200,
                              child: Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    height: 79,
                                    width: 150,
                                    child: Center(
                                      child: Text(
                                        "javier santana",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.barlow(
                                          fontSize: 18.0,
                                          wordSpacing: 1,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(100),
                                        topRight: Radius.circular(100),
                                      ),
                                    ),
                                    height: 79,
                                    width: 50,
                                    child: IconButton(
                                      iconSize: 40,
                                      color: ColorPalette.principal,
                                      onPressed: () {},
                                      icon: Container(
                                        height: 28,
                                        width: 28,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/plussWhite.png'),
                                            fit: BoxFit.fill,
                                          ),
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Container(
                            height: 50.0,
                            color: Colors.transparent,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 280,
                                  color: Colors.transparent,
                                  child: Text(
                                    "Enviar Whatsapp a mi mensaje predefinido:",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.barlow(
                                      fontSize: 14.0,
                                      wordSpacing: 1,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: size.width / 6,
                                  color: Colors.transparent,
                                  child: Switch(
                                    onChanged: (value) {},
                                    value: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Container(
                            height: 50.0,
                            color: Colors.transparent,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 280,
                                  color: Colors.transparent,
                                  child: Text(
                                    "Enviar mi última ubicación registrada:",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.barlow(
                                      fontSize: 14.0,
                                      wordSpacing: 1,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: size.width / 6,
                                  color: Colors.transparent,
                                  child: Switch(
                                    onChanged: (value) {},
                                    value: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  Container(
                    height: 290,
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onChanged: (valor) {},
                            autofocus: false,
                            key: const Key("lastName"),
                            initialValue: "",
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: "",
                              labelText: "Asunto",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.yellow),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.yellow), //<-- SEE HERE
                              ),
                              hintStyle: TextStyle(color: Colors.yellow),
                              filled: true,
                              labelStyle: TextStyle(color: Colors.yellow),
                            ),
                            style: const TextStyle(color: Colors.amber),
                            onSaved: (value) => {},
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "",
                              labelText: "Mensaje:",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.yellow),
                              ),
                              hintStyle: TextStyle(color: Colors.yellow),
                              filled: true,
                              labelStyle: TextStyle(color: Colors.yellow),
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 280,
                                color: Colors.transparent,
                                child: Text(
                                  "Guardar esta configuración",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.barlow(
                                    fontSize: 14.0,
                                    wordSpacing: 1,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width / 6,
                                color: Colors.transparent,
                                child: Switch(
                                  onChanged: (value) {},
                                  value: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevateButtonFilling(
                    onChanged: (value) {},
                    mensaje: Constant.alternativePageButtonInit,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevateButtonCustomBorder(
                    onChanged: (value) {},
                    mensaje: Constant.alternativePageButtonPersonalizar,
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

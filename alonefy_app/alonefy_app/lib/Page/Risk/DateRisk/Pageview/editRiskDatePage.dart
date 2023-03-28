import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/contactRiskBD.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Controller/editRiskController.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/PageView/riskDatePage.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/cardContact.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/contentCode.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/popUpContact.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notification_center/notification_center.dart';

final _prefs = PreferenceUser();

class EditRiskPage extends StatefulWidget {
  const EditRiskPage(
      {super.key, required this.contactRisk, required this.index});

  final ContactRiskBD contactRisk;
  final int index;
  // final String timefinish;
  @override
  State<EditRiskPage> createState() => _EditRiskPageState();
}

class _EditRiskPageState extends State<EditRiskPage> {
  EditRiskController editVC = EditRiskController();
  var isTimeInit = false;
  var isTimeFinish = false;
  var sendWhatsappSMS = false;
  var sendLocation = false;
  var saveConfig = true;
  var isActived = false;
  var isprogrammed = false;
  String timeinit = "00:00";
  String timefinish = "00:00";
  List<Contact> contactlist = [];
  late Contact contactSelect;
  var indexSelect = -1;
  var code = CodeModel();

  var titleMessage = "";
  var message = '';
  String name = 'Selecciona un contacto';

  late Image imgNew;
  var foto;
  final _picker = ImagePicker();

  @override
  void initState() {
    getContact();
    List<String> parts = [];
    if (widget.contactRisk.code != "") {
      parts = widget.contactRisk.code.split(',');

      code.textCode1 = parts[0];
      code.textCode2 = parts[1];
      code.textCode3 = parts[2];
      code.textCode4 = parts[3];
    } else {
      code.textCode1 = '';
      code.textCode2 = '';
      code.textCode3 = '';
      code.textCode4 = '';
    }

    super.initState();
  }

  Future getContact() async {
    contactlist = await editVC.getContacts(context);

    setState(() {});
  }

  void saveDate(BuildContext context) async {
    var contactRisk = ContactRiskBD(
        id: widget.contactRisk.id,
        photo: contactSelect.photo,
        name: contactSelect.displayName,
        timeinit: widget.contactRisk.timeinit,
        timefinish: widget.contactRisk.timefinish,
        phones: contactSelect.phones.first.toString(),
        titleMessage: titleMessage,
        messages: message,
        sendLocation: sendLocation,
        sendWhatsapp: sendWhatsappSMS,
        isInitTime: isTimeInit,
        isFinishTime: isTimeFinish,
        code: widget.contactRisk.code,
        isActived: isActived,
        isprogrammed: isprogrammed);
    if (widget.contactRisk.id == -1) {
      contactRisk.id = widget.index;
      await editVC.saveContactRisk(context, contactRisk);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RiskPage(),
        ),
      );
    } else {
      await editVC.updateContactRisk(context, contactRisk);
    }
  }

  //capturar imagen de la galeria de fotos
  Future getImageGallery(ImageSource origen) async {
    final XFile? image = await _picker.pickImage(source: origen);
    File file;

    if (image != null) {
      file = File(image.path);
      setState(() {
        foto = file;
      });
    }

    if (foto != null) {
      showAlert(context, "Se guardo la imagen correctamente".tr);
    } else {
      showAlert(context, "Hubo un error, intente mas tarde".tr);
    }
  }

  Widget _mostrarFoto() {
    Uint8List? bytes;

    return GestureDetector(
      onTap: (() async {
        var result = await cameraPermissions(_prefs.getAcceptedCamera, context);
        if (result) getImageGallery(ImageSource.gallery);
      }),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 153, 169, 255).withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.all(
              Radius.circular(0.0) //                 <--- border radius here
              ),
          border: Border.all(color: ColorPalette.principal),
          image: DecorationImage(
            image: (foto != null || widget.contactRisk.photo != null)
                ? (foto != null
                    ? FileImage(foto, scale: 0.5)
                    : getImage(widget.contactRisk.photo!.toString()).image)
                : const AssetImage("assets/images/icons8.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(189, 196, 201, 1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1.0, bottom: 1),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 43, 35, 26),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50.0,
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: size.width / 3,
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Hora inicio:",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.barlow(
                                            fontSize: 20.0,
                                            wordSpacing: 1,
                                            letterSpacing: 0.001,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      height: 80,
                                      child: CupertinoTheme(
                                        data: const CupertinoThemeData(
                                          brightness: Brightness.dark,
                                          primaryColor: CupertinoColors.white,
                                          barBackgroundColor:
                                              CupertinoColors.white,
                                          scaffoldBackgroundColor:
                                              CupertinoColors.white,
                                          textTheme: CupertinoTextThemeData(
                                            primaryColor: CupertinoColors.white,
                                            textStyle: TextStyle(
                                                color: Colors.transparent),
                                          ),
                                        ),
                                        child: CupertinoDatePicker(
                                          key: const Key('init'),
                                          initialDateTime: parseDurationRow(
                                              widget.contactRisk.timeinit),
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: true,
                                          onDateTimeChanged: (value) {
                                            timeinit = value.toString();
                                            widget.contactRisk.timeinit =
                                                value.toString();
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1.0,
                                width: size.width,
                                color: Colors.white,
                              ),
                              Container(
                                height: 50.0,
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: size.width / 3,
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Hora fin:",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.barlow(
                                            fontSize: 20.0,
                                            wordSpacing: 1,
                                            letterSpacing: 0.001,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      height: 80,
                                      child: CupertinoTheme(
                                        data: const CupertinoThemeData(
                                          brightness: Brightness.dark,
                                          primaryColor: CupertinoColors.white,
                                          barBackgroundColor:
                                              CupertinoColors.black,
                                          scaffoldBackgroundColor:
                                              CupertinoColors.black,
                                          textTheme: CupertinoTextThemeData(
                                            primaryColor:
                                                CupertinoColors.opaqueSeparator,
                                            textStyle: TextStyle(
                                                color: Colors.transparent),
                                          ),
                                        ),
                                        child: CupertinoDatePicker(
                                          key: const Key('finish'),
                                          initialDateTime: parseDurationRow(
                                              widget.contactRisk.timefinish),
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: true,
                                          onDateTimeChanged: (value) {
                                            timefinish = value.toString();
                                            widget.contactRisk.timefinish =
                                                timefinish;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Establece tu clave de cancelación",
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
                      ContentCode(
                        code: code,
                        onChanged: (value) {
                          code = value;
                          widget.contactRisk.code =
                              '${value.textCode1},${value.textCode2},${value.textCode3},${value.textCode4}';
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Text(
                            "Después de la hora de fin llamar a:",
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
                      const SizedBox(
                        height: 12,
                      ),
                      CardContact(
                        visible: true,
                        photo: (indexSelect != -1 &&
                                contactlist.isNotEmpty &&
                                contactlist[indexSelect].photo != null)
                            ? contactlist[indexSelect].photo
                            : widget.contactRisk.photo,
                        name: (indexSelect != -1 &&
                                    contactlist.isNotEmpty &&
                                    contactlist[indexSelect].displayName !=
                                        '' ||
                                widget.contactRisk.name != '')
                            ? (indexSelect == -1)
                                ? widget.contactRisk.name
                                : contactlist[indexSelect].displayName
                            : name,
                        onChanged: (value) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => Container(
                              width: size.width,
                              height: size.height,
                              color: const Color.fromRGBO(169, 146, 125, 1),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 28.0, left: 8, right: 8),
                                child: PopUpContact(
                                  listcontact: contactlist,
                                  onChanged: (int value) {
                                    indexSelect = value;
                                    contactSelect = contactlist[value];
                                    widget.contactRisk.name =
                                        contactSelect.displayName;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 60.0,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 270,
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
                                onChanged: (value) {
                                  sendWhatsappSMS = value;
                                  widget.contactRisk.sendWhatsapp = value;
                                  setState(() {});
                                },
                                value: widget.contactRisk.sendWhatsapp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 8),
                      child: Container(
                        height: 50.0,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 270,
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
                                onChanged: (value) {
                                  sendLocation = value;
                                  widget.contactRisk.sendLocation = value;
                                  setState(() {});
                                },
                                value: widget.contactRisk.sendLocation,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 20,
                  color: Colors.transparent,
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onChanged: (valor) {
                              titleMessage = valor;
                            },
                            autofocus: false,
                            key: const Key("Asunto"),
                            initialValue: widget.contactRisk.titleMessage,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: "",
                              labelText: "Asunto",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.white), //<-- SEE HERE
                              ),
                              hintStyle: TextStyle(color: Colors.white),
                              filled: true,
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.barlow(
                              fontSize: 14.0,
                              wordSpacing: 1,
                              letterSpacing: 1,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                            onSaved: (value) => {},
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Messaje:",
                              labelText: widget.contactRisk.messages == ""
                                  ? 'Message:'
                                  : widget.contactRisk.messages,
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                            style: GoogleFonts.barlow(
                              fontSize: 14.0,
                              wordSpacing: 1,
                              letterSpacing: 1,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (value) {
                              message = value;
                            },
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 35,
                                    height: 25,
                                    color: Colors.transparent,
                                    child: IconButton(
                                      iconSize: 25,
                                      onPressed: () {
                                        getImageGallery(ImageSource.gallery);
                                      },
                                      icon: Column(
                                        children: [
                                          Container(
                                            height: 7.5,
                                            width: 14,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/clip.png'),
                                                fit: BoxFit.fill,
                                              ),
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 180,
                                  color: Colors.transparent,
                                  child: Text(
                                    "Añadir imagen",
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
                                _mostrarFoto(),
                              ],
                            ),
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
                                  onChanged: (value) {
                                    saveConfig = value;
                                  },
                                  value: saveConfig,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevateButtonFilling(
                  onChanged: (value) {
                    isActived = true;
                    isprogrammed = false;
                    saveDate(context);
                  },
                  mensaje: 'Iniciar cita ahora',
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevateButtonCustomBorder(
                  onChanged: (value) {
                    isActived = false;
                    isprogrammed = true;
                    saveDate(context);
                  },
                  mensaje: 'Programar Activación',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

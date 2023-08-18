import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Page/Calendar/calendarPopup.dart';
import 'package:ifeelefine/Page/Contact/Widget/filter_contact.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/ListDateRisk/Controller/riskPageController.dart';
import 'package:ifeelefine/Utils/Widgets/loading_page.dart';
import 'package:ifeelefine/Views/space_heidht_custom.dart';
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
import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/imagesPreview.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/popUpContact.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/imageAccordingWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

final _prefs = PreferenceUser();

class EditRiskPage extends StatefulWidget {
  const EditRiskPage(
      {super.key, required this.contactRisk, required this.index});

  final ContactRiskBD contactRisk;
  final int index;
  @override
  State<EditRiskPage> createState() => _EditRiskPageState();
}

class _EditRiskPageState extends State<EditRiskPage> {
  EditRiskController editVC = Get.put(EditRiskController());
  RiskController riskVC = Get.find<RiskController>();
  TextEditingController controllerText = TextEditingController();

  var isTimeInit = false;
  var isTimeFinish = false;
  var sendWhatsappSMS = false;
  var sendLocation = false;
  var saveConfig = false;
  var isActived = false;
  var isprogrammed = false;
  String timeinit = "";
  String timefinish = "";
  List<Contact> contactlist = [];
  Contact? contactSelect;
  var indexSelect = -1;
  var code = CodeModel();

  var titleMessage = "";
  var message = '';
  String name = 'Selecciona un contacto';

  late Image imgNew;
  File foto = File("");

  int _currentIndex = 0;

  List<File> imagePaths = [];
  List<Uint8List> imageData = [];
  String from = "";
  String to = "";
  bool isLoading = false;
  bool isSelectContact = false;
  late DateTime dateTimeTemp = DateTime.now();
  late DateTime dateTimeTempIncrease = DateTime.now();
  @override
  void initState() {
    // Agregar un día a la fecha actual
    String temp =
        '${dateTimeTemp.day}-${dateTimeTemp.month}-${dateTimeTemp.year} ';

    timeinit = "${temp}00:00";
    timefinish = "${temp}00:00";
    getContact();
    requestGalleryPermission();
    initDates();
    List<String> parts = [];
    if (widget.contactRisk.code != "") {
      parts = widget.contactRisk.code.split(',');
      isSelectContact = true;
      code.textCode1 = parts[0];
      code.textCode2 = parts[1];
      code.textCode3 = parts[2];
      code.textCode4 = parts[3];
    } else {
      isSelectContact = false;
      code.textCode1 = '';
      code.textCode2 = '';
      code.textCode3 = '';
      code.textCode4 = '';
    }
    if (widget.contactRisk.messages.isNotEmpty) {
      controllerText.text = widget.contactRisk.messages;
    }
    super.initState();
  }

  void initDates() async {
    await Jiffy.locale("es");

    var date = Jiffy(widget.contactRisk.createDate)
        .format('EEEE, d [de] MMMM [del] yyyy');

    setState(() {
      from = date.capitalizeFirst!;
      to = date.capitalizeFirst!;
    });
  }

  Future getContact() async {
    setState(() {
      isLoading = true;
    });
    contactlist = await getContacts(context);

    for (var element in contactlist) {
      if (widget.contactRisk.name == element.displayName) {
        int index = contactlist.indexOf(element);
        contactSelect = contactlist[index];
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  // Función para solicitar permiso de acceso a la galería
  Future<void> requestGalleryPermission() async {
    await cameraPermissions(_prefs.getAcceptedCamera, context);
  }

  void saveDate(BuildContext context) async {
    if (contactSelect == null) {
      showSaveAlert(context, Constant.info, "Debe seleccionar un contacto".tr);

      return;
    }
    setState(() {
      isLoading = true;
    });

    // Agregar un día a la fecha actual
    DateTime fechaMasUnDia = dateTimeTemp.add(const Duration(days: 1));

    String temp =
        '${dateTimeTemp.day}-${dateTimeTemp.month}-${dateTimeTemp.year} ';
    String temp2 =
        '${fechaMasUnDia.day}-${fechaMasUnDia.month}-${fechaMasUnDia.year} ';

    var initTimeTemp = "";
    var finishTimeTemp = "";
    List<String> partesdate = [];
    List<String> partesInit = [];
    int horasInit = 0;
    int minutosInit = 0;
    int totalMinutosInit = 0;
    if (widget.contactRisk.timeinit == "00:00") {
      widget.contactRisk.timeinit = "${temp}00:00";
    }
    if (widget.contactRisk.timefinish == "00:00") {
      widget.contactRisk.timefinish = "${temp}00:00";
    }

    partesdate = widget.contactRisk.timeinit.split(' ');
    partesInit = partesdate[1].split(':');
    horasInit = int.parse(partesInit[0]);
    minutosInit = int.parse(partesInit[1]);
    totalMinutosInit = horasInit * 60 + minutosInit;
    print("Total de minutos: $totalMinutosInit");

    List<String> partesDate = widget.contactRisk.timefinish.split(' ');
    List<String> partesFinish = partesDate[1].split(':');

    int horasFinish = int.parse(partesFinish[0]);
    int minutosFinish = int.parse(partesFinish[1]);

    int totalMinutosFinish = horasFinish * 60 + minutosFinish;

    print("Total de minutos: $totalMinutosFinish");

    if (totalMinutosInit > totalMinutosFinish) {
      initTimeTemp = temp + widget.contactRisk.timeinit.split(' ').last;
      finishTimeTemp = temp2 + widget.contactRisk.timefinish.split(' ').last;
    } else {
      initTimeTemp = temp + widget.contactRisk.timeinit.split(' ').last;
      finishTimeTemp = temp + widget.contactRisk.timefinish.split(' ').last;
    }
    DateTime now = DateTime.now();
    DateTime nowTemp = DateTime(now.year, now.month, now.day);
    var list = await convertImageData();
    var contactRisk = ContactRiskBD(
        id: widget.contactRisk.id,
        photo: contactSelect!.photo,
        name: contactSelect!.displayName,
        timeinit: initTimeTemp,
        timefinish: finishTimeTemp,
        phones: contactSelect!.phones.first.normalizedNumber
            .replaceAll("+34", "")
            .replaceAll(" ", ""),
        titleMessage: titleMessage,
        messages: message,
        sendLocation: widget.contactRisk.sendLocation,
        sendWhatsapp: sendWhatsappSMS,
        isInitTime: isTimeInit,
        isFinishTime: isTimeFinish,
        code: widget.contactRisk.code,
        isActived: isActived,
        isprogrammed: isprogrammed,
        photoDate: list,
        saveContact: widget.contactRisk.saveContact,
        createDate: nowTemp,
        taskIds: []);

    getchangeContact(context, contactRisk);
  }

  void getchangeContact(BuildContext context, ContactRiskBD contactRisk) async {
    if (widget.contactRisk.id == -1) {
      contactRisk.id = widget.index;
      bool save = await editVC.saveContactRisk(context, contactRisk);
      if (!save) {
        setState(() {
          isLoading = false;
          showSaveAlert(context, Constant.info, Constant.errorGeneric.tr);
        });

        return;
      }
    } else {
      bool edit = await editVC.updateContactRisk(context, contactRisk);
      if (!edit) {
        setState(() {
          isLoading = false;
          showSaveAlert(context, Constant.info, Constant.errorGeneric.tr);
        });

        return;
      } else {
        setState(() {
          showSaveAlert(context, Constant.info, Constant.saveCorrectly.tr);
        });
      }
    }

    setState(() {
      riskVC.update();
      isLoading = false;
      Navigator.of(context).pop();
    });
  }

  Future<List<Uint8List>> convertImageData() async {
    List<Uint8List> temp = [];

    Uint8List? bytes;
    String img64 = "";
    if (imagePaths.isEmpty) {
      return [];
    }
    for (var i = 0; i < imagePaths.length; i++) {
      var path = File(imagePaths[i].path);

      Uint8List? bytes;
      String img64 = "";

      if (path.path != "") {
        bytes = path.readAsBytesSync();
        img64 = base64Encode(bytes);
        if (temp.isEmpty) {
          temp.insert(0, bytes);
        } else {
          temp.insert(i, bytes);
        }
      }
    }

    return temp;
  }

  Image getImage(String urlImage) {
    Uint8List bytesImages = const Base64Decoder().convert(urlImage);

    return Image.memory(bytesImages,
        fit: BoxFit.fill, width: double.infinity, height: 250.0);
  }

  Widget getImageFile(File urlImage) {
    return urlImage.path == ''
        ? Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 153, 169, 255).withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(
                      0.0) //                 <--- border radius here
                  ),
              border: Border.all(color: ColorPalette.principal),
              image: const DecorationImage(
                image: AssetImage("assets/images/icons8.png"),
                fit: BoxFit.fill,
              ),
            ),
          )
        : Image.file(
            fit: BoxFit.fitHeight,
            scale: 3,
            urlImage,
            height: double.infinity,
            width: double.infinity,
          );
  }

  Widget getDateSelected(String dateType) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
            child: Text(dateType, style: textNomral18White()),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: TextButton(
              style: const ButtonStyle(alignment: Alignment.centerRight),
              onPressed: () async {
                var rangeDateTime = await showCalendar(context);

                if (rangeDateTime != null) {
                  if (rangeDateTime.from != null && rangeDateTime.to != null) {
                    dateTimeTemp = rangeDateTime.from!;
                    updateDate('De', rangeDateTime.from!);
                  } else if (rangeDateTime.from != null) {
                    dateTimeTemp = rangeDateTime.from!;
                    updateDate(dateType, rangeDateTime.from!);
                  }
                }
              },
              child: Text(dateType == "De:" ? from : to,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.barlow(
                    fontSize: 18.0,
                    wordSpacing: 1,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.normal,
                    color: Color.fromRGBO(222, 222, 222, 1),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  String getStringFromDate(String date) {
    return date.substring(0, date.length - 5);
  }

  void updateDate(String dateType, DateTime date) async {
    await Jiffy.locale("es");
    var strDate = Jiffy(date).format('EEEE, d [de] MMMM [del] yyyy');

    var tempFrom = from.toLowerCase().replaceAll("de ", "");
    tempFrom = tempFrom.replaceAll("del ", "");
    var fromDate = Jiffy(tempFrom, 'EEEE, d MMMM yyyy');

    var tempTo = to.toLowerCase().replaceAll("de ", "");
    tempTo = tempTo.toLowerCase().replaceAll("del ", "");
    var toDate = Jiffy(tempTo, 'EEEE, d MMMM yyyy');

    if (dateType == "De") {
      from = strDate.capitalizeFirst!;
      if (toDate.isBefore(date)) {
        to = strDate.capitalizeFirst!;
      }
    } else {
      if (fromDate.isSameOrBefore(date)) {
        to = strDate.capitalizeFirst!;
      } else {
        to = strDate.capitalizeFirst!;
        from = strDate.capitalizeFirst!;
      }
    }

    (context as Element).markNeedsBuild();
  }

  void _showContactListScreen(BuildContext context) async {
    Contact? cont;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FilterContactListScreen(onCountrySelected: (contact) {
          setState(() {
            cont = contact;
          });
        }),
      ),
    );

    if (cont!.name.first.isNotEmpty) {
      setState(() {
        contactSelect = cont!;
        widget.contactRisk.name = contactSelect!.displayName;
        isSelectContact = true;
        indexSelect =
            contactlist.indexWhere((item) => item.id == contactSelect!.id);
        print(indexSelect);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return LoadingIndicator(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text(
            "Edición de mensaje de cita",
            style: textForTitleApp(),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: decorationCustom(),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Center(
              child: Column(
                children: [
                  const SafeArea(
                    child: SpaceHeightCustom(
                      heightTemp: 10,
                    ),
                  ),
                  getDateSelected("De:"),
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
                                SizedBox(
                                  height: 50.0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: size.width / 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Hora inicio:",
                                            textAlign: TextAlign.left,
                                            style: textNormal20White(),
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
                                              primaryColor:
                                                  CupertinoColors.white,
                                              textStyle: TextStyle(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                          child: CupertinoDatePicker(
                                            key: const Key('init'),
                                            initialDateTime: parseStringHours(
                                                widget.contactRisk.timeinit
                                                    .split(' ')
                                                    .last),
                                            mode: CupertinoDatePickerMode.time,
                                            use24hFormat: true,
                                            onDateTimeChanged: (value) async {
                                              timeinit =
                                                  await convertDateTimeToStringTime(
                                                      value);
                                              widget.contactRisk.timeinit =
                                                  value.toString();
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
                                SizedBox(
                                  height: 50.0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: size.width / 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Hora fin:",
                                            textAlign: TextAlign.left,
                                            style: textNormal20White(),
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
                                              primaryColor: CupertinoColors
                                                  .opaqueSeparator,
                                              textStyle: TextStyle(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                          child: CupertinoDatePicker(
                                            key: const Key('finish'),
                                            initialDateTime: parseStringHours(
                                                widget.contactRisk.timefinish
                                                    .split(" ")
                                                    .last),
                                            mode: CupertinoDatePickerMode.time,
                                            use24hFormat: true,
                                            onDateTimeChanged: (value) async {
                                              timefinish =
                                                  await convertDateTimeToStringTime(
                                                      value);
                                              widget.contactRisk.timefinish =
                                                  value.toString();
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
                  const SpaceHeightCustom(heightTemp: 20),
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
                              letterSpacing: 0.001,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(222, 222, 222, 1),
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
                  const SpaceHeightCustom(heightTemp: 40),
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
                                letterSpacing: 0.001,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(222, 222, 222, 1),
                              ),
                            ),
                          ),
                        ),
                        const SpaceHeightCustom(heightTemp: 12),
                        CardContact(
                          isSelect: isSelectContact,
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
                            _showContactListScreen(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SpaceHeightCustom(heightTemp: 20),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 65.0,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 270,
                                color: Colors.transparent,
                                child: Text(
                                  "Enviar Whatsapp a mí contacto predefinido",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.barlow(
                                    fontSize: 14.0,
                                    wordSpacing: 1,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.normal,
                                    color:
                                        const Color.fromRGBO(222, 222, 222, 1),
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width / 6,
                                color: Colors.transparent,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: CupertinoSwitch(
                                    value: widget.contactRisk.sendWhatsapp,
                                    activeColor: ColorPalette.activeSwitch,
                                    trackColor: CupertinoColors.inactiveGray,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        sendWhatsappSMS = value!;
                                        widget.contactRisk.sendWhatsapp = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 65.0,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 270,
                                color: Colors.transparent,
                                child: Text(
                                  "Enviar mi última ubicación registrada",
                                  textAlign: TextAlign.left,
                                  style: textNormal14White(),
                                ),
                              ),
                              Container(
                                width: size.width / 6,
                                color: Colors.transparent,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: CupertinoSwitch(
                                    value: widget.contactRisk.sendLocation,
                                    activeColor: ColorPalette.activeSwitch,
                                    trackColor: CupertinoColors.inactiveGray,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        sendLocation = value!;
                                        widget.contactRisk.sendLocation = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SpaceHeightCustom(heightTemp: 5),
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
                                widget.contactRisk.titleMessage = valor;
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
                              style: textNormal14White(),
                              onSaved: (value) => {},
                            ),
                          ),
                          const SpaceHeightCustom(heightTemp: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: controllerText,
                              decoration: InputDecoration(
                                hintText: widget.contactRisk.messages,
                                labelText: "Mensaje",
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.white), //<-- SEE HERE
                                ),
                                hintStyle: const TextStyle(color: Colors.white),
                                filled: true,
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                              ),
                              style: textNormal14White(),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              onChanged: (value) {
                                message = value;
                                widget.contactRisk.messages = message;
                              },
                            ),
                          ),
                          const SpaceHeightCustom(heightTemp: 20),
                          Expanded(
                            flex: 0,
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    color: Colors.transparent,
                                    child: Text(
                                      "Añadir imagen",
                                      textAlign: TextAlign.left,
                                      style: textNormal14White(),
                                    ),
                                  ),
                                  ImageFanWidget(
                                    onChanged: (List<File> value) {
                                      imagePaths = value;
                                      setState(() {});
                                    },
                                    listImg: widget.contactRisk.photoDate,
                                    isEdit: false,
                                  ),
                                  Visibility(
                                    visible: imagePaths.isEmpty ? false : true,
                                    child: IconButton(
                                      onPressed: () {
                                        //action coe when button is pressed
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: SizedBox(
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: getImageFile(
                                                          imagePaths[
                                                              _currentIndex]),
                                                    ),
                                                    ButtonBar(
                                                      alignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.arrow_back),
                                                          onPressed: () {
                                                            _currentIndex =
                                                                (_currentIndex -
                                                                        1) %
                                                                    imagePaths
                                                                        .length;
                                                            if (_currentIndex <
                                                                0) {
                                                              _currentIndex =
                                                                  imagePaths
                                                                          .length -
                                                                      1;
                                                            }
                                                            (context as Element)
                                                                .markNeedsBuild();
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(Icons
                                                              .arrow_forward),
                                                          onPressed: () {
                                                            _currentIndex =
                                                                (_currentIndex +
                                                                        1) %
                                                                    imagePaths
                                                                        .length;
                                                            (context as Element)
                                                                .markNeedsBuild();
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.close),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.preview,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 276,
                                    child: Text(
                                      "Guardar esta configuración",
                                      textAlign: TextAlign.right,
                                      style: textNormal14White(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width / 6,
                                    child: Transform.scale(
                                      scale: 0.8,
                                      child: CupertinoSwitch(
                                        value: saveConfig,
                                        activeColor: ColorPalette.activeSwitch,
                                        trackColor:
                                            CupertinoColors.inactiveGray,
                                        onChanged: (bool? value) async {
                                          setState(() async {
                                            if (_prefs.getUserFree &&
                                                !_prefs.getUserPremium) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PremiumPage(
                                                            isFreeTrial: false,
                                                            img:
                                                                'pantalla3.png',
                                                            title:
                                                                'Tus citas más seguras con la versión Premium\n',
                                                            subtitle:
                                                                '\nCuando acabes tu cita, avisaremos a tu contacto sino desactivas esta alarma.')),
                                              ).then((value) {
                                                if (value != null && value) {
                                                  _prefs.setUserFree = false;
                                                  _prefs.setUserPremium = true;
                                                  var premiumController =
                                                      Get.put(
                                                          PremiumController());
                                                  premiumController
                                                      .updatePremiumAPI(true);
                                                }
                                              });
                                              return;
                                            }
                                            saveConfig = value!;
                                            widget.contactRisk.saveContact =
                                                value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SpaceHeightCustom(heightTemp: 20),
                  ElevateButtonFilling(
                    showIcon: false,
                    onChanged: (value) {
                      isActived = true;
                      isprogrammed = false;
                      widget.contactRisk.isActived = true;
                      widget.contactRisk.isprogrammed = false;
                      saveDate(context);
                    },
                    mensaje: 'Iniciar cita ahora',
                    img: '',
                  ),
                  const SpaceHeightCustom(heightTemp: 20),
                  ElevateButtonCustomBorder(
                    onChanged: (value) {
                      isActived = false;
                      isprogrammed = true;
                      widget.contactRisk.isActived = false;
                      widget.contactRisk.isprogrammed = true;
                      saveDate(context);
                    },
                    mensaje: 'Programar activación',
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

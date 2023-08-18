import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/contactZoneRiskBD.dart';
import 'package:ifeelefine/Page/Contact/Widget/filter_contact.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/cardContact.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/contentCode.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Page/Risk/DateRisk/Widgets/popUpContact.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/EditZoneRisk/Controller/EditZoneController.dart';
import 'package:ifeelefine/Page/Risk/ZoneRisk/PushAlert/PageView/pushAlert.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Utils/Widgets/loading_page.dart';

class EditZoneRiskPage extends StatefulWidget {
  const EditZoneRiskPage(
      {super.key, required this.contactRisk, required this.index});

  final ContactZoneRiskBD contactRisk;
  final int index;
  // final String timefinish;
  @override
  State<EditZoneRiskPage> createState() => _EditZoneRiskPageState();
}

class _EditZoneRiskPageState extends State<EditZoneRiskPage> {
  EditZoneController editZoneVC = EditZoneController();
  final PreferenceUser _prefs = PreferenceUser();
  var sendWhatsappSMS = false;
  var sendLocation = false;
  var saveConfig = false;

  var sendWhatsappContact = false;
  var callme = false;
  var save = false;
  bool isLoading = false;
  bool isSelectContact = true;
  String name = 'Selecciona un contacto';

  List<Contact> contactlist = [];
  late Contact contactSelect;
  var indexSelect = -1;
  var code = CodeModel();

  @override
  void initState() {
    getContact();
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

    if (widget.contactRisk.id != -1) {
      saveConfig = widget.contactRisk.save;
    }

    super.initState();
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
    setState(() {});
  }

  void saveContactZoneRisk(BuildContext context) async {
    var contactRisk = ContactZoneRiskBD(
        id: widget.contactRisk.id,
        photo: contactSelect.photo,
        name: widget.contactRisk.name,
        phones:
            contactSelect.phones.first.normalizedNumber.replaceAll("+34", ""),
        sendLocation: widget.contactRisk.sendLocation,
        sendWhatsapp: widget.contactRisk.sendWhatsapp,
        code: widget.contactRisk.code,
        isActived: true,
        sendWhatsappContact: widget.contactRisk.sendWhatsappContact,
        callme: widget.contactRisk.callme,
        save: widget.contactRisk.save,
        createDate: DateTime.now());

    if (saveConfig && widget.contactRisk.save == true) {
      if (widget.contactRisk.id == -1) {
        var save = await editZoneVC.saveContactZoneRisk(context, contactRisk);
        if (save) {
          Future.sync(() => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(Constant.info),
                    content: const Text(Constant.saveCorrectly),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                          goToPush(contactRisk);
                        },
                        child: const Text("Ok"),
                      )
                    ],
                  );
                },
              ));
        }
      } else {
        // contactRisk.id = widget.index;
        var update =
            await editZoneVC.updateContactZoneRisk(context, contactRisk);
        if (update) {
          Future.sync(() async => await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(Constant.info),
                    content: const Text(Constant.saveCorrectly),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                          goToPush(contactRisk);
                        },
                        child: const Text("Ok"),
                      )
                    ],
                  );
                },
              ));
        }
      }
    } else {
      goToPush(contactRisk);
    }
  }

  void goToPush(ContactZoneRiskBD contactRisk) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PushAlertPage(
          contactZone: contactRisk,
        ),
      ),
    );
  }

  Widget space(double heigth) {
    return SizedBox(
      height: heigth,
    );
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
        widget.contactRisk.name = contactSelect.displayName;
        isSelectContact = true;
        indexSelect =
            contactlist.indexWhere((item) => item.id == contactSelect.id);
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
            "Edición de zona de riesgo",
            style: textForTitleApp(),
          ),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          decoration: decorationCustom(),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Center(
              child: Column(
                children: [
                  const SafeArea(
                    child: SizedBox(
                      height: 30.0,
                    ),
                  ),
                  space(20),
                  SizedBox(
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12),
                            child: Text(
                              "En caso de no pulsar botón de alerta",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.barlow(
                                fontSize: 18.0,
                                wordSpacing: 1,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(222, 222, 222, 1),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 60.0,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 270,
                                      child: Text(
                                        "Enviar Whatsapp a",
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.barlow(
                                          fontSize: 14.0,
                                          wordSpacing: 1,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromRGBO(
                                              222, 222, 222, 1),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width / 6,
                                      child: Transform.scale(
                                        scale: 0.8,
                                        child: CupertinoSwitch(
                                          value:
                                              widget.contactRisk.sendWhatsapp,
                                          activeColor:
                                              ColorPalette.activeSwitch,
                                          trackColor:
                                              CupertinoColors.inactiveGray,
                                          onChanged: (bool value) {
                                            setState(() {
                                              sendWhatsappSMS = value;
                                              widget.contactRisk.sendWhatsapp =
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
                            Container(
                              color: Colors.transparent,
                              height: 50.0,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 270,
                                      child: Text(
                                        "Hacer llamada a",
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.barlow(
                                          fontSize: 14.0,
                                          wordSpacing: 1,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromRGBO(222, 222, 222, 1),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width / 6,
                                      child: Transform.scale(
                                        scale: 0.8,
                                        child: CupertinoSwitch(
                                          value: widget.contactRisk.callme,
                                          activeColor:
                                              ColorPalette.activeSwitch,
                                          trackColor:
                                              CupertinoColors.inactiveGray,
                                          onChanged: (bool value) async {
                                            if (_prefs.getUserFree &&
                                                !_prefs.getUserPremium) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PremiumPage(
                                                            isFreeTrial: false,
                                                            img:
                                                                'Mask group-6.png',
                                                            title:
                                                                "Protege tu Seguridad Personal las 24h:\n\n",
                                                            subtitle:
                                                                'Activa para que alertfriends les llame por teléfono')),
                                              ).then((value) {
                                                if (value != null && value) {
                                                  _prefs.setUserFree = false;
                                                  _prefs.setUserPremium = true;
                                                  var premiumController =
                                                      Get.put(
                                                          PremiumController());
                                                  premiumController
                                                      .updatePremiumAPI(true);
                                                  setState(() {});
                                                }
                                              });

                                              return;
                                            }
                                            callme = value;
                                            widget.contactRisk.callme = value;
                                            setState(() {});
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
                      ],
                    ),
                  ),
                  space(20),
                  SizedBox(
                    child: Column(
                      children: [
                        space(0),
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
                  space(20),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Colors.transparent,
                        height: 60.0,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 270,
                                child: Text(
                                  "Enviar Whatsapp a mi contacto predefinido",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.barlow(
                                    fontSize: 14.0,
                                    wordSpacing: 1,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        const Color.fromRGBO(222, 222, 222, 1),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width / 6,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: CupertinoSwitch(
                                    value:
                                        widget.contactRisk.sendWhatsappContact,
                                    activeColor: ColorPalette.activeSwitch,
                                    trackColor: CupertinoColors.inactiveGray,
                                    onChanged: (bool value) {
                                      sendWhatsappContact = value;
                                      widget.contactRisk.sendWhatsappContact =
                                          value;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        height: 60.0,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 270,
                                child: Text(
                                  "Enviar mi última ubicación registrada",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.barlow(
                                    fontSize: 14.0,
                                    wordSpacing: 1,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        const Color.fromRGBO(222, 222, 222, 1),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width / 6,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: CupertinoSwitch(
                                    value: widget.contactRisk.sendLocation,
                                    activeColor: ColorPalette.activeSwitch,
                                    trackColor: CupertinoColors.inactiveGray,
                                    onChanged: (bool value) async {
                                      if (_prefs.getUserFree &&
                                          !_prefs.getUserPremium) {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const PremiumPage(
                                                isFreeTrial: false,
                                                img: 'Pantalla4.jpg',
                                                title:
                                                    'Protege tu Seguridad Personal las 24h:\n\n',
                                                subtitle:
                                                    'Activa para enviar tu última ubicación'),
                                          ),
                                        ).then((value) {
                                          if (value != null && value) {
                                            _prefs.setUserFree = false;
                                            _prefs.setUserPremium = true;
                                            var premiumController =
                                                Get.put(PremiumController());
                                            premiumController
                                                .updatePremiumAPI(true);
                                          }
                                        });
                                        ;
                                        return;
                                      }
                                      sendLocation = value;
                                      widget.contactRisk.sendLocation = value;
                                      setState(() {});
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
                  Container(
                    color: Colors.transparent,
                    width: size.width,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 270,
                            child: Text(
                              "Guardar esta configuración",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.barlow(
                                fontSize: 14.0,
                                wordSpacing: 1,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(222, 222, 222, 1),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width / 6,
                            child: Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: widget.contactRisk.save,
                                activeColor: ColorPalette.activeSwitch,
                                trackColor: CupertinoColors.inactiveGray,
                                onChanged: (value) async {
                                  if (_prefs.getUserFree &&
                                      !_prefs.getUserPremium) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const PremiumPage(
                                              isFreeTrial: false,
                                              img: 'Pantalla4.jpg',
                                              title:
                                                  'Protege tu Seguridad Personal las 24h:\n\n',
                                              subtitle:
                                                  'Activa para enviar tu última ubicación')),
                                    ).then((value) {
                                      if (value != null && value) {
                                        _prefs.setUserFree = false;
                                        _prefs.setUserPremium = true;
                                        var premiumController =
                                            Get.put(PremiumController());
                                        premiumController
                                            .updatePremiumAPI(true);
                                      }
                                    });

                                    return;
                                  }
                                  saveConfig = value;
                                  widget.contactRisk.save = value;
                                  setState(() {});
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          space(20),
                          SizedBox(
                            child: Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: Text(
                                      "Establece tu clave de cancelación",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.barlow(
                                        fontSize: 18.0,
                                        wordSpacing: 1,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(222, 222, 222, 1),
                                      ),
                                    ),
                                  ),
                                ),
                                space(10),
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
                        ],
                      ),
                    ),
                  ),
                  space(20),
                  ElevateButtonCustomBorder(
                    onChanged: (value) {
                      // if (saveConfig) {
                      saveContactZoneRisk(context);
                      // }
                    },
                    mensaje: 'Iniciar',
                  ),
                  space(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

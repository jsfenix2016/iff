import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Controllers/contactUserController.dart';
import 'package:ifeelefine/Page/Contact/ListContact/PageView/list_contact_page.dart';

import 'package:ifeelefine/Page/Geolocator/PageView/geolocator_page.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/selectTimerCallSendSMS.dart';
import 'package:ifeelefine/Utils/Widgets/widgedContact.dart';
import 'package:notification_center/notification_center.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key, required this.isMenu});
  final bool isMenu;

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final ContactUserController contactVC = Get.put(ContactUserController());
  final PreferenceUser _prefs = PreferenceUser();
  final List<Contact> _selectedContacts = [];
  var indexSelect = -1;

  bool isPremium = true;
  bool isDeleteContact = false;
  late String timeSMS = "20 min";
  late String timeCall = "20 min";
  bool isAutorice = false;
  @override
  void initState() {
    if (!widget.isMenu) _prefs.saveLastScreenRoute("contact");

    super.initState();
  }

  Widget getHorizontalSlide() {
    return HorizontalSlidableButton(
      isRestart: true,
      borderRadius: const BorderRadius.all(Radius.circular(2)),
      height: 55,
      width: 296,
      buttonWidth: 60.0,
      color: ColorPalette.principal,
      buttonColor: const Color.fromRGBO(157, 123, 13, 1),
      dismissible: false,
      label: Image.asset(
        scale: 1,
        fit: BoxFit.fill,
        'assets/images/Group 969.png',
        height: 13,
        width: 21,
      ),
      onChanged: (SlidableButtonPosition value) async {
        if (value == SlidableButtonPosition.end) {
          if (_prefs.getUserPremium || _selectedContacts.isEmpty) {
            await showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                contentPadding: const EdgeInsets.all(0),
                content: ListContact(
                  onSelectContact: (Contact value) {
                    _selectedContacts.add(value);

                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PremiumPage(
                      isFreeTrial: false,
                      img: 'Pantalla5.jpg',
                      title: Constant.premiumChangeTimeTitle,
                      subtitle: '')),
            );
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 48.0),
              child: Center(
                child: Text(
                  (_prefs.getUserPremium)
                      ? 'Agregar mas contactos'
                      : _prefs.getUserFree && _selectedContacts.isNotEmpty
                          ? "Obtener Premium"
                          : "Agregar contato",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.barlow(
                    fontSize: 16.0,
                    wordSpacing: 1,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var temp = ModalRoute.of(context)!.settings.arguments;
    if (_selectedContacts.isEmpty && isDeleteContact == false && temp != null) {
      final parametro = temp as Contact;
      _selectedContacts.add(parametro);
    }

    return Scaffold(
      appBar: widget.isMenu
          ? AppBar(
              backgroundColor: Colors.brown,
              title: const Center(child: Text("Contactos")),
            )
          : null,
      body: Container(
        decoration: decorationCustom(),
        child: Column(
          children: [
            const SafeArea(
              child: SizedBox(
                height: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
              child: Text(
                "Selecciona un contacto para solicitarle autorización de envío de sms y de llamadas.",
                textAlign: TextAlign.center,
                style: GoogleFonts.barlow(
                  fontSize: 16.0,
                  wordSpacing: 1,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedContacts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      indexSelect = index;

                      setState(() {});
                    },
                    child: Dismissible(
                      background: Container(
                        color: Colors.transparent,
                        height: 80,
                        width: double.infinity,
                        child: const Center(
                          child: Text(
                            "Delete",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      onDismissed: ((direction) => {
                            setState(() {
                              isDeleteContact = true;
                              _selectedContacts.removeAt(index);
                            })
                          }),
                      key: UniqueKey(),
                      child: Container(
                        color: Colors.transparent,
                        height: 400,
                        width: double.infinity,
                        margin: const EdgeInsets.all(2),
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            width: double.infinity,
                            height: 400,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: Colors.transparent,
                                    blurRadius: 3.0,
                                    offset: Offset(0.0, 5.0),
                                    spreadRadius: 3.0),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(169, 146, 125, 0.5),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            100.0) //                 <--- border radius here
                                        ),
                                  ),
                                  height: 89,
                                  width: 280,
                                  child: Stack(
                                    children: [
                                      WidgetContact(
                                        displayName: _selectedContacts[index]
                                            .displayName,
                                        img: _selectedContacts[index].photo,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 10,
                                ),
                                Container(
                                  height: 230,
                                  color: Colors.transparent,
                                  child: SelectTimerCallSendSMS(
                                    onChanged: (TimerCallSendSmsModel value) {
                                      timeSMS = value.sendSMS;
                                      timeCall = value.call;
                                    },
                                    sendSm: '20 min',
                                    timeCall: '20 min',
                                  ),
                                ),
                                ElevateButtonCustomBorder(
                                  onChanged: (value) async {
                                    var save = await contactVC.saveListContact(
                                        context,
                                        _selectedContacts,
                                        timeSMS,
                                        timeCall,
                                        "5 min");
                                    if (save) {
                                      isAutorice = true;
                                      contactVC.authoritationContact(context);
                                    }
                                  },
                                  mensaje: "Solicitar autorización",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            getHorizontalSlide(),
            const SizedBox(
              height: 20,
            ),
            ElevateButtonCustomBorder(
              onChanged: (value) async {
                if (value) {
                  if (!isAutorice) {
                    showSaveAlert(context, Constant.info,
                        "Antes de continuar debe solicitar la autorización del contacto");
                    return;
                  }

                  if (widget.isMenu == false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InitGeolocator()),
                    );
                  } else {
                    NotificationCenter().notify('getContact');
                  }
                }
              },
              mensaje: widget.isMenu == true ? "Guardar" : "Continuar",
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

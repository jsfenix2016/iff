import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Controllers/contactUserController.dart';

import 'package:ifeelefine/Page/Geolocator/PageView/geolocator_page.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/CustomDropdownButtonWidgetContact.dart';

import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';
import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/selectTimerCallSendSMS.dart';
import 'package:ifeelefine/Utils/Widgets/widgedContact.dart';
import 'package:notification_center/notification_center.dart';

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
  late String timeSMS = "00:00 AM";
  late String timeCall = "00:00 AM";

  @override
  void initState() {
    _prefs.saveLastScreenRoute("contact");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                "Selecciona un contacto para solicitarle autorización de envio de sms y de llamadas.",
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
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: ContactDropdownButton(
                onChanged: (value) {
                  print(value);
                  if (_selectedContacts.length >= 1 && !isPremium) {
                    return;
                  }
                  _selectedContacts.add(value);
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedContacts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      indexSelect = index;
                      //TODO:OPEN MARKET
                      if (!isPremium) {
                        isPremium = true;
                      } else {
                        isPremium = false;
                      }
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
                                      print(value);
                                      timeSMS = value.sendSMS;
                                      timeCall = value.call;
                                    },
                                  ),
                                ),
                                ElevateButtonCustomBorder(
                                  onChanged: (value) async {
                                    contactVC.authoritationContact(context);
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
            ElevateButtonCustomBorder(
              onChanged: (value) async {
                if (value) {
                  // ignore: use_build_context_synchronously
                  await contactVC.saveListContact(
                      context, _selectedContacts, timeSMS, timeCall);
                  if (widget.isMenu == false) {
                    // ignore: use_build_context_synchronously
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
              mensaje: widget.isMenu == false ? "Guardar" : "Continuar",
            ),
          ],
        ),
      ),
    );
  }
}

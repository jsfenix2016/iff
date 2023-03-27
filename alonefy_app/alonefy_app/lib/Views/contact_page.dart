import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Controllers/contactUserController.dart';
import 'package:ifeelefine/Page/Geolocator/PageView/configGeolocator_page.dart';
import 'package:ifeelefine/Page/Geolocator/PageView/geolocator_page.dart';
import 'package:ifeelefine/Utils/Widgets/CustomDropdownButtonWidgetContact.dart';
import 'package:ifeelefine/Utils/Widgets/customDropDown.dart';
import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';
import 'package:ifeelefine/Utils/Widgets/selectTimerCallSendSMS.dart';
import 'package:ifeelefine/Utils/Widgets/widgedContact.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final ContactUserController contactVC = Get.put(ContactUserController());

  final List<Contact> _selectedContacts = [];
  var indexSelect = -1;

  bool isPremium = true;
  late String timeSMS = "00:00 AM";
  late String timeCall = "00:00 AM";

  @override
  void initState() {
    // userVC.g

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: const Center(child: Text("Contactos")),
        ),
        body: Container(
          decoration: decorationCustom(),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
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
                                  _createButtonCall(),
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
              _createButtonNext()
            ],
          ),
        ),
      ),
    );
  }

  Widget _createButtonNext() {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.principal)),
      label: const Text("Siguiente"),
      icon: const Icon(
        Icons.next_plan,
      ),
      onPressed: (() async {
        await contactVC.saveListContact(
            context, _selectedContacts, timeSMS, timeCall);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InitGeolocator()),
        );
      }),
    );
  }

  Widget _createButtonCall() {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.principal)),
      label: const Text("Solicitar autorización"),
      icon: const Icon(
        Icons.next_plan,
      ),
      onPressed: (() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserInactivityPage()),
        );
      }),
    );
  }
}

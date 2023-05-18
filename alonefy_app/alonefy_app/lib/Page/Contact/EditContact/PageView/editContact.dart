import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Controllers/contactUserController.dart';
import 'package:ifeelefine/Model/contact.dart';

import 'package:ifeelefine/Utils/Widgets/CustomDropdownButtonWidgetContact.dart';

import 'package:ifeelefine/Utils/Widgets/elevateButtonCustomBorder.dart';
import 'package:ifeelefine/Utils/Widgets/selectTimerCallSendSMS.dart';
import 'package:ifeelefine/Utils/Widgets/widgedContact.dart';
import 'package:notification_center/notification_center.dart';

class EditContact extends StatefulWidget {
  const EditContact({super.key, required this.contact});

  final ContactBD contact;
  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("Editar Contacto"),
      ),
      body: Container(
        decoration: decorationCustom(),
        child: Column(
          children: [
            const SafeArea(
              child: SizedBox(
                height: 20,
              ),
            ),
            Container(
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
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //                 <--- border radius here
                              ),
                        ),
                        height: 89,
                        width: 280,
                        child: Stack(
                          children: [
                            WidgetContact(
                              displayName: widget.contact.displayName,
                              img: widget.contact.photo,
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
            ElevateButtonCustomBorder(
              onChanged: (value) async {
                if (value) {
                  // ignore: use_build_context_synchronously
                  await contactVC.saveListContact(
                      context, _selectedContacts, timeSMS, timeCall);

                  NotificationCenter().notify('getContact');
                }
              },
              mensaje: "Guardar",
            ),
          ],
        ),
      ),
    );
  }
}

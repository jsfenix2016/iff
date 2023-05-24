import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/Contact/ListContact/PageView/list_contact_page.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';
import 'package:ifeelefine/Views/contact_page.dart';

import '../../../Common/Constant.dart';
import '../../../Common/colorsPalette.dart';
import '../../../Controllers/contactUserController.dart';
import '../../../Data/hive_data.dart';
import '../../../Provider/prefencesUser.dart';
import '../../../Utils/Widgets/elevatedButtonFilling.dart';
import '../../Premium/PageView/premium_page.dart';

final _prefs = PreferenceUser();

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final ContactUserController controller = Get.put(ContactUserController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: decorationCustom(),
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    SafeArea(
                      child: Container(
                        height: 100.0,
                      ),
                    ),
                    const WidgetLogoApp(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "Selecciona los contactos a quien deseas que ",
                              style: GoogleFonts.barlow(
                                  fontSize: 24.0,
                                  wordSpacing: 1,
                                  letterSpacing: 0.001,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  height: 1.5),
                            ),
                            TextSpan(
                              text: "AlertFriends ",
                              style: GoogleFonts.barlow(
                                  fontSize: 24.0,
                                  wordSpacing: 1,
                                  letterSpacing: 0.001,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                  height: 1.5),
                            ),
                            TextSpan(
                              text: "avise en una situación de emergencia.",
                              style: GoogleFonts.barlow(
                                  fontSize: 24.0,
                                  wordSpacing: 1,
                                  letterSpacing: 0.001,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  height: 1.5),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 72,
                    ),
                    Center(
                      child: ElevateButtonFilling(
                          onChanged: ((value) async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                contentPadding: const EdgeInsets.all(0),
                                content: ListContact(
                                  onSelectContact: (Contact value) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        settings:
                                            RouteSettings(arguments: value),
                                        builder: (context) => const ContactList(
                                          isMenu: false,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
                          mensaje: 'Añadir contacto'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

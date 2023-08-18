import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Page/Contact/ListContact/PageView/list_contact_page.dart';
import 'package:ifeelefine/Page/Contact/Widget/filter_contact.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';
import 'package:ifeelefine/Views/contact_page.dart';

import '../../../Controllers/contactUserController.dart';
import '../../../Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final ContactUserController controller = Get.put(ContactUserController());
  final _prefs = PreferenceUser();
  @override
  void initState() {
    _prefs.saveLastScreenRoute("addContact");
    // TODO: implement initState
    super.initState();
  }

  void _showContactListScreen(BuildContext context) async {
    ContactBD contactBD = ContactBD("", null, "", "", "", "", "", "Pendiente");
    Contact? cont;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FilterContactListScreen(onCountrySelected: (contact) {
          setState(() {
            cont = contact;
            contactBD = ContactBD(
                contact.displayName,
                contact.photo == null ? null : contact.photo,
                contact.displayName,
                "20 min",
                "20 min",
                "20 min",
                contact.phones.first.normalizedNumber
                    .replaceAll("+34", "")
                    .replaceAll(" ", ""),
                "Pendiente");
          });
        }),
      ),
    );

    if (cont!.name.first.isNotEmpty) {
      await const HiveData().saveUserContact(contactBD);
      setState(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            settings: RouteSettings(arguments: cont),
            builder: (context) => const ContactList(
              isMenu: false,
            ),
          ),
        );
        // Opcional: También puedes actualizar la variable user?.country aquí
      });
    }
  }

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
                        height: 50.0,
                      ),
                    ),
                    const WidgetLogoApp(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(44, 0, 44, 0),
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
                        showIcon: true,
                        onChanged: ((value) async {
                          _showContactListScreen(context);
                        }),
                        mensaje: 'Añadir contacto',
                        img: 'assets/images/User.png',
                      ),
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

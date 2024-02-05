import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';

import 'package:ifeelefine/Page/Contact/Widget/filter_contact.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/widgetLogo.dart';
import 'package:ifeelefine/Views/contact_page.dart';
import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';

import '../Controller/contactUserController.dart';
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
  bool isLoadingContactList = false;
  List<Contact> contactlistTemp = [];
  List<ContactBD> listContactDB = [];
  @override
  void initState() {
    starTap();
    // _prefs.saveLastScreenRoute("addContact");
    // TODO: implement initState
    super.initState();
    // _checkPermissionIsEnabled();
    NotificationCenter().subscribe('getContactBD', getContactBD);
    contactlistTemp = contactlist;
    getContactBD();
    getContactList(context);
  }

  void getContactBD() async {
    listContactDB = await controller.getAllContact();
    if (listContactDB.length != 0) {
      gotoContactlist();
    }
    controller.update();
  }

  void getContactList(BuildContext context) async {
    if (user != null && user!.idUser != '-1') {
      contactlist = await getContacts(context);
    }
  }

  void _showContactListScreen(BuildContext context) async {
    ContactBD contactBD = ContactBD("", null, "", "", "", "", "", "PENDING");
    Contact? cont;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FilterContactListScreen(oncontactSelected: (contact) {
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
                "PENDING");
            listContactDB.add(contactBD);
          });
        }),
      ),
    );
    if (cont == null) {
      return;
    }
    if (cont!.name.first.isNotEmpty) {
      await const HiveData().saveUserContact(contactBD);
      // Get.off(const ContactList(
      //   isMenu: false,
      // ));
      gotoContactlist();
      setState(() {});
    }
  }

  void gotoContactlist() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ContactList(
          isMenu: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Puedes controlar el comportamiento de retroceso aquí
        // Por ejemplo, puedes decidir volver a la pantalla de inicio o cerrar la aplicación.
        Navigator.of(context).pop(); // Vuelve a la pantalla anterior
        // Impide que se cierre la aplicación al presionar el botón físico de retroceso
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
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
                            if (listContactDB.isNotEmpty) {
                              Future.sync(
                                () async => {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Atención"),
                                        content: const Text(
                                            'Ya has seleccionado un contacto para situaciones de emergencia, ¿Quieres agregar otro?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("Continuar",
                                                style: textBold16Black()),
                                            onPressed: () => {
                                              Navigator.of(context).pop(),
                                              gotoContactlist()
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Agregar nuevo",
                                                style: textBold16Black()),
                                            onPressed: () => {
                                              if (_prefs.getUserPremium)
                                                {
                                                  Navigator.of(context).pop(),
                                                  _showContactListScreen(
                                                      context)
                                                }
                                              else
                                                {
                                                  Navigator.of(context).pop(),
                                                  if (listContactDB.isNotEmpty)
                                                    {
                                                      gotoContactlist(),
                                                    }
                                                }
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                },
                              );
                            } else {
                              _showContactListScreen(context);
                            }
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
      ),
    );
  }
}

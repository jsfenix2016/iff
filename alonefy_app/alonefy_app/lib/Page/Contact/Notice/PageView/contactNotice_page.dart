import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/notificationService.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Page/Contact/EditContact/PageView/editContact.dart';
import 'package:ifeelefine/Page/Contact/ListContact/PageView/list_contact_page.dart';
import 'package:ifeelefine/Page/Contact/Notice/Controller/contactNoticeController.dart';
import 'package:ifeelefine/Page/Contact/Widget/cellContactStatus.dart';
import 'package:ifeelefine/Page/Contact/Widget/filter_contact.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
import 'package:ifeelefine/Page/Premium/PageView/premium_page.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/main.dart';

import 'package:notification_center/notification_center.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactNoticePage extends StatefulWidget {
  const ContactNoticePage({super.key});

  @override
  State<ContactNoticePage> createState() => _ContactNoticePageState();
}

class _ContactNoticePageState extends State<ContactNoticePage> {
  final ContactNoticeController controller = Get.put(ContactNoticeController());
  final PreferenceUser _prefs = PreferenceUser();
  late List<ContactBD> listContact = [];
  List<Contact> contactlist = [];
  bool isLoadingContactList = false;
  @override
  void initState() {
    super.initState();
    starTap();
    NotificationCenter().subscribe('getContact', refreshContact);
    Future.sync(() => RedirectViewNotifier.setStoredContext(context));
    getContact();
  }

  Future refreshContact() async {
    getContact();
  }

  Future getContact() async {
    listContact = await controller.getAllContact();
    print(listContact);
    setState(() {});
  }

  void _showCountryListScreen(BuildContext context) async {
    ContactBD contactBD = ContactBD("", null, "", "", "", "", "", "PENDING");
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterContactListScreen(
          oncontactSelected: (contact) {
            setState(
              () {
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
              },
            );
          },
        ),
      ),
    );

    if (contactBD.phones.isNotEmpty) {
      setState(
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditContact(
                contact: contactBD,
                isEdit: false,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    RedirectViewNotifier.setStoredContext(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Configuración",
          style: textForTitleApp(),
        ),
      ),
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
                        height: 30.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Contacto aviso",
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
                      height: 32,
                    ),
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: false,
                        itemCount: listContact.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              print(index);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditContact(
                                    contact: listContact[index],
                                    isEdit: true,
                                  ),
                                ),
                              );
                            },
                            child: Center(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(169, 146, 125, 0.5),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          100.0) //                 <--- border radius here
                                      ),
                                ),
                                height: 80,
                                width: 320,
                                child: Stack(
                                  children: [
                                    CellContactStatus(
                                      contact: listContact[index],
                                      onChanged: (ContactBD value) {
                                        controller.deleteContact(value);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0, right: 80.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(
                                  0xFFCA9D0B), // El color #CA9D0B en formato ARGB (Alpha, Rojo, Verde, Azul)
                              Color(
                                  0xFFDBB12A), // El color #DBB12A en formato ARGB (Alpha, Rojo, Verde, Azul)
                            ],
                            stops: [
                              0.1425,
                              0.9594
                            ], // Puedes ajustar estos valores para cambiar la ubicación de los colores en el gradiente
                            transform: GradientRotation(92.66 *
                                (3.14159265359 /
                                    180)), // Convierte el ángulo a radianes para Flutter
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        height: 42,
                        child: Center(
                            child: ElevateButtonFilling(
                          showIcon: true,
                          onChanged: ((value) async {
                            if (_prefs.getUserFree && listContact.isNotEmpty) {
                              NotificationCenter().notify('getContact');
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PremiumPage(
                                      isFreeTrial: false,
                                      img: 'Mask group-7.png',
                                      title:
                                          'Protege tu Seguridad Personal las 24h:\n\n',
                                      subtitle:
                                          'Activa avisar a más contactos'),
                                ),
                              ).then(
                                (value) {
                                  if (value != null && value) {
                                    _prefs.setUserPremium = true;
                                    _prefs.setUserFree = false;
                                    var premiumController =
                                        Get.put(PremiumController());
                                    premiumController.updatePremiumAPI(true);
                                    setState(() {});
                                  }
                                },
                              );
                              return;
                            }
                            _showCountryListScreen(context);
                          }),
                          mensaje: 'Añadir contacto',
                          img: 'assets/images/User.png',
                        )),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
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

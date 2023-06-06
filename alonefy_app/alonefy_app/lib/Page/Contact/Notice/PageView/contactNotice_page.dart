import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Page/Contact/EditContact/PageView/editContact.dart';
import 'package:ifeelefine/Page/Contact/ListContact/PageView/list_contact_page.dart';
import 'package:ifeelefine/Page/Contact/Notice/Controller/contactNoticeController.dart';
import 'package:ifeelefine/Page/Contact/Widget/cellContactStatus.dart';
import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';

import 'package:notification_center/notification_center.dart';

class ContactNoticePage extends StatefulWidget {
  const ContactNoticePage({super.key});

  @override
  State<ContactNoticePage> createState() => _ContactNoticePageState();
}

class _ContactNoticePageState extends State<ContactNoticePage> {
  final ContactNoticeController controller = Get.put(ContactNoticeController());

  late List<ContactBD> listContact = [];
  @override
  void initState() {
    super.initState();
    NotificationCenter().subscribe('getContact', refreshContact);
    getContact();
  }

  Future refreshContact() async {
    getContact();
    setState(() {});
  }

  Future getContact() async {
    listContact = await controller.getAllContact();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("Configuración"),
      ),
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
                    height: 72,
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
                          onTap: () {},
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(169, 146, 125, 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(
                                        100.0) //                 <--- border radius here
                                    ),
                              ),
                              height: 79,
                              width: 280,
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
                  Center(
                    child: ElevateButtonFilling(
                        onChanged: ((value) async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              contentPadding: const EdgeInsets.all(0),
                              content: ListContact(
                                onSelectContact: (Contact value) {
                                  var contactBD = ContactBD(
                                      value.displayName,
                                      null,
                                      value.displayName,
                                      "5 min",
                                      "10 min",
                                      "5 min",
                                      value.phones.first.toString(),
                                      "Pendiente");
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditContact(
                                        contact: contactBD,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const ContactList(
                          //       isMenu: true,
                          //     ),
                          //   ),
                          // );
                        }),
                        mensaje: 'Añadir contacto'),
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
    );
  }
}

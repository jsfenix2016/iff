import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Controllers/contactUserController.dart';
import 'package:ifeelefine/Data/hive_data.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Page/Contact/ListContact/PageView/list_contact_page.dart';
import 'package:ifeelefine/Page/Contact/Widget/filter_contact.dart';

import 'package:ifeelefine/Page/Geolocator/PageView/geolocator_page.dart';
import 'package:ifeelefine/Page/Premium/Controller/premium_controller.dart';
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
            _showContactListScreen(context);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PremiumPage(
                      isFreeTrial: false,
                      img: 'Pantalla5.jpg',
                      title: Constant.premiumContactsTitle,
                      subtitle: '')),
            ).then(
              (value) {
                if (value != null && value) {
                  _prefs.setUserPremium = true;
                  _prefs.setUserFree = false;
                  var premiumController = Get.put(PremiumController());
                  premiumController.updatePremiumAPIFree(true);
                  setState(() {});
                }
              },
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
                      ? 'Agregar contactos'
                      : _prefs.getUserFree && _selectedContacts.isNotEmpty
                          ? "Obtener Premium"
                          : "Agregar contacto",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.barlow(
                    fontSize: 18.0,
                    wordSpacing: 1,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactListScreen(BuildContext context) async {
    Contact? cont;
    Contact? selectedContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FilterContactListScreen(onCountrySelected: (contact) async {
          ContactBD contactBDt = ContactBD(
              contact.displayName,
              contact.photo == null ? null : contact.photo,
              contact.displayName,
              "20 min",
              "20 min",
              "20 min",
              contact.phones.first.normalizedNumber.contains("+34")
                  ? contact.phones.first.normalizedNumber
                      .replaceAll("+34", "")
                      .replaceAll(" ", "")
                  : contact.phones.first.normalizedNumber,
              "Pendiente");

          await const HiveData().saveUserContact(contactBDt);

          setState(() {
            _selectedContacts.add(contact);
          });
        }),
      ),
    );

    if (cont!.name.first.isNotEmpty) {
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

  Widget listviewContact() {
    return FutureBuilder<List<ContactBD>>(
      future: contactVC.getAllContact(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final listContact = snapshot.data!;
          return ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.only(top: 0.0, bottom: 50),
            shrinkWrap: true,
            itemCount: listContact.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  indexSelect = index;

                  setState(() {});
                },
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
                              borderRadius: BorderRadius.all(Radius.circular(
                                      100.0) //                 <--- border radius here
                                  ),
                            ),
                            height: 89,
                            width: 280,
                            child: Stack(
                              children: [
                                WidgetContact(
                                  displayName: listContact[index].displayName,
                                  img: listContact[index].photo,
                                  delete: true,
                                  onDelete: (bool) {
                                    isDeleteContact = true;
                                    contactVC.deleteContact(listContact[index]);
                                    listContact.removeAt(index);
                                    _selectedContacts.removeAt(index);
                                    setState(() {});
                                  },
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
                              onChanged: (TimerCallSendSmsModel value) async {
                                timeSMS = value.sendSMS;
                                timeCall = value.call;
                                listContact[index].timeSendSMS = value.sendSMS;
                                listContact[index].timeCall = value.call;
                                await const HiveData()
                                    .updateContact(listContact[index]);
                              },
                              sendSm: listContact[index].timeSendSMS,
                              timeCall: listContact[index].timeCall,
                            ),
                          ),
                          ElevateButtonCustomBorder(
                            onChanged: (value) async {
                              timeSMS = listContact[index].timeSendSMS;
                              timeCall = listContact[index].timeCall;
                              var save = await contactVC.saveListContact(
                                  context,
                                  listContact[index],
                                  timeSMS,
                                  timeCall,
                                  "20 min");
                              if (save) {
                                isAutorice = true;
                                Future.sync(() =>
                                    contactVC.authoritationContact(context));
                              }
                            },
                            mensaje: "Solicitar autorización",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Text("");
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
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
        width: double.infinity,
        height: double.infinity,
        decoration: decorationCustom(),
        child: Column(
          children: [
            const SafeArea(
              child: SizedBox(
                height: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 46.0, right: 62.0, bottom: 30),
              child: Text(
                "Selecciona quien debe ser contactado en caso de inactividad",
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
              child: listviewContact(),
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

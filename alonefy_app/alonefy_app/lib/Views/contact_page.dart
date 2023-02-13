import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Controllers/contactUserController.dart';
import 'package:ifeelefine/Page/Geolocator/PageView/configGeolocator_page.dart';
import 'package:ifeelefine/Utils/Widgets/CustomDropdownButtonWidgetContact.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key, required this.isMenu});
  final bool isMenu;
  @override
  // ignore: library_private_types_in_public_api
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final ContactUserController userVC = Get.put(ContactUserController());

  final List<Contact> _selectedContacts = [];
  var indexSelect = -1;

  bool isPremium = false;
  // late String timeLblAM = "00:00 AM";
  late String timeSMS = "5 min";
  late String timeCall = '10 min';
  final _timeC = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: widget.isMenu
          ? AppBar(
              backgroundColor: ColorPalette.secondView,
              title: const Center(child: Text("Contactos")),
            )
          : null,
      body: Container(
        decoration: decorationCustom(),
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
              child: Text(
                "Selecciona un contacto para solicitarle autorización de envio de sms y de llamadas.",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                textAlign: TextAlign.center,
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
                  var img = _selectedContacts[index].photo ??
                      'assets/images/icons8.png';

                  return GestureDetector(
                    onTap: () {
                      indexSelect = index;

                      // if (!isPremium) {
                      //   isPremium = true;
                      // } else {
                      //   isPremium = false;
                      // }
                      setState(() {});
                    },
                    child: Dismissible(
                      background: Container(
                        color: Colors.red,
                        height: 80,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "Delete",
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
                      onDismissed: ((direction) => {
                            setState(() {
                              _selectedContacts.removeAt(index);
                            })
                          }),
                      key: UniqueKey(),
                      child: Container(
                        color: Colors.transparent,
                        height: 300,
                        width: double.infinity,
                        margin: const EdgeInsets.all(2),
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              color: ColorPalette.backgroundSwitch,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 3.0,
                                    offset: Offset(0.0, 5.0),
                                    spreadRadius: 3.0),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey[100],
                                      radius: 40.0,
                                      child: Image.asset(
                                        img.toString(),
                                        height: 80,
                                      ),
                                    ),
                                    title: SizedBox(
                                      child: Column(
                                        children: [
                                          Text(
                                            _selectedContacts[index]
                                                .displayName
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.barlow(
                                              fontSize: 16.0,
                                              wordSpacing: 1,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      var cont = _selectedContacts[index];
                                      print(cont.displayName);
                                      // if (!isPremium) {
                                      //   isPremium = true;
                                      // } else {
                                      //   isPremium = false;
                                      // }
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 160,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Enviar sms en:',
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
                                              !isPremium
                                                  ? Container(
                                                      height: 50,
                                                      color: Colors.transparent,
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: InkWell(
                                                            child: Text(
                                                              '5 min',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .barlow(
                                                                fontSize: 22.0,
                                                                wordSpacing: 1,
                                                                letterSpacing:
                                                                    1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            onTap: () =>
                                                                mostrarAlerta(
                                                                    context,
                                                                    'Activar premium para modificar el tiempo de envio de sms y llamada '),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      color: Colors.transparent,
                                                      height: 100,
                                                      width: 220,
                                                      child: Stack(
                                                        children: [
                                                          SizedBox(
                                                            child: Expanded(
                                                              child: ListView(
                                                                children: [
                                                                  ListView
                                                                      .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left: 8,
                                                                        right:
                                                                            8.0,
                                                                        top: 0),
                                                                    itemCount: Constant
                                                                        .timeDic
                                                                        .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              indexSelect = index;

                                                                              setState(() {
                                                                                timeSMS = Constant.timeDic[index.toString()].toString();
                                                                              });
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                                                              child: Container(
                                                                                key: const Key(""),
                                                                                width: 120,
                                                                                height: 80,
                                                                                color: Colors.transparent,
                                                                                child: Column(
                                                                                  children: [
                                                                                    Container(
                                                                                      width: 260,
                                                                                      height: 45,
                                                                                      color: indexSelect == index ? Colors.amber.withAlpha(20) : Colors.transparent,
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          Constant.timeDic[index.toString()].toString(),
                                                                                          textAlign: TextAlign.center,
                                                                                          style: GoogleFonts.barlow(
                                                                                            fontSize: 40.0,
                                                                                            wordSpacing: 1,
                                                                                            letterSpacing: 1,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 20,
                                                                                    ),
                                                                                    Container(
                                                                                      color: Colors.white,
                                                                                      height: 1,
                                                                                      width: 250,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 160,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Llamadas en:',
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
                                              !isPremium
                                                  ? Container(
                                                      height: 50,
                                                      color: Colors.transparent,
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: InkWell(
                                                            child: Text(
                                                              '10 min',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .barlow(
                                                                fontSize: 22.0,
                                                                wordSpacing: 1,
                                                                letterSpacing:
                                                                    1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            onTap: () =>
                                                                mostrarAlerta(
                                                                    context,
                                                                    'Activar premium para modificar el tiempo de envio de sms y llamada '),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      color: Colors.transparent,
                                                      height: 100,
                                                      width: 220,
                                                      child: Stack(
                                                        children: [
                                                          SizedBox(
                                                            child: Expanded(
                                                              child: ListView(
                                                                children: [
                                                                  ListView
                                                                      .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left: 8,
                                                                        right:
                                                                            8.0,
                                                                        top: 0),
                                                                    itemCount: Constant
                                                                        .timeDic
                                                                        .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              indexSelect = index;

                                                                              setState(() {
                                                                                timeCall = Constant.timeDic[index.toString()].toString();
                                                                              });
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                                                              child: Container(
                                                                                key: const Key(""),
                                                                                width: 120,
                                                                                height: 80,
                                                                                color: Colors.transparent,
                                                                                child: Column(
                                                                                  children: [
                                                                                    Container(
                                                                                      width: 260,
                                                                                      height: 45,
                                                                                      color: indexSelect == index ? Colors.amber.withAlpha(20) : Colors.transparent,
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          Constant.timeDic[index.toString()].toString(),
                                                                                          textAlign: TextAlign.center,
                                                                                          style: GoogleFonts.barlow(
                                                                                            fontSize: 40.0,
                                                                                            wordSpacing: 1,
                                                                                            letterSpacing: 1,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 20,
                                                                                    ),
                                                                                    Container(
                                                                                      color: Colors.white,
                                                                                      height: 1,
                                                                                      width: 250,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
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
    );
  }

  // Future displayTimePicker(BuildContext context) async {
  //   var time = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay.now(),
  //       builder: (context, childWidget) {
  //         return MediaQuery(
  //             data: MediaQuery.of(context).copyWith(
  //                 // Using 24-Hour format
  //                 alwaysUse24HourFormat: true),
  //             // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
  //             child: childWidget!);
  //       });
  //   if (time != null) {
  //     setState(() {
  //       if (time.hour > 11) {
  //         TimeOfDay timeOfDay = const TimeOfDay(hour: 0, minute: 0);
  //         _timeC.text = timeOfDay.format(context);
  //         timeLblAM = _timeC.text;
  //       } else {
  //         _timeC.text = time.format(context);
  //         timeLblAM = _timeC.text;
  //       }
  //     });
  //   }
  // }

  Widget _createButtonNext() {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ColorPalette.principal)),
      label: widget.isMenu ? const Text("Guardar") : const Text("Siguiente"),
      icon: const Icon(
        Icons.next_plan,
      ),
      onPressed: (() async {
        print(_selectedContacts);

        await userVC.saveListContact(
            context, _selectedContacts, timeSMS, timeCall);
        if (widget.isMenu) {
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ConfigGeolocator(
                      isMenu: false,
                    )),
          );
        }
        // userVC.
        // checkPermission();
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
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => UserInactivityPage()),
        // );
      }),
    );
  }
}

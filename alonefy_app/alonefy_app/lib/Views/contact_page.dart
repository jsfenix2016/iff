import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:get/get.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Controllers/contactUserController.dart';
import 'package:ifeelefine/Utils/Widgets/CustomDropdownButtonWidgetContact.dart';
import 'package:ifeelefine/Utils/Widgets/customDropDown.dart';
import 'package:ifeelefine/Page/UserInactivityPage/PageView/configurationUserInactivity_page.dart';
import 'package:ifeelefine/Page/PermissionUser/Pageview/permission_page.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:contacts_service/contacts_service.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late List<Contact> _contacts = [];
  final ContactUserController userVC = Get.put(ContactUserController());
  final TextEditingController _controller = TextEditingController();
  bool _permissionDenied = false;
  List<Contact> _contacts2 = [];
  final List<Contact> _selectedContacts = [];
  var indexSelect = -1;

  bool isPremium = false;
  late String timeLblAM = "00:00 AM";
  final _timeC = TextEditingController();

  Future _contactsPermissions() async {
    var status = await FlutterContacts.requestPermission();
    print(status);
    if (await Permission.contacts.request().isGranted) {
      //   // Either the permission was already granted before or the user just granted it.
      //   print("object");
      // } else {
      //   print("object");
    }
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.restricted;
    } else {
      return permission;
    }
  }

  //Function to import contacts
  getContacts() async {
    // PermissionStatus contactsPermissionsStatus = await _contactsPermissions();
    // if (contactsPermissionsStatus == PermissionStatus.granted) {
    //   List<Contact> _contacts =
    //       (await ContactsService.getContacts(withThumbnails: false)).toList();
    //   setState(() {
    //     _contacts = _contacts;
    //   });
    // }
  }

  Future checkPermission() async {
    _contactsPermissions();
    final PermissionStatus permissionStatus = await Permission.contacts.status;
    print("permission  - $permissionStatus");
    // if (permissionStatus == PermissionStatus.limited ||
    //     permissionStatus == PermissionStatus.granted) {
    // } else if (permissionStatus == PermissionStatus.denied) {
    _getContacts();
    //   checkPermission();
    // } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
    // } else if (permissionStatus == PermissionStatus.restricted) {}
    try {
      if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
        await Permission.contacts.request();
      }
    } catch (e) {
      print('e ${e.toString()}');
    }
  }

  // Future<List<Contact>> _fetchContacts() async {
  //   PermissionStatus permission = await Permission.contacts.status;
  //   if (permission != PermissionStatus.granted &&
  //       permission != PermissionStatus.denied) {
  //     return _selectedContacts;
  //   }
  //   if (await FlutterContacts.requestPermission()) {
  //     print("object");
  //     return _selectedContacts;
  //   }
  //   if (!await FlutterContacts.requestPermission(readonly: true)) {
  //     setState(() => _permissionDenied = true);
  //     return _selectedContacts;
  //   } else {
  //     final contacts = await FlutterContacts.getContacts();
  //     setState(() {
  //       _contacts = contacts;
  //     });

  //     return _contacts;
  //   }
  // }

  @override
  void initState() {
    // _getContacts();
    // TODO: implement initState
    super.initState();

    // _fetchContacts();
  }

  void _getContacts() async {
    // List<Contact> contacts = await FlutterContacts.getContacts(
    // withProperties: true, withPhoto: true);

    _contacts2 = await FlutterContacts.getContacts();
    print(_contacts2);
  }

  // CupertinoPicker _buildContactPicker() {
  //   return CupertinoPicker(
  //     itemExtent: 32.0,
  //     onSelectedItemChanged: (int index) {
  //       setState(() {
  //         _selectedContacts.add(_contacts2[index]);
  //       });
  //     },
  //     children: _contacts2.map((Contact contact) {
  //       return Text(contact.displayName);
  //     }).toList(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.principal,
          title: const Center(child: Text("Contactos")),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
              child: Text(
                "Selecciona un contacto para solicitarle autorización de envio de sms y de llamadas.",
                style: TextStyle(
                    color: Colors.black,
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
            // const CircularProgressIndicator(
            //   backgroundColor: Colors.amber,
            // ),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedContacts.length,
                itemBuilder: (context, index) {
                  var img = _selectedContacts[index].photo ??
                      'assets/images/icons8.png';

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

                      // Navigator.pushNamed(context, "product",
                      //     arguments: tempListDay[index]);
                    },
                    child: Dismissible(
                      background: Container(
                        color: Colors.red,
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
                        color: Colors.white,
                        height: 230,
                        width: double.infinity,
                        margin: const EdgeInsets.all(2),
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            width: double.infinity,
                            height: 215,
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      var cont = _selectedContacts[index];
                                      print(cont.displayName);
                                      if (!isPremium) {
                                        isPremium = true;
                                      } else {
                                        isPremium = false;
                                      }
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
                                          height: 90,
                                          child: Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Enviar sms en:',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              isPremium
                                                  ? CustomDropdownButtonWidgetWithDictionary(
                                                      instance:
                                                          Constant.timeDic,
                                                      mensaje: "10 min",
                                                      isVisible: true,
                                                      onChanged: (value) {
                                                        print(value);
                                                      },
                                                    )
                                                  : Expanded(
                                                      child: Container(
                                                        color: Colors.white,
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: InkWell(
                                                              child: const Text(
                                                                '10 min',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              onTap: () =>
                                                                  displayTimePicker(
                                                                      context),
                                                            ),
                                                          ),
                                                        ),
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
                                          height: 90,
                                          child: Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Llamadas en:',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              isPremium
                                                  ? CustomDropdownButtonWidgetWithDictionary(
                                                      instance:
                                                          Constant.timeDic,
                                                      mensaje: "15 min",
                                                      isVisible: true,
                                                      onChanged: (value) {
                                                        print(value);
                                                      },
                                                    )
                                                  : Expanded(
                                                      child: Container(
                                                        color: Colors.white,
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: InkWell(
                                                              child: const Text(
                                                                "15 min",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              onTap: () =>
                                                                  displayTimePicker(
                                                                      context),
                                                            ),
                                                          ),
                                                        ),
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

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child: childWidget!);
        });
    if (time != null) {
      setState(() {
        if (time.hour > 11) {
          TimeOfDay timeOfDay = const TimeOfDay(hour: 0, minute: 0);
          _timeC.text = timeOfDay.format(context);
          timeLblAM = _timeC.text;
        } else {
          _timeC.text = time.format(context);
          timeLblAM = _timeC.text;
        }
      });
    }
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
      onPressed: (() {
        checkPermission();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => PermitionUserPage()),
        // );
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

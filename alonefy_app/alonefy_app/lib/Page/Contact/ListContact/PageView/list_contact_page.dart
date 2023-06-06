import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Page/Contact/ListContact/Controller/list_contact_controller.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:permission_handler/permission_handler.dart';

class ListContact extends StatefulWidget {
  const ListContact({super.key, required this.onSelectContact});
  final ValueChanged<Contact> onSelectContact;
  @override
  State<ListContact> createState() => _ListContactState();
}

class _ListContactState extends State<ListContact> {
  final ListContactController controller = Get.put(ListContactController());

  var indexSelect = -1;

  List<Contact> _contacts = [];

  final _prefs = PreferenceUser();

  @override
  void initState() {
    super.initState();
    // Get the list of contacts from the device
    _checkPermissionIsEnabled();
  }

  void _checkPermissionIsEnabled() async {
    PermissionStatus permission = await Permission.contacts.request();

    if (permission.isPermanentlyDenied) {
      showPermition();
    } else if (permission.isDenied ||
        _prefs.getAcceptedContacts == PreferencePermission.noAccepted) {
      var permissionName = '${Constant.enableLocalPermission} contacto?';
      showLocalPermission(permissionName);
    } else {
      _getContacts();
    }
  }

  void showPermition() {
    showPermissionDialog(context, Constant.enablePermission);
  }

  void showLocalPermission(String permissionName) {
    showLocalPermissionDialog(
        context, permissionName, (bool response) => {alertResponse(response)});
  }

  void alertResponse(bool response) {
    _prefs.setAcceptedContacts =
        response ? PreferencePermission.allow : PreferencePermission.noAccepted;

    if (response) {
      _getContacts();
    }
  }

  void _getContacts() async {
    // Retrieve the list of contacts from the device
    var contacts = await FlutterContacts.getContacts();
    // Set the list of contacts in the state
    contacts = await FlutterContacts.getContacts(
        withProperties: true, withPhoto: true);
    setState(() {
      _contacts = contacts;
    });
  }

  Future<List<Contact>> getList() async {
    return _contacts;
  }

  Widget _mostrarFoto(Contact contact) {
    var img = contact.photo;
    if (indexSelect != -1 &&
        _contacts.isNotEmpty &&
        _contacts[indexSelect].photo != null) {
      img = _contacts[indexSelect].photo;
    }

    return Container(
      width: 79,
      height: 79,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
            Radius.circular(79.0) //                 <--- border radius here
            ),
        border: Border.all(color: Colors.blueAccent),
        image: DecorationImage(
          image: (indexSelect != -1 &&
                      _contacts.isNotEmpty &&
                      _contacts[indexSelect].photo != null ||
                  img != null)
              ? Image.memory(img!, fit: BoxFit.cover, width: 100, height: 100.0)
                  .image
              : const AssetImage("assets/images/icons8.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget listviewContactRisk() {
    return FutureBuilder<List<Contact>>(
      future: getList(),
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
              if (index >= 0 && index < listContact.length) {
                return Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: GestureDetector(
                    onTap: () {
                      widget.onSelectContact(listContact[index]);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(169, 146, 125, 0.5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                              100.0), //                 <--- border radius here
                        ),
                      ),
                      height: 79,
                      width: 180,
                      child: Stack(
                        children: [
                          _mostrarFoto(listContact[index]),
                          Positioned(
                            right: 0,
                            child: Center(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(100),
                                    topRight: Radius.circular(100),
                                  ),
                                ),
                                height: 79,
                                width: 200,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      height: 79,
                                      width: 150,
                                      child: Center(
                                        child: (listContact.isNotEmpty)
                                            ? Text(
                                                listContact[index].displayName,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.barlow(
                                                  fontSize: 18.0,
                                                  wordSpacing: 1,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Text(
                                                "Selecciona un contacto",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.barlow(
                                                  fontSize: 18.0,
                                                  wordSpacing: 1,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const CircularProgressIndicator();
            },
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorPalette.secondView,
        body: Container(
            color: ColorPalette.secondView, child: listviewContactRisk()));
  }
}

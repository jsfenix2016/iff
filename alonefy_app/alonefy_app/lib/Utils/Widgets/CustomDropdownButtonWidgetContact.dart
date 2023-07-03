import 'package:flutter/material.dart';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/widgedContact.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

class ContactDropdownButton extends StatefulWidget {
  const ContactDropdownButton({super.key, required this.onChanged});
  final ValueChanged<Contact> onChanged;

  @override
  State<ContactDropdownButton> createState() => _ContactDropdownButtonState();
}

class _ContactDropdownButtonState extends State<ContactDropdownButton> {
  List<Contact> _contacts = [];
  final List<Contact> _selectedContacts = [];
  late int indexTem = -1;
  final _prefs = PreferenceUser();

  @override
  void initState() {
    super.initState();
    // Get the list of contacts from the device
    _getContacts();
  }

  void _checkPermissionIsEnabled() async {
    PermissionStatus permission = await Permission.contacts.request();

    if (permission.isPermanentlyDenied) {
      showPermissionDialog(context, Constant.enablePermission);
    } else if (permission.isDenied ||
        _prefs.getAcceptedContacts == PreferencePermission.noAccepted) {
      var permissionName = '${Constant.enableLocalPermission} contacto?';
      showLocalPermissionDialog(context, permissionName,
          (bool response) => {alertResponse(response)});
    } else {
      _getContacts();
    }
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
    var contacts = await getContacts(context);
    // Set the list of contacts in the state
    // contacts = await FlutterContacts.getContacts(
    //     withProperties: true, withPhoto: true);
    setState(() {
      _contacts = contacts;
    });
  }

  void _selectContact(Contact contact) {
    setState(() {
      _selectedContacts.add(contact);
    });

    widget.onChanged(contact);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: Colors.brown,
      isExpanded: true,
      items: _contacts.map((contact) {
        return DropdownMenuItem<String>(
          alignment: Alignment.center,
          value: contact.displayName,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text(
              contact.displayName,
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
        );
      }).toList(),
      onChanged: (selectedContact) {
        // Find the index of the fist book whose title contains 'Novel'
        final int index2 = _contacts.indexWhere(
            (book) => book.displayName.contains(selectedContact.toString()));
        if (index2 != -1) {
          indexTem = index2;

          _selectContact(_contacts[index2]);
        }
      },
      hint: Text(
        'Selecciona un contacto',
        textAlign: TextAlign.center,
        style: GoogleFonts.barlow(
          fontSize: 16.0,
          wordSpacing: 1,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

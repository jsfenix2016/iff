import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactDropdownButton extends StatefulWidget {
  const ContactDropdownButton({super.key, required this.onChanged});
  final ValueChanged<Contact> onChanged;

  @override
  _ContactDropdownButtonState createState() => _ContactDropdownButtonState();
}

class _ContactDropdownButtonState extends State<ContactDropdownButton> {
  List<Contact> _contacts = [];
  final List<Contact> _selectedContacts = [];
  late int indexTem = -1;

  @override
  void initState() {
    super.initState();
    // Get the list of contacts from the device
    _getContacts();
  }

  void _getContacts() async {
    PermissionStatus permission = await Permission.contacts.request();

    if (permission.isPermanentlyDenied) {
      showPermissionDialog(context, Constant.enablePermission);
    } else if (permission.isDenied) {

    } else {
      // Retrieve the list of contacts from the device
      var contacts = await FlutterContacts.getContacts();
      // Set the list of contacts in the state
      setState(() {
        _contacts = contacts;
      });
    }
  }

  void _selectContact(Contact contact) {
    setState(() {
      _selectedContacts.add(contact);
    });

    widget.onChanged(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        isExpanded: true,
        items: _contacts.map((contact) {
          return DropdownMenuItem<String>(
            value: contact.displayName,
            child: Text(contact.displayName),
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
        hint: indexTem == -1
            ? const Text('Select contact')
            : Text(_contacts[indexTem].displayName),
      ),
    );
  }
}

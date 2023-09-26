import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/contact.dart';
import 'package:ifeelefine/Provider/prefencesUser.dart';
import 'package:ifeelefine/Utils/Widgets/loading_page.dart';
import 'package:ifeelefine/Utils/Widgets/widgedContact.dart';
import 'package:ifeelefine/main.dart';
import 'package:notification_center/notification_center.dart';
import 'package:permission_handler/permission_handler.dart';

class FilterContactListScreen extends StatefulWidget {
  final void Function(Contact) oncontactSelected;

  const FilterContactListScreen({super.key, required this.oncontactSelected});

  @override
  State<FilterContactListScreen> createState() =>
      _FilterContactListScreenState();
}

class _FilterContactListScreenState extends State<FilterContactListScreen> {
  String searchQuery = "";
  List<Contact> contactlistTemp = [];
  final _prefs = PreferenceUser();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    starTap();
    // NotificationCenter().subscribe('getContact', _getContacts);
    // Get the list of contacts from the device
    // _checkPermissionIsEnabled();
    contactlistTemp = contactlist;
  }

  @override
  Widget build(BuildContext context) {
    List<Contact> filteredcontact = contactlistTemp
        .where((contact) => contact.displayName
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return LoadingIndicator(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: TextField(
            style: textForTitleApp(),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
                hintText: "Buscar contacto", hintStyle: textNomral18White()),
          ),
        ),
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: WillPopScope(
            onWillPop: () async {
              // Cierra el teclado antes de retroceder
              Future.sync(() => FocusScope.of(context).unfocus());
              Navigator.pop(context, true);
              return true; // Permite la navegación hacia atrás
            },
            child: Container(
              decoration: decorationCustom(),
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: ListView.builder(
                itemCount: filteredcontact.length,
                itemBuilder: (context, index) {
                  Contact contact = filteredcontact[index];

                  return ListTile(
                    title: WidgetContact(
                      displayName: contact.displayName,
                      img: contact.photo,
                      delete: false,
                      onDelete: (bool) {},
                      isFilter: true,
                      isExpanded: false,
                    ),
                    onTap: () {
                      widget.oncontactSelected(contact);

                      Navigator.pop(
                          context, contact); // Volver a la pantalla anterior
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

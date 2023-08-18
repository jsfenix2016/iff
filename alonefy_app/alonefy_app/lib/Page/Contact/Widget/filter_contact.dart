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
import 'package:notification_center/notification_center.dart';
import 'package:permission_handler/permission_handler.dart';

class FilterContactListScreen extends StatefulWidget {
  final void Function(Contact) onCountrySelected;

  const FilterContactListScreen({required this.onCountrySelected});

  @override
  State<FilterContactListScreen> createState() =>
      _FilterContactListScreenState();
}

class _FilterContactListScreenState extends State<FilterContactListScreen> {
  String searchQuery = "";
  List<Contact> _contacts = [];
  final _prefs = PreferenceUser();
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationCenter().subscribe('getContact', _getContacts);
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
    // var contacts = await FlutterContacts.getContacts();
    // Set the list of contacts in the state
    var contacts = await getContacts(context);
    setState(() {
      _contacts = contacts;
      isLoading = false;
    });
  }

  Future<List<Contact>> getList() async {
    return _contacts = await getContacts(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Contact> filteredCountries = _contacts
        .where((country) => country.name.first
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return LoadingIndicator(
      isLoading: isLoading,
      child: Scaffold(
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
        body: Container(
          decoration: decorationCustom(),
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: ListView.builder(
            itemCount: filteredCountries.length,
            itemBuilder: (context, index) {
              Contact country = filteredCountries[index];

              return ListTile(
                title: WidgetContact(
                    displayName: country.displayName,
                    img: country.photo,
                    delete: false,
                    onDelete: (bool) {}),
                onTap: () {
                  widget.onCountrySelected(country);

                  Navigator.pop(context); // Volver a la pantalla anterior
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

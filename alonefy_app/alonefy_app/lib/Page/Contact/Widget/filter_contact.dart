import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:ifeelefine/Common/Constant.dart';

import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/manager_alerts.dart';

import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';

import 'package:ifeelefine/Utils/Widgets/loading_page.dart';
import 'package:ifeelefine/Utils/Widgets/widgedContact.dart';
import 'package:ifeelefine/main.dart';

class FilterContactListScreen extends StatefulWidget {
  final void Function(Contact) oncontactSelected;

  const FilterContactListScreen({super.key, required this.oncontactSelected});

  @override
  State<FilterContactListScreen> createState() =>
      _FilterContactListScreenState();
}

class _FilterContactListScreenState extends State<FilterContactListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String searchQuery = "";
  List<Contact> contactlistTemp = [];

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

  bool validateCOntactNumberLocal(Contact tempContact) {
    List<Phone> numerosEspana = tempContact.phones
        .where((phone) => esNumeroEspana(phone.number))
        .toList();
    if (numerosEspana.isEmpty) {
      showSaveAlert(context, Constant.info,
          'Por favor, seleccione un número de teléfono móvil español');

      return false;
    }

    if (numerosEspana.isEmpty) {
      showSaveAlert(context, Constant.info,
          'Por favor, seleccione un número de teléfono móvil español');

      return false;
    }
    return true;
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
      child: WillPopScope(
        onWillPop: () async {
          // Puedes controlar el comportamiento de retroceso aquí
          // Por ejemplo, puedes decidir volver a la pantalla de inicio o cerrar la aplicación.
          Navigator.of(context).pop(); // Vuelve a la pantalla anterior
          // Impide que se cierre la aplicación al presionar el botón físico de retroceso
          return false;
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.black,
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
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
                        onDelete: (bool value) {},
                        isFilter: true,
                        isExpanded: false,
                        onExpanded: (bool value) {},
                      ),
                      onTap: () async {
                        if (contact.phones.length > 1) {
                          // Si el contacto tiene más de un número de teléfono, mostrar un diálogo con opciones
                          var selectedPhone = await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Selecciona un número de teléfono'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: contact.phones.map((phone) {
                                    return ListTile(
                                      title: Text(phone.number),
                                      onTap: () {
                                        Navigator.pop(
                                            context,
                                            phone
                                                .number); // Devolver el número de teléfono seleccionado
                                      },
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          );
                          Contact? tempContact;
                          // Si el usuario selecciona un número de teléfono, llamar a la función de callback
                          if (selectedPhone != null) {
                            // Crear un nuevo objeto Contact con el número de teléfono actualizado
                            tempContact = Contact(
                                displayName: contact.displayName,
                                photo: contact.photo,
                                phones: [
                                  Phone(
                                      selectedPhone) // Usar el número de teléfono seleccionado
                                ]);
                          }

                          if (!validateCOntactNumberLocal(tempContact!)) {
                            return;
                          }

                          // Llamar a la función de callback con el nuevo objeto Contact
                          widget.oncontactSelected(tempContact);
                          Navigator.pop(context, tempContact);
                        } else {
                          // Si el contacto tiene un solo número de teléfono, seleccionarlo directamente
                          if (!validateCOntactNumberLocal(contact)) {
                            return;
                          }
                          widget.oncontactSelected(contact);
                          Navigator.pop(context,
                              contact); // Volver a la pantalla anterior
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

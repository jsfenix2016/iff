import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/user.dart';
import 'package:country_state_city_picker/model/select_status_model.dart'
    as StatusModel;

class StatesListScreen extends StatefulWidget {
  final List<String> states;
  final void Function(String) onStatesSelected;

  const StatesListScreen(
      {required this.states, required this.onStatesSelected});

  @override
  State<StatesListScreen> createState() => _StatesListScreenState();
}

class _StatesListScreenState extends State<StatesListScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<String> filteredCountries = widget.states
        .where((states) =>
            states.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: TextField(
          style: textNomral18White(),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: InputDecoration(
              hintText: "Buscar estado", hintStyle: textNomral18White()),
        ),
      ),
      body: Container(
        decoration: decorationCustom(),
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: ListView.builder(
          itemCount: filteredCountries.length,
          itemBuilder: (context, index) {
            String states = filteredCountries[index];
            return ListTile(
              title: Text(
                states,
                style: textNomral18White(),
              ),
              onTap: () {
                widget.onStatesSelected(states);
                Navigator.pop(context); // Volver a la pantalla anterior
              },
            );
          },
        ),
      ),
    );
  }
}

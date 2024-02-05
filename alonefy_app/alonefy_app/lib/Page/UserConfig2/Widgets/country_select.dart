import 'package:flutter/material.dart';

import 'package:ifeelefine/Common/decoration_custom.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

import 'package:country_state_city_picker/model/select_status_model.dart'
    as StatusModel;

class CountryListScreen extends StatefulWidget {
  final List<String> countries;
  final void Function(String) onCountrySelected;

  const CountryListScreen(
      {super.key, required this.countries, required this.onCountrySelected});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<String> filteredCountries = widget.countries
        .where((country) =>
            country.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.brown,
        title: TextField(
          style: textNomral18White(),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: InputDecoration(
              hintText: "Buscar país", hintStyle: textNomral18White()),
        ),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          decoration: decorationCustom(),
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: ListView.builder(
            itemCount: filteredCountries.length,
            itemBuilder: (context, index) {
              String country = filteredCountries[index];

              return ListTile(
                title: Text(
                  country,
                  style: textNomral18White(),
                ),
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

import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

class CustomDropdownStylelive extends StatefulWidget {
  const CustomDropdownStylelive(
      {Key? key,
      required this.instance,
      required this.mensaje,
      required this.isVisible,
      required this.onChanged})
      : super(key: key);

  final bool isVisible;
  final ValueChanged<String> onChanged;
  final Map<String, String> instance;
  final String mensaje;
  @override
  // ignore: library_private_types_in_public_api
  _CustomDropdownyStyleliveState createState() =>
      _CustomDropdownyStyleliveState();
}

class _CustomDropdownyStyleliveState extends State<CustomDropdownStylelive> {
  void _selectOption(String value) {
    setState(() {
      widget.onChanged(value);
    });
  }

  @override
  void initState() {
    _indexList = 0;
    super.initState();
  }

  late int _indexList;

  var _selectedLocation = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorPalette.principal,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: DropdownButton<String?>(
          underline: Container(), //empty line
          style: const TextStyle(fontSize: 18, color: Colors.black),
          dropdownColor: Colors.brown,
          iconEnabledColor: ColorPalette.principal, //Icon color
          hint: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.mensaje,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                wordSpacing: 1,
                letterSpacing: 0.001,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          value: _selectedLocation.isEmpty
              ? widget.instance[_indexList]
              : _selectedLocation,
          isExpanded: true,
          items: widget.instance.keys
              .toList()
              .map(
                (e) => DropdownMenuItem<String>(
                  value: widget.instance[e],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.instance[e] ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        wordSpacing: 1,
                        letterSpacing: 0.001,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            setState(() {
              _selectedLocation = v.toString();
              print(_selectedLocation);

              widget.onChanged(_selectedLocation);
            });
          },
        ),
      ),
    );
  }
}

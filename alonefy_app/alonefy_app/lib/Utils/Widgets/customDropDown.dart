import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Model/restday.dart';
import 'package:flutter/material.dart';

class CustomDropdownButtonWidgetWithDictionary extends StatefulWidget {
  const CustomDropdownButtonWidgetWithDictionary(
      {Key? key,
      required this.instance,
      required this.mensaje,
      required this.isVisible,
      required this.onChanged})
      : super(key: key);

  final bool isVisible;
  final ValueChanged<RestDay> onChanged;
  final Map<String, String> instance;
  final String mensaje;
  @override
  // ignore: library_private_types_in_public_api
  _CustomDropdownButtonWidgetStateWithDictionary createState() =>
      _CustomDropdownButtonWidgetStateWithDictionary();
}

class _CustomDropdownButtonWidgetStateWithDictionary
    extends State<CustomDropdownButtonWidgetWithDictionary> {
  var select = RestDay();

  @override
  void initState() {
    _indexList = 0;
    super.initState();
  }

  late int _indexList;

  var _selectedLocation = '';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String?>(
      underline: Container(
        height: 1,
        color: ColorPalette.principal,
      ),
      dropdownColor: ColorPalette.secondView,
      iconEnabledColor: ColorPalette.principal,
      hint: Text(
        widget.mensaje,
        style: const TextStyle(fontSize: 18, color: ColorPalette.principal),
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
              child: Text(
                widget.instance[e] ?? "",
                style: const TextStyle(
                    fontSize: 18, color: ColorPalette.principal),
              ),
            ),
          )
          .toList(),
      onChanged: (v) {
        setState(() {
          _selectedLocation = v.toString();

          select.day = v.toString();
          widget.onChanged(select);
        });
      },
    );
  }
}

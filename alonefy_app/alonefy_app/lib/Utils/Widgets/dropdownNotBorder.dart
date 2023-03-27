import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

class DropdownNotBorder extends StatefulWidget {
  const DropdownNotBorder(
      {Key? key,
      required this.instance,
      required this.mensaje,
      required this.isVisible,
      required this.onChanged})
      : super(key: key);

  final bool isVisible;
  final ValueChanged<String> onChanged;
  final List<String> instance;
  final String mensaje;
  @override
  // ignore: library_private_types_in_public_api
  _DropdownNotBorderState createState() => _DropdownNotBorderState();
}

class _DropdownNotBorderState extends State<DropdownNotBorder> {
  late int _indexList;

  var _selectedLocation = '';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
              color: ColorPalette.principal, width: 1, style: BorderStyle.none),
        ),
        child: SizedBox(
          height: 52,
          child: DropdownButton<String?>(
            underline: Container(
              height: 1,
              color: ColorPalette.principal,
            ),
            hint: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.mensaje,
                style: const TextStyle(
                    fontSize: 18, color: ColorPalette.principal),
              ),
            ),
            dropdownColor: Colors.brown,
            iconEnabledColor: ColorPalette.principal,
            value: _selectedLocation.isEmpty
                ? widget.instance[_indexList]
                : _selectedLocation,
            isExpanded: true,
            items: widget.instance
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        e,
                        style: const TextStyle(
                            fontSize: 18, color: ColorPalette.principal),
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) {
              setState(() {
                _selectedLocation = v.toString();
                widget.onChanged(_selectedLocation);
              });
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

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
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4),
          child: DropdownButton<String?>(
            underline: Container(), //empty line
            style: const TextStyle(fontSize: 18, color: Colors.black),
            dropdownColor: Colors.brown,
            icon: IconButton(
              alignment: Alignment.centerLeft,
              color: ColorPalette.principal,
              icon: const ImageIcon(
                AssetImage('assets/images/arrow_drop_down.png'),
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            iconEnabledColor: ColorPalette.principal, //Icon color
            hint: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                widget.mensaje,
                style: textNormal16White(),
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
                        style: textNormal16White(),
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
      ),
    );
  }
}

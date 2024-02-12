import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

import 'package:flutter/material.dart';

class CustomDropdownMaritalState extends StatefulWidget {
  const CustomDropdownMaritalState(
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
  _CustomDropdownMaritalStateState createState() =>
      _CustomDropdownMaritalStateState();
}

class _CustomDropdownMaritalStateState
    extends State<CustomDropdownMaritalState> {
  late int _indexList;

  var _selectedLocation = '';

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
            color: ColorPalette.principal,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: SizedBox(
          height: 55,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: DropdownButton<String?>(
              underline: Container(),
              hint: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  widget.mensaje,
                  style: textNormal16White(),
                ),
              ),
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
              iconEnabledColor: ColorPalette.principal, //Ico
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
                  widget.onChanged(_selectedLocation);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

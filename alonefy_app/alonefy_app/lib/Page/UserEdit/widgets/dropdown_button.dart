import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

class DropdownButtonListString extends StatefulWidget {
  DropdownButtonListString(
      {super.key,
      required this.list,
      required this.textTemp,
      required this.onChanged});
  final Map<String, String> list;
  final String textTemp;
  Function(String value) onChanged;
  @override
  State<DropdownButtonListString> createState() =>
      _DropdownButtonListStringState();
}

class _DropdownButtonListStringState extends State<DropdownButtonListString> {
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
            dropdownColor: Colors.brown,
            key: Key(widget.textTemp),
            underline: Container(
              height: 1,
              color: ColorPalette.principal,
            ),
            hint: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.textTemp,
                style: textNormal16White(),
              ),
            ),

            iconEnabledColor: ColorPalette.principal, //Ico
            value: widget.list[0],
            isExpanded: true,
            items: widget.list.keys
                .toList()
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: widget.list[e],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.list[e] ?? "",
                        style: textNormal16White(),
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) {
              // user!.age = v.toString();

              widget.onChanged(v.toString());
            },
          ),
        ),
      ),
    );
  }
}

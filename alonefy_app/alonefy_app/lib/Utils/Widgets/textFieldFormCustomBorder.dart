import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

class TextFieldFormCustomBorder extends StatefulWidget {
  const TextFieldFormCustomBorder({
    Key? key,
    required this.onChanged,
    required this.placeholder,
    required this.mesaje,
    required this.labelText,
    required this.typeInput,
  }) : super(key: key);
  final String placeholder;
  final String mesaje;
  final String labelText;
  final ValueChanged<String> onChanged;
  final TextInputType typeInput;

  @override
  State<TextFieldFormCustomBorder> createState() =>
      TextFieldFormCustomBorderState();
}

class TextFieldFormCustomBorderState extends State<TextFieldFormCustomBorder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3.0, right: 3.0),
      child: TextFormField(
        cursorColor: Colors.white,
        keyboardType: widget.typeInput,
        onChanged: (value) {
          widget.onChanged(value);
        },
        key: Key(widget.mesaje),
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          prefix: (widget.labelText == Constant.telephone)
              ? const Text('+34 ')
              : null,
          hintText: widget.mesaje,
          labelText: widget.labelText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorPalette.principal),
            borderRadius: BorderRadius.circular(100.0),
          ),
          focusColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: ColorPalette.principal), //<-- SEE HERE
            borderRadius: BorderRadius.circular(100.0),
          ),
          hintStyle: textNormal16White(),
          filled: false,
          labelStyle: textNormal16White(),
        ),
        style: textNormal16White(),
        onSaved: (value) => {widget.onChanged(value!)},
        validator: (value) {
          return widget.placeholder;
        },
      ),
    );
  }
}

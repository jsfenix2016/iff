import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/Constant.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';

class GenericText extends StatelessWidget {
  GenericText(
      {super.key,
      required this.text,
      required this.labeltext,
      required this.onChanged});
  String text;
  String labeltext;
  Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: TextFormField(
        cursorColor: Colors.white,
        onChanged: (valor) {
          onChanged(valor);
        },
        readOnly: labeltext.contains(Constant.email) ? true : false,
        autofocus: false,
        key: Key(text),
        initialValue: text,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          filled: false,
          hintText: text,
          labelText: labeltext,
          suffixIcon: labeltext.contains(Constant.email)
              ? null
              : const Icon(Icons.edit, color: ColorPalette.principal),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorPalette.principal),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: ColorPalette.principal), //<-- SEE HERE
          ),
          hintStyle: textNormal16White(),
          labelStyle: textNormal16White(),
        ),
        style: textNormal16White(),
        onSaved: (value) => {
          onChanged(value!),
        },
      ),
    );
  }
}

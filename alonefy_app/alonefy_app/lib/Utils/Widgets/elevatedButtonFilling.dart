import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/button_style_custom.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Common/decoration_custom.dart';

class ElevateButtonFilling extends StatefulWidget {
  const ElevateButtonFilling(
      {super.key, required this.onChanged, required this.mensaje});
  final ValueChanged<bool> onChanged;

  final String mensaje;
  @override
  State<ElevateButtonFilling> createState() => _ElevateButtonFillingState();
}

class _ElevateButtonFillingState extends State<ElevateButtonFilling> {
  @override
  void initState() {
    super.initState();
  }

  void _selectOption(bool tap) {
    widget.onChanged(tap);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: styleColorClear(),
      onPressed: () {
        _selectOption(true);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: linerGradientButtonFilling(),
          // color: ColorPalette.principal,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        height: 42,
        width: 200,
        child: Center(
          child: Text(
            widget.mensaje,
            style: textNormal16White(),
          ),
        ),
      ),
    );
  }
}

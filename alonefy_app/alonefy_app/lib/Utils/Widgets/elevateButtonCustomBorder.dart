import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/button_style_custom.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

class ElevateButtonCustomBorder extends StatefulWidget {
  const ElevateButtonCustomBorder(
      {super.key, required this.onChanged, required this.mensaje});
  final ValueChanged<bool> onChanged;

  final String mensaje;
  @override
  State<ElevateButtonCustomBorder> createState() =>
      _ElevateButtonCustomBorderState();
}

class _ElevateButtonCustomBorderState extends State<ElevateButtonCustomBorder> {
  @override
  void initState() {
    super.initState();
  }

  void _selectOption(bool tap) {
    setState(() {
      widget.onChanged(tap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: styleColorClear(),
      onPressed: (() {
        _selectOption(true);
      }),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: ColorPalette.principal),
        ),
        height: 42,
        width: 200,
        child: Center(
          child: Text(
            widget.mensaje,
            style: GoogleFonts.barlow(
              fontSize: 16.0,
              wordSpacing: 1,
              letterSpacing: 0.005,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

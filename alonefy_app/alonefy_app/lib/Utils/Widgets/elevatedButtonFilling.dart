import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

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
      style: ButtonStyle(
        shadowColor: MaterialStateProperty.all<Color>(
          Colors.transparent,
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.transparent,
        ),
      ),
      onPressed: () {
        _selectOption(true);
      },
      child: Container(
        decoration: const BoxDecoration(
          color: ColorPalette.principal,
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        height: 42,
        width: 200,
        child: Center(
          child: Text(
            widget.mensaje,
            style: GoogleFonts.barlow(
              fontSize: 16.0,
              wordSpacing: 1,
              letterSpacing: 1.2,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

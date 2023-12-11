import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

class ButtonStyleCustom {}

ButtonStyle styleColorClear() {
  return ButtonStyle(
    shadowColor: MaterialStateProperty.all<Color>(
      Colors.transparent,
    ),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)))),

    backgroundColor: MaterialStateProperty.all<Color>(
      const Color.fromRGBO(0, 0, 0, 0),
    ),
    overlayColor: MaterialStateProperty.all<Color>(
      Colors.white.withAlpha(800),
    ),

    elevation: MaterialStateProperty.all<double>(
        1), // Establece la elevación a 0 para quitar la sombra
  );
}

ButtonStyle styleColorWithColor() {
  return ButtonStyle(
    shadowColor: MaterialStateProperty.all<Color>(
      ColorPalette.principal,
    ),
    backgroundColor: MaterialStateProperty.all<Color>(
      ColorPalette.principal,
    ),
    overlayColor: MaterialStateProperty.all<Color>(
      ColorPalette.principal,
    ),
    elevation: MaterialStateProperty.all<double>(
        0), // Establece la elevación a 0 para quitar la sombra
  );
}

ButtonStyle styleColorPrincipal() {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(ColorPalette.principal),
    elevation: MaterialStateProperty.all<double>(0),
    overlayColor: MaterialStateProperty.all<Color>(
      Colors.transparent,
    ),
  );
}

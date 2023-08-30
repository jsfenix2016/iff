import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

class ButtonStyleCustom {}

ButtonStyle styleColorClear() {
  return ButtonStyle(
    shadowColor: MaterialStateProperty.all<Color>(
      Colors.transparent,
    ),
    backgroundColor: MaterialStateProperty.all<Color>(
      Colors.transparent,
    ),
    overlayColor: MaterialStateProperty.all<Color>(
      Colors.transparent,
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

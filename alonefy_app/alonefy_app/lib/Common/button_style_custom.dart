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
  );
}

ButtonStyle styleColorPrincipal() {
  return ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(ColorPalette.principal));
}

import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

class DecorationCustom {}

BoxDecoration decorationCustom() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF150E03),
        Color.fromARGB(255, 91, 59, 21),
      ],
      stops: [0.11, 1.0],
    ),
  );
}

BoxDecoration decorationCustom2() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment(1, 0),
      colors: <Color>[
        ColorPalette.principalView,
        ColorPalette.secondView,
        ColorPalette.principalView,
      ],
      tileMode: TileMode.mirror,
    ),
  );
}

LinearGradient linerGradientButtonFilling() {
  return const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment(1, 0),
    colors: <Color>[
      Color.fromRGBO(202, 157, 11, 1.0),
      Color.fromRGBO(219, 177, 42, 1.0),
    ],
    tileMode: TileMode.mirror,
  );
}

BoxDecoration buttonPrincipalColorRadius8() {
  return BoxDecoration(
    color: const Color.fromRGBO(219, 177, 42, 1),
    border: Border.all(
      color: const Color.fromRGBO(219, 177, 42, 1),
    ),
    borderRadius: const BorderRadius.all(Radius.circular(8)),
  );
}

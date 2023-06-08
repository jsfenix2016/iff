import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

class DecorationCustom {}

BoxDecoration decorationCustom() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment(0, 2),
      colors: <Color>[
        ColorPalette.principalView,
        ColorPalette.secondView,
      ],
      tileMode: TileMode.mirror,
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
      ColorPalette.linerGradientText,
      ColorPalette.principal,
    ],
    tileMode: TileMode.mirror,
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

class TextStyleFont {}

TextStyle textNormal14White() {
  return GoogleFonts.barlow(
    fontSize: 14.0,
    wordSpacing: 1,
    letterSpacing: 1,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
}

TextStyle textNormal16Black() {
  return GoogleFonts.barlow(
    fontSize: 16.0,
    wordSpacing: 1,
    letterSpacing: 0.001,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
}

TextStyle textNormal16White() {
  return GoogleFonts.barlow(
    fontSize: 16.0,
    wordSpacing: 1,
    letterSpacing: 0.001,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
}

TextStyle textNomral18White() {
  return GoogleFonts.barlow(
    fontSize: 18.0,
    wordSpacing: 1,
    letterSpacing: 1.2,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
}

TextStyle textNormal20White() {
  return GoogleFonts.barlow(
    fontSize: 20.0,
    wordSpacing: 1,
    letterSpacing: 0.001,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
}

TextStyle textBold20White() {
  return GoogleFonts.barlow(
    fontSize: 20.0,
    wordSpacing: 1,
    letterSpacing: 1,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

TextStyle textBold24PrincipalColor() {
  return GoogleFonts.barlow(
    fontSize: 24.0,
    wordSpacing: 1,
    letterSpacing: 1.2,
    height: 1.39,
    fontWeight: FontWeight.bold,
    color: ColorPalette.principal,
  );
}

TextStyle textBold36White() {
  return GoogleFonts.barlow(
    fontSize: 36.0,
    wordSpacing: 1,
    letterSpacing: 0.001,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

TextStyle textBold16Black() {
  return GoogleFonts.barlow(
    fontSize: 16.0,
    wordSpacing: 1,
    letterSpacing: 1,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}

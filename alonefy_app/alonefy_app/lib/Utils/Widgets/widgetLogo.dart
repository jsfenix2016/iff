import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';

class WidgetLogoApp extends StatelessWidget {
  const WidgetLogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/logoAlertfriends.png'),
          fit: BoxFit.fill,
        ),
        color: Colors.transparent,
      ),
    );
  }
}

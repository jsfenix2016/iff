import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetHourTitle extends StatelessWidget {
  const GetHourTitle({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.barlow(
          fontSize: 20.0,
          wordSpacing: 1,
          letterSpacing: 0.001,
          fontWeight: FontWeight.w500,
          color: Colors.white),
    );
  }
}

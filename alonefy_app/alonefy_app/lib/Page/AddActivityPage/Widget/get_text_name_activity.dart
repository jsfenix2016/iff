import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetTextActivity extends StatelessWidget {
  GetTextActivity({super.key, required this.textController});
  TextEditingController textController;
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      controller: textController,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Nombre Actividad",
        hintStyle: GoogleFonts.barlow(
            fontSize: 20.0,
            wordSpacing: 1,
            letterSpacing: 0.001,
            fontWeight: FontWeight.w500,
            color: Colors.white),
        fillColor: const Color.fromRGBO(169, 146, 125, 0.2),
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      style: GoogleFonts.barlow(
          fontSize: 20.0,
          wordSpacing: 1,
          letterSpacing: 0.001,
          fontWeight: FontWeight.w500,
          color: Colors.white),
    );
  }
}

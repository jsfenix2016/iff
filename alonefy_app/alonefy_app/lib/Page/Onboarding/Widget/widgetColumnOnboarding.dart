import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

class WidgetColumnOnboarding extends StatefulWidget {
  const WidgetColumnOnboarding(
      {super.key,
      required this.img,
      required this.title,
      required this.subtitle});

  final String img;
  final String title;
  final String subtitle;
  @override
  State<WidgetColumnOnboarding> createState() => _WidgetColumnOnboardingState();
}

class _WidgetColumnOnboardingState extends State<WidgetColumnOnboarding> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          child: Image.asset(
            fit: BoxFit.fill,
            scale: 0.5,
            widget.img,
            height: 430,
            width: double.infinity,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            width: 350,
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.barlow(
                fontSize: 22.0,
                wordSpacing: 1,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                color: ColorPalette.principal,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            width: 350,
            child: Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.barlow(
                fontSize: 22.0,
                wordSpacing: 1,
                letterSpacing: 1,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

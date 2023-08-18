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
    final baseFontSize = 22.0;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final fontSize = baseFontSize * textScaleFactor;

    return Stack(
      children: [
        SizedBox(
          child: Image.asset(
            fit: BoxFit.fitHeight,
            scale: 3,
            widget.img,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Utiliza constraints para obtener el tamaño disponible
            // y configura adecuadamente tu widget
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment(0, 1),
                      colors: <Color>[
                        Colors.black,
                        Colors.transparent,
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  height: 300,
                  width: constraints.maxWidth,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 80.0, left: 44, right: 44),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.barlow(
                        fontSize: fontSize,
                        wordSpacing: 2,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                        color: ColorPalette.principal,
                      ),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  alignment: Alignment.center,
                  child: Container(
                    height: 290,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: const Alignment(0, 1),
                        colors: <Color>[
                          ColorPalette.secondView.withAlpha(10),
                          ColorPalette.secondView,
                          Colors.black,
                        ],
                        tileMode: TileMode.mirror,
                      ),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 18.0, left: 24, right: 24),
                      child: Text(
                        widget.subtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 26.0,
                          wordSpacing: 1,
                          letterSpacing: 0.001,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}

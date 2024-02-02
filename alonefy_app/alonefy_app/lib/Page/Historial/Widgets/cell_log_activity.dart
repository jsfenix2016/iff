import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Model/logActivityBd.dart';

class CellLogActivity extends StatefulWidget {
  const CellLogActivity({super.key, required this.logActive});
  final LogActivityBD logActive;
  @override
  State<CellLogActivity> createState() => _CellLogActivityState();
}

class _CellLogActivityState extends State<CellLogActivity> {
  @override
  Widget build(BuildContext context) {
    var a = widget.logActive.movementType.contains('-');
    if (a) {
      var temp2 = widget.logActive.movementType.split('-');
    }
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.logActive.movementType,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.barlow(
                      fontSize: 20.0,
                      wordSpacing: 1,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.logActive.time.toString(),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.barlow(
                      fontSize: 16.0,
                      wordSpacing: 1,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Container(
              height: 2,
              decoration: const BoxDecoration(color: ColorPalette.principal),
            )
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';

class CellLogAlerts extends StatefulWidget {
  const CellLogAlerts({super.key, required this.logAlert});
  final LogAlertsBD logAlert;
  @override
  State<CellLogAlerts> createState() => _CellLogAlertsState();
}

class _CellLogAlertsState extends State<CellLogAlerts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 70,
      width: 300,
      child: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                iconSize: 35,
                color: ColorPalette.principal,
                onPressed: () {},
                icon: searchImageForIcon(widget.logAlert.type),
              ),
              Container(
                color: Colors.transparent,
                height: 70,
                width: 200,
                child: Stack(children: [
                  Positioned(
                    top: 10,
                    child: Text(
                      widget.logAlert.type,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.barlow(
                        fontSize: 16.0,
                        wordSpacing: 1,
                        letterSpacing: 0.001,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    child: Text(
                      '${widget.logAlert.time.day}-${widget.logAlert.time.month}-${widget.logAlert.time.year} | ${widget.logAlert.time.hour}:${widget.logAlert.time.minute}',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.barlow(
                        fontSize: 16.0,
                        wordSpacing: 1,
                        letterSpacing: 0.001,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

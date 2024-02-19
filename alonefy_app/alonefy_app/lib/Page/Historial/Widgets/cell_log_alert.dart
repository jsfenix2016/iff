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
      height: 80,
      width: 310,
      child: Stack(
        children: [
          Container(
            color: Colors.transparent,
            height: widget.logAlert.type.contains('- ') ? 80 : 70,
            width: 310,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  iconSize: 35,
                  color: ColorPalette.principal,
                  onPressed: () {},
                  icon: searchImageForIcon(widget.logAlert.type),
                ),
                Container(
                  color: Colors.transparent,
                  height: widget.logAlert.type.contains('- ') ? 80 : 70,
                  width: 230,
                  child: Stack(children: [
                    Positioned(
                      top: widget.logAlert.type.contains('- ') ? 0 : 10,
                      child: SizedBox(
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            widget.logAlert.type.replaceAll("- ", "\n"),
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
                      ),
                    ),
                    Positioned(
                      top: widget.logAlert.type.contains('- ') ? 50 : 40,
                      child: Text(
                        '${widget.logAlert.time.day}-${widget.logAlert.time.month}-${widget.logAlert.time.year} | ${widget.logAlert.time.hour.toString().padLeft(2, '0')}:${widget.logAlert.time.minute.toString().padLeft(2, '0')}',
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
          ),
        ],
      ),
    );
  }
}

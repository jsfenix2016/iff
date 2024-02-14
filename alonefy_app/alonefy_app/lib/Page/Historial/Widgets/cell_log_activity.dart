import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
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
                    style: textNormal20White(),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.logActive.time.toString(),
                    textAlign: TextAlign.right,
                    style: textNormal16White(),
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

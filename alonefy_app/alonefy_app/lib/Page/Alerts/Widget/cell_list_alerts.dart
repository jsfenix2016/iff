import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';
import 'package:ifeelefine/Common/text_style_font.dart';
import 'package:ifeelefine/Common/utils.dart';
import 'package:ifeelefine/Model/logAlertsBD.dart';

import 'package:ifeelefine/Utils/Widgets/elevatedButtonFilling.dart';
import 'package:ifeelefine/Utils/Widgets/line_paint.dart';

// ignore: must_be_immutable
class CellListAlerts extends StatelessWidget {
  CellListAlerts(
      {super.key,
      required this.showLine,
      required this.alert,
      required this.visibilyButton,
      required this.onCancel,
      required this.heightCell});
  bool showLine;
  final LogAlertsBD alert;
  final bool visibilyButton;
  final void Function(bool) onCancel;

  final double heightCell;
  String typeNotifyList = "";
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Center(
        child: Container(
          color: Colors.transparent,
          height: heightCell,
          width: 300,
          child: Stack(
            children: [
              Visibility(
                visible: visibilyButton,
                child: Positioned(
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Container(
                      height: 50,
                      width: 300,
                      color: Colors.transparent,
                      child: ElevateButtonFilling(
                        showIcon: false,
                        onChanged: (value) {
                          onCancel(true);
                        },
                        mensaje: "Desactivar",
                        img: '',
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                color: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      iconSize: 35,
                      color: ColorPalette.principal,
                      onPressed: () {},
                      icon: searchImageForIcon(alert.type),
                    ),
                    Container(
                      width: 220,
                      height: alert.type.toString().contains('-') ? 70 : 50,
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          Text(
                            alert.type.toString(),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            style: textNormal16White(),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Text(
                              '${alert.time.day}-${alert.time.month}-${alert.time.year} | ${alert.time.hour.toString().padLeft(2, '0')}:${alert.time.minute.toString().padLeft(2, '0')}',
                              textAlign: TextAlign.left,
                              style: textNormal16White(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (showLine) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 78.0, left: 20),
                  child: CustomPaint(
                    painter: LinePainter(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

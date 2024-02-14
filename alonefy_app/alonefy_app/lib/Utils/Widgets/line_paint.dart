import 'package:flutter/material.dart';
import 'package:ifeelefine/Common/colorsPalette.dart';

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorPalette.principal
      ..strokeWidth = 1.5;

    canvas.drawLine(
        const Offset(0.0, 70 / 2), Offset(size.width, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => false;
}

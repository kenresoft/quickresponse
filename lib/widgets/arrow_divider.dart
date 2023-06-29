import 'package:flutter/material.dart';
import 'package:quickresponse/data/constants/colors.dart';

class ArrowDivider extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppColor.divider;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(width, height / 2)
      ..lineTo(0, height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

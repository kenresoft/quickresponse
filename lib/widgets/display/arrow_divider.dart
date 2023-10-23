import 'package:flutter/material.dart';

import '../../data/constants/styles.dart';
import '../../providers/settings/prefs.dart';

class ArrowDivider extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppColor(theme).divider;

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

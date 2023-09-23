import 'package:flutter/material.dart';

class ColorMix extends StatelessWidget {
  const ColorMix({super.key, required this.child, this.gradient});

  final Widget child;
  final LinearGradient? gradient;

  @override
  Widget build(BuildContext context) {
    if (gradient != null) {
      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (Rect bounds) {
          return gradient!.createShader(bounds);
        },
        child: child,
      );
    } else {
      return SizedBox(child: child);
    }
  }
}

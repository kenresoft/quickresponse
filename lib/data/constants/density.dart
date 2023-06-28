import 'package:flutter/cupertino.dart';

class Density {
  Density.init(BuildContext context)
      : height = MediaQuery.of(context).size.height,
        width = MediaQuery.of(context).size.width,
        aspectRatio = MediaQuery.of(context).size.aspectRatio;

  final double height;
  final double width;
  final double aspectRatio;
}

extension Dp on num {
  double dpH(Density density) {
    if (density.height > density.width) {
      return this * density.height;
    }
    return this * density.width;
  }

  double dpW(Density density) {
    if (density.width < density.height) {
      return this * density.width;
    }
    return this * density.height;
  }
}

import 'package:flutter/cupertino.dart';

class Density {
  Density.init(BuildContext context)
      : height = /*510*/ MediaQuery.of(context).size.height,
        width = /*280*/ MediaQuery.of(context).size.width;

  final double height;
  final double width;
}

extension Dp on num {
  double dpH(Density density) {
    if (density.height > density.width) {
      return this * density.height / density.width;
    }
    return this * density.width / density.height;
  }

  double dpW(Density density) {
    if (density.width < density.height) {
      return this * ((density.width / density.height) * (density.width / 100))*density.width/10;
    }
    return this * density.height / density.width;
  }
}

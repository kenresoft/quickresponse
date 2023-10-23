import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/constants/styles.dart';
import '../providers/settings/prefs.dart';

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

extension BuildCxt<T> on BuildContext {
  void toast(T msg, [TextAlign? textAlign, Color? color]) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(msg.toString(), textAlign: textAlign, style: TextStyle(color: AppColor(theme).black)),
        backgroundColor: color ?? AppColor(theme).black,
        showCloseIcon: true,
      ),
    );
  }

  T? get extra => GoRouterState.of(this).extra as T;
}

extension LogExtension<T> on T {
  T get log {
    debugPrint(toString());
    return this;
  }
}

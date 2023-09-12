import 'package:flutter/cupertino.dart';

class AppColor {
  const AppColor._();

  static Color title = const Color(0xff3D4459);
  static Color title_2 = const Color(0xff4D5366);
  static Color black = const Color(0xff2D344B);
  static Color overlay = const Color(0x40A5ACBF);
  static Color text = const Color(0xffA5ACBF);
  static Color white = const Color(0xffFFFFFF);
  static Color alertBorder = const Color(0xffB1B6C7);
  static Color alert_1 = const Color(0xffFE6464);
  static Color alertTransparent = const Color(0xccFE6464);
  static Color alert_2 = const Color(0xffD80000);
  static Color background = const Color(0xffEFF2F9);
  static Color navIcon = const Color(0xffE0E2EB);
  static Color navIconSelected = const Color(0xffF22524);
  static Color action = const Color(0xffF22524);
  static Color action_2 = const Color(0xff32f224);
  static Color divider = const Color(0xffEDEEF3);
  static Color button = const Color(0xffFBEFF3);
  static Color fab = const Color(0xccFE6464);

  static LinearGradient alertMix = LinearGradient(
    colors: [alert_1, alert_2],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient iconMix = LinearGradient(
    colors: [title_2, black],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient textMix = LinearGradient(
    colors: [alert_2, alert_1],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient buttonMix = LinearGradient(
    colors: [button, alert_1],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

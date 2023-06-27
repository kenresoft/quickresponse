import 'package:flutter/cupertino.dart';

class AppColor {
  const AppColor._();

  static Color title = const Color(0xff3D4459);
  static Color title_2 = const Color(0xff4D5366);
  static Color black = const Color(0xff2D344B);
  static Color text = const Color(0xffA5ACBF);

  static Color alertBorder = const Color(0xffB1B6C7);
  static Color alert_1 = const Color(0xffFE6464);
  static Color alert_2 = const Color(0xffD80000);
  static Color background = const Color(0xffEFF2F9);
  static Color navIcon = const Color(0xffE0E2EB);
  static Color navIconSelected = const Color(0xffF22524);
  static Color action = const Color(0xffF22524);

  static LinearGradient alert = LinearGradient(
    colors: [alert_1, alert_2],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

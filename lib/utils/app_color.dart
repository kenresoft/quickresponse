part of '../data/constants/styles.dart';

class AppColor {
  AppColor(this.theme);

  //AppColor._() : theme = pref.theme;
  bool theme;

  /* var isDarkTheme = providerContainer.read(themeProvider);

  Color get bg => isDarkTheme ? const Color(0xff292A30) : const Color(0xffEFF2F9);

  Color get nav => isDarkTheme ? const Color(0xff2D344B) : const Color(0xffFFFFFF);
  Color get card => isDarkTheme ? const Color(0xff323333) : const Color(0xffFFFFFF);*/
  Color background = const Color(0xffEFF2F9);
  Color backgroundDark = const Color(0xff292A30);

  Color get title => theme ? const Color(0xff3D4459) : Colors.white;

  Color get title_2 => theme ? const Color(0xff4D5366) : Colors.white70;

  Color get black => theme ? const Color(0xff2D344B) : Colors.white;
  Color overlay = const Color(0x40A5ACBF);
  Color text = const Color(0xffA5ACBF);

  Color get white => theme ? const Color(0xffFFFFFF) : const Color(0xff2D344B);
  Color whiteTransparent = const Color(0xfcFFFFFF);
  Color alertBorder = const Color(0xffB1B6C7);
  Color alert_1 = const Color(0xffFE6464);
  Color alertTransparent = const Color(0xccFE6464);

  Color get alert_2 => theme ? const Color(0xffD80000) : AppColor(theme).alertBorder;

  Color get alert_2_ => const Color(0xffD80000);
  Color navIcon = const Color(0xffE0E2EB);
  Color navIconSelected = const Color(0xffF22524);
  Color action = const Color(0xffF22524);

  Color get border => theme ? const Color(0xffF22524) : AppColor(theme).white;
  Color action_2 = const Color(0xff32f224);
  Color divider = const Color(0xffEDEEF3);
  Color button = const Color(0xffFBEFF3);

  //Color fab = const Color(0xccFE6464);

  Color get fab => theme ? const Color(0xbbffffff) : AppColor(theme).black;

  LinearGradient get alertMix => LinearGradient(
        colors: [AppColor(theme).alert_1, AppColor(theme).alert_2_],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  LinearGradient get iconMix => LinearGradient(
        colors: [AppColor(theme).title_2, AppColor(theme).black],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  LinearGradient get textMix => LinearGradient(
        colors: [AppColor(theme).alert_2_, AppColor(theme).alert_1],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  // ---- Biometric Mix Start----//

  LinearGradient get authDefault => LinearGradient(
        colors: [AppColor(theme).black.withOpacity(0.2), AppColor(theme).black],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  LinearGradient get authSuccess => LinearGradient(
        colors: [Colors.green.shade200, Colors.green],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  LinearGradient get authError => LinearGradient(
        colors: [Colors.red.shade200, Colors.red],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  // ---- Biometric Mix End----//

  LinearGradient get buttonMix => LinearGradient(
        colors: [AppColor(theme).button, AppColor(theme).alert_1],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  Widget blend(Widget child, Color color) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [color, color],
          //stops: [0.0, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.clamp,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}

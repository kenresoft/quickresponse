class Constants {
  Constants._();

  static const String appName = 'Image Recommendation System';
  static const String root = '/';

  //Navigation routes
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String error = '/error';

  //Images route
  static const String imageDir = "assets/images";
  static const String iconDir = "assets/icons";

  //Images
  static const String profile = "$imageDir/profile.png";
  static const String laptop = "$imageDir/laptop.png";
  static const String moon = "$imageDir/moon.png";
  static const String tech = "$imageDir/tech.png";
  static const String web = "$imageDir/web.png";
  static const String spaceship = "$imageDir/spaceship.png";
  static const String www = "$imageDir/www.png";

  //Icons
  static const String appIcon = "$iconDir/icon.png";

  static var maps = {
    1: profile,
    2: laptop,
    3: moon,
    4: tech,
    5: web,
    6: spaceship,
    7: www,
  };
}

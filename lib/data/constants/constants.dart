class Constants {
  Constants._();

  static const String appName = 'QuickResponse';
  static const String packageName = 'quickresponse';
  static const String root = '/';

  //Navigation routes
  static const String home = '/home';
  static const String camera = '/camera';
  static const String contacts = '/contacts';
  static const String contactDetails = '/contactDetails';
  static const String call = '/call';
  static const String locationMap = '/locationMap';
  static const String mapScreen = '/mapScreen';
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
  static const String drivingPin = "$iconDir/driving_pin.png";
  static const String destinationMapMarker = "$iconDir/destination_map_marker.png";

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

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
  static const String editContactPage = '/editContactPage';
  static const String contactsPage = '/contactsPage';
  static const String call = '/call';
  static const String locationMap = '/locationMap';
  static const String mapScreen = '/mapScreen';
  static const String alarm = '/alarm';
  static const String message = '/message';
  static const String history = '/history';
  static const String settings = '/settings';
  static const String subscription = '/subscription';
  static const String authentication = '/authentication';
  static const String signIn = '/signIn';
  static const String reminderPage = '/reminderPage';
  static const String travellersAlarm = '/travellersAlarm';
  static const String chat = '/chat';
  static const String chatsList = '/chatsList';
  static const String newChatsList = '/newChatsList';
  static const String userSearchScreen = '/userSearchScreen';
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
  static const String logo = "$imageDir/logo.png";
  static const String logo2 = "$imageDir/logo2.jpg";

  //Icons
  static const String appIcon = "$iconDir/icon.png";
  static const String drivingPin = "$iconDir/driving_pin.png";
  static const String destinationMapMarker = "$iconDir/destination_map_marker.png";

  static const String fileComment = '/** DO NOT EDIT THIS FILE **/\n';
  static const List<String> emergencyMessages = [
    "I'm in danger, please help!",
    "Emergency, call 911!",
    "I need immediate assistance!",
    "Send help, it's an emergency!",
    "I'm hurt, call an ambulance!",
    "Fire emergency, call the firefighters!",
    "Please come quickly, it's urgent!",
    "Burglary in progress, call the police!",
    "Medical emergency, call for help!",
    "I'm lost and need assistance!",
    "I've been in an accident, call the authorities!",
    "There's a dangerous situation, help!",
    "Call the emergency services, I'm in trouble!",
    "Urgent help required, call now!",
    "This is an emergency situation, please respond!",
  ];
}

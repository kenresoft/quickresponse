import 'package:quickresponse/main.dart';

class EmergencyTip {
  final String category;
  final IconData iconData; // Icon for the tip
  final String shortDescription;
  final String longDescription;

  EmergencyTip({
    required this.category,
    required this.iconData,
    required this.shortDescription,
    required this.longDescription,
  });

  factory EmergencyTip.fromJson(Map<String, dynamic> json) {
    IconData iconData;
    iconData = switch (json['category']) {
      'fire' => FontAwesomeIcons.fire,
      'home_invasion' => FontAwesomeIcons.house,
      'robbery' => FontAwesomeIcons.personRifle,
      'assault' => FontAwesomeIcons.faceSadTear,
      'kidnapping' => FontAwesomeIcons.personRunning,
      'car_accident' => FontAwesomeIcons.car,
      'lost_in_the_woods' => FontAwesomeIcons.tree,
      'security' => FontAwesomeIcons.personMilitaryToPerson,
      'medical' => FontAwesomeIcons.hospital,
      _ => FontAwesomeIcons.personCircleQuestion
    };

    return EmergencyTip(
      category: json['category'],
      iconData: iconData,
      shortDescription: json['short_description'],
      longDescription: json['long_description'],
    );
  }
}

Future<List<EmergencyTip>> loadEmergencyTips() async {
  final String jsonString = await rootBundle.loadString('assets/data/emergency_tips.json');
  final jsonData = json.decode(jsonString);

  final List<EmergencyTip> tips = [];

  for (var tipData in jsonData['emergency_tips']) {
    final tip = EmergencyTip.fromJson(tipData);
    tips.add(tip);
  }
  tips.shuffle(Random()); // Shuffle the list of tips

  return tips;
}

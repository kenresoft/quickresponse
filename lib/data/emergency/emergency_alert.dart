import 'package:quickresponse/main.dart';

class EmergencyAlert {
  static int _idCounter = 1; // Static counter variable for auto-incrementing IDs
  final String id;
  final String type;
  final DateTime dateTime;
  final String location;
  final String details;
  final String customMessage;
  final bool hasLocationData;

  EmergencyAlert({
    required this.id,
    required this.type,
    required this.dateTime,
    required this.location,
    required this.details,
    required this.customMessage,
    required this.hasLocationData,
  });

  factory EmergencyAlert.fromJson(Map<String, dynamic> json) {
    return EmergencyAlert(
      id: json['id'],
      type: json['type'],
      dateTime: DateTime.parse(json['dateTime']),
      location: json['location'],
      details: json['details'],
      customMessage: json['customMessage'],
      hasLocationData: json['hasLocationData'],
    );
  }

  // Constructor for creating a new EmergencyAlert with auto-incremented ID
  EmergencyAlert.autoIncrement({
    required this.type,
    required this.dateTime,
    required this.location,
    required this.details,
    required this.customMessage,
    required this.hasLocationData,
  }) : id = (_idCounter++).toString(); // Assign auto-incremented ID during object creation

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'dateTime': dateTime.toIso8601String(),
      'location': location,
      'details': details,
      'customMessage': customMessage,
      'hasLocationData': hasLocationData,
    };
  }

  static String getAlertTypeFromCustomMessage(String customMessage) {
    final lowercaseMessage = customMessage.toLowerCase();
    for (var keyword in Constants.keywordsToTypes.keys) {
      if (lowercaseMessage.contains(keyword)) {
        return Constants.keywordsToTypes[keyword]!;
      }
    }
    return 'General Emergency';
  }

  static List<String> uniqueKeywordsValues() {
    List<String> list = [];
    //final lowercaseMessage = customMessage.toLowerCase();
    for (var keyword in Constants.keywordsToTypes.values) {
      if (!list.contains(keyword)) {
        list.add(keyword);
      }
    }
    return list;
  }
}

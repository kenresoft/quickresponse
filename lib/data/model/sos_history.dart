import 'package:cloud_firestore/cloud_firestore.dart';

class SOSHistory {
  final String? recipient;
  final String? type;
  final String? userId;
  final Timestamp? timestamp;
  final String? latitude;
  final String? longitude;
  final String? message;

  SOSHistory({
    this.recipient,
    this.type,
    this.userId,
    this.timestamp,
    this.latitude,
    this.longitude,
    this.message,
  });

  // Factory constructor to create an SOSHistory instance from a Firestore document snapshot
  factory SOSHistory.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return SOSHistory(
      recipient: data['recipient'] ?? '',
      type: data['type'] ?? '',
      userId: data['userId'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      latitude: data['latitude'] ?? '',
      longitude: data['longitude'] ?? '',
      message: data['message'] ?? '',
    );
  }

  // Convert SOSHistory object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'recipient': recipient,
      'type': type,
      'userId': userId,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
      'message': message,
    };
  }

  // Factory constructor to create an SOSHistory instance from a JSON map
  factory SOSHistory.fromJson(Map<String, dynamic> json) {
    return SOSHistory(
      recipient: json['recipient'],
      type: json['type'],
      userId: json['userId'],
      timestamp: json['timestamp'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['timestamp'])
          : null,
      latitude: json['latitude'],
      longitude: json['longitude'],
      message: json['message'],
    );
  }
}

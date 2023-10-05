import 'package:cloud_firestore/cloud_firestore.dart';

class LocationLog {
  final Timestamp? timestamp;
  final double? latitude;
  final double? longitude;

  LocationLog({
    this.timestamp,
    this.latitude,
    this.longitude,
  });

  factory LocationLog.fromJson(Map<String, dynamic> json) {
    return LocationLog(
      timestamp: json['timestamp'] as Timestamp?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

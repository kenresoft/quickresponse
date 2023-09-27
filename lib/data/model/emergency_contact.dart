import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyContact {
  final String id; // Unique ID for the contact document
  final String name;
  final String phoneNumber;
  final Timestamp timestamp; // Timestamp of when the contact was added

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.timestamp,
  });

  // Factory constructor to create an EmergencyContact instance from a Firestore document snapshot
  factory EmergencyContact.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return EmergencyContact(
      id: snapshot.id,
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}

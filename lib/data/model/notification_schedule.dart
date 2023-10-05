import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationSchedule {
  final String? recipient;
  final String? type;
  final String? userId;
  final Timestamp? timestamp;
  final String? time;
  final String? title;
  final String? message;

  NotificationSchedule({
    this.recipient,
    this.type,
    this.userId,
    this.timestamp,
    this.time,
    this.title,
    this.message,
  });

  // Factory constructor to create an NotificationSchedule instance from a Firestore document snapshot
  factory NotificationSchedule.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return NotificationSchedule(
      recipient: data['recipient'] ?? '',
      type: data['type'] ?? '',
      userId: data['userId'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      time: data['time'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
    );
  }

  // Convert NotificationSchedule object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'recipient': recipient,
      'type': type,
      'userId': userId,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'time': time,
      'title': title,
      'message': message,
    };
  }

  // Factory constructor to create an NotificationSchedule instance from a JSON map
  factory NotificationSchedule.fromJson(Map<String, dynamic> json) {
    return NotificationSchedule(
      recipient: json['recipient'],
      type: json['type'],
      userId: json['userId'],
      timestamp: json['timestamp'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['timestamp'])
          : null,
      time: json['time'],
      title: json['title'],
      message: json['message'],
    );
  }
}

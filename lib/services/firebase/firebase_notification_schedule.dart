import 'dart:convert';

import '../../data/model/notification_schedule.dart';
import '../preference.dart';

// Create a new NotificationSchedule record in shared preferences
void addNotificationSchedule({
  required String userId,
  required String recipient,
  required String time,
  required String title,
  required String message,
}) {
  final notificationScheduleData = {
    'userId': userId,
    'recipient': recipient,
    'time': time,
    'title': title,
    'message': message,
  };

  final allNotificationSchedules = SharedPreferencesService.getStringList('notificationSchedules') ?? [];
  allNotificationSchedules.add(json.encode(notificationScheduleData));

  SharedPreferencesService.setStringList('notificationSchedules', allNotificationSchedules);
}

// Read NotificationSchedule records for a specific user from shared preferences
List<NotificationSchedule> getNotificationSchedules({required String userId, String? filter}) {

  final allNotificationSchedules = SharedPreferencesService.getStringList('notificationSchedules') ?? [];

  // You may filter the records here if needed based on the 'filter' parameter.

  return allNotificationSchedules
      .map((jsonString) => NotificationSchedule.fromJson(json.decode(jsonString)))
      .toList();
}

// Update a NotificationSchedule record in shared preferences
void updateNotificationSchedule({
  required String userId,
  required String time,
  required String title,
  required String message,
}) {
  final updatedNotificationScheduleData = {
    'time': time,
    'title': title,
    'message': message,
  };

  final allNotificationSchedules = SharedPreferencesService.getStringList('notificationSchedules') ?? [];

  for (int i = 0; i < allNotificationSchedules.length; i++) {
    final notificationScheduleData = json.decode(allNotificationSchedules[i]);
    if (notificationScheduleData['userId'] == userId && notificationScheduleData['time'] == time) {
      allNotificationSchedules[i] = json.encode(updatedNotificationScheduleData);
      break;
    }
  }

  SharedPreferencesService.setStringList('notificationSchedules', allNotificationSchedules);
}

// Delete a NotificationSchedule record from shared preferences
void deleteNotificationSchedule({
  required String userId,
  required String time,
}) {
  final allNotificationSchedules = SharedPreferencesService.getStringList('notificationSchedules') ?? [];

  allNotificationSchedules.removeWhere((jsonString) {
    final notificationScheduleData = json.decode(jsonString);
    return notificationScheduleData['userId'] == userId && notificationScheduleData['time'] == time;
  });

  SharedPreferencesService.setStringList('notificationSchedules', allNotificationSchedules);
}

void deleteNotificationScheduleById({
  required String userId,
  required String recipient,
}) {
  final allNotificationSchedules = SharedPreferencesService.getStringList('notificationSchedules') ?? [];

  allNotificationSchedules.removeWhere((jsonString) {
    final notificationScheduleData = json.decode(jsonString);
    return notificationScheduleData['userId'] == userId && notificationScheduleData['recipient'] == recipient;
  });

  SharedPreferencesService.setStringList('notificationSchedules', allNotificationSchedules);
}

// Delete all NotificationSchedule records for a specific user from shared preferences
void deleteAllNotificationSchedules({required String userId}) {
  final allNotificationSchedules = SharedPreferencesService.getStringList('notificationSchedules') ?? [];

  allNotificationSchedules.removeWhere((jsonString) {
    final notificationScheduleData = json.decode(jsonString);
    return notificationScheduleData['userId'] == userId;
  });

SharedPreferencesService.setStringList('notificationSchedules', allNotificationSchedules);
}



/*
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/model/notification_schedule.dart';

final CollectionReference notificationScheduleCollection = FirebaseFirestore.instance.collection('users');

// Create a new SOS history record
Future<void> addFirebaseNotificationSchedule({
  required String userId,
  //required String type,
  required String recipient,
  required String time,
  required String title,
  required String message,
}) async {
  final userRef = notificationScheduleCollection.doc(userId);
  final notificationScheduleData = {
    'userId': userId,
    //'type': type,
    'recipient': recipient,
    'timestamp': Timestamp.now(),
    'time': time,
    'title': title,
    'message': message,
  };

  await userRef.collection('notificationSchedule').doc(time).set(notificationScheduleData);
}

// Read SOS history records for a specific user
Stream<List<NotificationSchedule>> getFirebaseNotificationSchedule({required String userId, String? filter}) {
  final query = notificationScheduleCollection
      .doc(userId) // Assuming you want to retrieve SOS Alerts for a specific user
      .collection('notificationSchedule')
      .where('type', isEqualTo: filter)
      .orderBy('timestamp', descending: true);

  return query.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => NotificationSchedule.fromSnapshot(doc)).toList();
  });
}

Future<void> updateFirebaseNotificationSchedule({
  required String userId,
  required String sosAlertId,
  required Timestamp timestamp,
  required String location,
  required String message,
}) async {
  final notificationScheduleRef = notificationScheduleCollection
      .doc(userId) // Assuming you want to update an SOS Alert for a specific user
      .collection('sosAlerts')
      .doc(sosAlertId);

  final notificationScheduleData = {
    'timestamp': timestamp,
    'location': location,
    'message': message,
  };

  await notificationScheduleRef.update(notificationScheduleData);
}

Future<void> deleteFirebaseNotificationSchedule({
  required String userId,
  required String time,
}) async {
  final sosAlertRef = notificationScheduleCollection
      .doc(userId) // Assuming you want to delete an SOS Alert for a specific user
      .collection('notificationSchedule')
      .doc(time);

  await sosAlertRef.delete();
}

Future<void> deleteAllFirebaseNotificationSchedule({
  required String userId,
}) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collectionGroup('notificationSchedule')
      .where('userId', isEqualTo: userId) // Assuming there's a field 'userId' in your documents
      .get();

  for (final doc in querySnapshot.docs) {
    await doc.reference.delete();
  }
}
*/

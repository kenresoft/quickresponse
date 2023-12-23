import 'dart:convert';

import '../../data/model/notification_schedule.dart';
import '../preference.dart';

// Create a new NotificationSchedule record in shared preferences
void addNotificationSchedule({required String userId, required String recipient, required String time, required String title, required String message}) {
  final notificationScheduleData = {'userId': userId, 'recipient': recipient, 'time': time, 'title': title, 'message': message};

  final allNotificationSchedules = SharedPreferencesService.getStringList('notificationSchedules') ?? [];
  allNotificationSchedules.add(json.encode(notificationScheduleData));

  SharedPreferencesService.setStringList('notificationSchedules', allNotificationSchedules);
}

// Read NotificationSchedule records for a specific user from shared preferences
List<NotificationSchedule> getNotificationSchedules({required String userId, String? filter}) {
  final allNotificationSchedules = SharedPreferencesService.getStringList('notificationSchedules') ?? [];

  // You may filter the records here if needed based on the 'filter' parameter.

  return allNotificationSchedules.map((jsonString) => NotificationSchedule.fromJson(json.decode(jsonString))).toList();
}

// Update a NotificationSchedule record in shared preferences
void updateNotificationSchedule({required String userId, required String time, required String title, required String message}) {
  final updatedNotificationScheduleData = {'time': time, 'title': title, 'message': message};

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
void deleteNotificationScheduleById({required String userId, required String recipient}) {
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

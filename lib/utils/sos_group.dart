import '../data/model/notification_schedule.dart';

class NotificationScheduleGroup {
  final DateTime date;
  final List<NotificationSchedule> items;

  NotificationScheduleGroup(this.date, this.items);
}

List<NotificationScheduleGroup> groupNotificationScheduleByDate(List<NotificationSchedule> sosHistoryList) {
  // Create a map to store SOS history items grouped by date
  final Map<DateTime, List<NotificationSchedule>> groupedMap = {};

  // Iterate through the SOS history items and group them by date
  for (final sosHistory in sosHistoryList) {
    final date = sosHistory.timestamp!.toDate(); // Convert Firestore Timestamp to DateTime
    final dateKey = DateTime(date.year, date.month, date.day); // Group by date without time

    if (groupedMap.containsKey(dateKey)) {
      groupedMap[dateKey]!.add(sosHistory);
    } else {
      groupedMap[dateKey] = [sosHistory];
    }
  }

  // Create a list of NotificationScheduleGroup objects from the grouped map
  final groupedNotificationSchedule = groupedMap.entries.map((entry) {
    return NotificationScheduleGroup(entry.key, entry.value);
  }).toList();

  // Sort the grouped list by date in descending order
  groupedNotificationSchedule.sort((a, b) => b.date.compareTo(a.date));

  return groupedNotificationSchedule;
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void scheduleNotification({required DateTime scheduledTime, required int notificationId, String? title, String? body}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('security_notification', 'Security Notification',
      channelDescription: 'Channel for security notifications',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      ongoing: true,
      autoCancel: false,
      icon: '@mipmap/notification_icon',
      sound: RawResourceAndroidNotificationSound('@raw/alarm'));

  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    notificationId, // Notification ID
    title,
    body,
    tz.TZDateTime.from(scheduledTime, tz.local),
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
    payload: 'alarm',
  );
}

void scheduleAlarmNotification({required int notificationId, String? title, String? body}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'security_notification',
    'Security Notification',
    channelDescription: 'Channel for security notifications',
    importance: Importance.max,
    priority: Priority.high,
    enableVibration: true,
    ongoing: true,
    autoCancel: false,
    icon: '@mipmap/notification_icon',
    sound: RawResourceAndroidNotificationSound('@raw/alarm'),
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    notificationId, // Notification ID
    title,
    body,
    platformChannelSpecifics,
    payload: 'alarm',
  );
}

Future<void> cancelNotification({required int notificationId}) async {
  await flutterLocalNotificationsPlugin.cancel(notificationId);
}

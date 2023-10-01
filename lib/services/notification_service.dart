import 'dart:async';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:quickresponse/utils/extensions.dart';

import '../data/model/notification_schedule.dart';
import '../widgets/display/notifications.dart';
import 'firebase/firebase_notification_schedule.dart';
import 'firebase/firebase_profile.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final Map<int, Timer> _timers = {};
  int consecutiveAlarms = 1;
  bool isAlarmActive = false;

  void scheduleNotificationBatch({
    required DateTime selectedDateTime,
    required void Function(NotificationSchedule schedule, int count) onTimerCallback,
    String? title,
    String? body,
    int batchSize = 10, // Adjust the batch size as needed
  }) {
    int intervalInSeconds = 10;
    int notificationIdPrefix = 100;

    // Calculate the total number of alarms required based on the selected time
    final int totalAlarms = (selectedDateTime.difference(DateTime.now()).inSeconds / intervalInSeconds).ceil();

    totalAlarms.log;
    cancelExistingSchedules();

    for (int batchIndex = 0; batchIndex < totalAlarms; batchIndex += batchSize) {
      final int endIndex = batchIndex + batchSize;
      final int currentBatchSize = endIndex <= totalAlarms ? batchSize : totalAlarms - batchIndex;

      final List<int> notificationIds = [];
      final List<DateTime> scheduledTimes = [];

      for (int i = batchIndex; i < batchIndex + currentBatchSize; i++) {
        final int notificationId = notificationIdPrefix + i + 1; // Unique notification ID
        final DateTime scheduledTime = DateTime.now().add(Duration(seconds: (i + 1) * intervalInSeconds));

        notificationIds.add(notificationId);
        scheduledTimes.add(scheduledTime);
      }

      scheduleNotifications(
        notificationIds: notificationIds,
        scheduledTimes: scheduledTimes,
        title: title,
        body: body,
      );

      // Schedule a timer for stopping the alarm and canceling this specific batch after 60 seconds
      final timer = Timer(Duration(seconds: (batchIndex + currentBatchSize) * intervalInSeconds), () {
        // Stop the alarm for this batch
        stopAlarm();

        // Cancel the notifications for this batch
        cancelNotifications(notificationIds);

        // Remove the timer from the list
        _timers.remove(batchIndex);

        consecutiveAlarms++;

        if (consecutiveAlarms >= 3) {
          onTimerCallback(NotificationSchedule(), consecutiveAlarms);
          consecutiveAlarms.log;
        }
      });

      // Store the timer
      _timers[batchIndex] = timer;
    }
  }

  // Schedule notifications for a batch of notification IDs and scheduled times
  void scheduleNotifications({
    required List<int> notificationIds,
    required List<DateTime> scheduledTimes,
    String? title,
    String? body,
  }) {
    for (int i = 0; i < notificationIds.length; i++) {
      final int notificationId = notificationIds[i];
      final DateTime scheduledTime = scheduledTimes[i];

      scheduleNotification(
        scheduledTime: scheduledTime,
        notificationId: notificationId,
        title: title,
        body: body,
      );

      getProfileInfoFromSharedPreferences().then(
            (profileInfo) => addFirebaseNotificationSchedule(
          userId: profileInfo.uid!,
          time: scheduledTime.toString(),
          recipient: notificationId.toString(),
          title: title ?? '',
          message: body ?? '',
        ),
      );
    }
  }

  void cancelNotifications(List<int> notificationIds) {
    for (int notificationId in notificationIds) {
      flutterLocalNotificationsPlugin.cancel(notificationId);
      getProfileInfoFromSharedPreferences().then(
            (profileInfo) => deleteFirebaseNotificationSchedule(userId: profileInfo.uid!, time: 'scheduledTime.toString()'),
      );
    }
  }

  // Cancel a specific timer
  void cancelTimer(int notificationId) {
    final timer = _timers[notificationId];
    if (timer != null) {
      timer.cancel();
      _timers.remove(notificationId);

      // Stop the alarm for this notification
      stopAlarm();
    }
  }

  void cancelAllTimers() {
    _timers.forEach((notificationId, timer) {
      timer.cancel();
    });
    _timers.clear();

    // Stop the alarm for all notifications
    stopAlarm();
  }

  void resetCounter(void Function(int count)? onResetCallback, {int? value}) {
    consecutiveAlarms = value ?? 0;
    if (onResetCallback != null) {
      onResetCallback(consecutiveAlarms);
    }
  }

  void cancelExistingSchedules() {
    resetCounter(null, value: 1);
    flutterLocalNotificationsPlugin.cancelAll();
    cancelAllTimers();
    getProfileInfoFromSharedPreferences().then(
          (profileInfo) => deleteAllFirebaseNotificationSchedule(userId: profileInfo.uid!),
    );
  }

  void startAlarm() async {
    if (!isAlarmActive) {
      isAlarmActive = true;
      await FlutterRingtonePlayer.playAlarm(looping: true);
    }
  }

  void stopAlarm() {
    if (isAlarmActive) {
      isAlarmActive = false;
      FlutterRingtonePlayer.stop();
    }
  }
}

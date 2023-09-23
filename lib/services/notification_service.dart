import 'dart:async';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:quickresponse/utils/extensions.dart';

import '../data/model/notification_schedule.dart';
import '../widgets/notifications.dart';
import 'firebase/firebase_notification_schedule.dart';
import 'firebase/firebase_profile.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final Map<int, Timer> _timers = {};
  int consecutiveAlarms = 1;
  bool isAlarmActive = false;

  void scheduleNotificationWithTimer({
    required DateTime selectedDateTime,
    required void Function(NotificationSchedule schedule, int count) onTimerCallback,
    String? title,
    String? body,
  }) {
    int intervalInSeconds = 10;
    int notificationIdPrefix = 100;

    // Calculate the total number of alarms required based on the selected time
    final int totalAlarms = (selectedDateTime.difference(DateTime.now()).inSeconds / intervalInSeconds).ceil();

    totalAlarms.log;
    cancelExistingSchedules();

    // Schedule the periodic alarms with unique notification IDs
    for (int i = 1; i <= totalAlarms; i++) {
      final int notificationId = notificationIdPrefix + i; // Unique notification ID
      final DateTime scheduledTime = DateTime.now().add(Duration(seconds: i * intervalInSeconds));

      // Check if it's the last alarm and set it to the exact selected time
      if (i == totalAlarms) {
        scheduleNotification(scheduledTime: selectedDateTime.copyWith(second: 00), notificationId: notificationId, title: title, body: body);
        getProfileInfoFromSharedPreferences().then(
          (profileInfo) => addFirebaseNotificationSchedule(
            userId: profileInfo.uid!,
            time: selectedDateTime.copyWith(second: 00).toString(),
            recipient: notificationId.toString(),
            title: title ?? '',
            message: body ?? '',
          ),
        );
        //onScheduleCallback(NotificationSchedule(time: selectedDateTime.copyWith(second: 00).toString(), recipient: notificationId.toString()));
      } else {
        scheduleNotification(scheduledTime: scheduledTime, notificationId: notificationId, title: title, body: body);
        getProfileInfoFromSharedPreferences().then(
          (profileInfo) => addFirebaseNotificationSchedule(
            userId: profileInfo.uid!,
            time: scheduledTime.toString(),
            recipient: notificationId.toString(),
            title: title ?? '',
            message: body ?? '',
          ),
        );
        //onScheduleCallback(NotificationSchedule(time: scheduledTime.toString(), recipient: notificationId.toString()));
      }

      // Start the alarm for this notification
      //startAlarm();

      // Schedule a timer for stopping the alarm and canceling this specific notification after 60 seconds
      final timer = Timer(Duration(seconds: (i * intervalInSeconds) + intervalInSeconds), () {
        // Stop the alarm for this notification
        stopAlarm();

        flutterLocalNotificationsPlugin.cancel(notificationId);
        if (i == totalAlarms) {
          getProfileInfoFromSharedPreferences().then(
            (profileInfo) => deleteFirebaseNotificationSchedule(userId: profileInfo.uid!, time: selectedDateTime.copyWith(second: 00).toString()),
          );
        } else {
          getProfileInfoFromSharedPreferences().then(
            (profileInfo) => deleteFirebaseNotificationSchedule(userId: profileInfo.uid!, time: scheduledTime.toString()),
          );
        }
        consecutiveAlarms++;

        if (consecutiveAlarms >= 3) {
          onTimerCallback(NotificationSchedule(recipient: notificationId.toString()), consecutiveAlarms);
          consecutiveAlarms.log;
        }
        // Remove the timer from the list
        _timers.remove(notificationId);
        consecutiveAlarms.log;
      });

      // Store the timer
      _timers[notificationId] = timer;
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

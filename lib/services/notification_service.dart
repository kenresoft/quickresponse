import 'dart:async';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:quickresponse/utils/extensions.dart';

import '../data/model/notification_schedule.dart';
import '../providers/settings/prefs.dart';
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

  int maxActiveAlarms = 100;
  int activeAlarmsCount = 0;

/*  Future<void> scheduleNotificationsWithBatch({
    required DateTime selectedDateTime,
    required void Function(NotificationSchedule schedule, int count) onTimerCallback,
    String? title,
    String? body,
  }) async {
    int intervalInSeconds = 10;
    int notificationIdPrefix = 100;
    int totalAlarms = (selectedDateTime.difference(DateTime.now()).inSeconds / intervalInSeconds).ceil();
    int batchSize = 10; // Set your batch size based on your requirements

    totalAlarms.log;
    cancelExistingSchedules((isReadyToSchedule) {});
await Future.delayed(Duration(seconds: 1));
    // Calculate the number of alarms in this batch
    int alarmsInThisBatch = totalAlarms - activeAlarmsCount;
    if (alarmsInThisBatch > maxActiveAlarms) {
      alarmsInThisBatch = maxActiveAlarms;
    }

    // Split total alarms into batches
    for (int i = activeAlarmsCount; i < activeAlarmsCount + alarmsInThisBatch; i += batchSize) {
      int endIndex = (i + batchSize < totalAlarms) ? i + batchSize : totalAlarms;

      // Schedule notifications in the current batch
      for (int j = i; j < endIndex; j++) {
        int notificationId = notificationIdPrefix + j + 1;
        DateTime scheduledTime = DateTime.now().add(Duration(seconds: j * intervalInSeconds));

        if (j == totalAlarms - 1) {
          scheduledTime = selectedDateTime.copyWith(second: 0);
          getProfileInfoFromSharedPreferences().then(
            (profileInfo) => addFirebaseNotificationSchedule(
              userId: profileInfo.uid!,
              time: selectedDateTime.copyWith(second: 0).toString(),
              recipient: notificationId.toString(),
              title: title ?? '',
              message: body ?? '',
            ),
          );
        }

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

        // Store the timer
        _timers[notificationId] = Timer(Duration(seconds: (j * intervalInSeconds) + intervalInSeconds), () {
          stopAlarm();
          flutterLocalNotificationsPlugin.cancel(notificationId);

          if (j == totalAlarms - 1) {
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
          }

          _timers.remove(notificationId);
        });
      }
    }

    // Update the active alarms count
    activeAlarmsCount += alarmsInThisBatch;
  }*/

  void scheduleNotificationBatch({
    required DateTime selectedDateTime,
    required void Function(NotificationSchedule schedule, int count) onTimerCallback,
    String? title,
    String? body,
  }) {
    int intervalInSeconds = 30 * 60;
    int notificationIdPrefix = 100;

    // Calculate the total number of alarms required based on the selected time
    final int totalAlarms = (selectedDateTime.difference(DateTime.now()).inSeconds / intervalInSeconds).ceil();

    totalAlarms.log;
    cancelExistingSchedules(
      (isReadyToSchedule) {},
    );

    // Schedule the periodic alarms with unique notification IDs
    for (int i = 1; i <= totalAlarms; i++) {
      final int notificationId = notificationIdPrefix + i; // Unique notification ID
      final DateTime scheduledTime = DateTime.now().add(Duration(seconds: i * intervalInSeconds));

      // Check if it's the last alarm and set it to the exact selected time
      if (i == totalAlarms) {
        scheduleNotification(scheduledTime: selectedDateTime.copyWith(second: 00), notificationId: notificationId, title: title, body: body);
        addFirebaseNotificationSchedule(
          userId: uid,
          time: selectedDateTime.copyWith(second: 00).toString(),
          recipient: notificationId.toString(),
          title: title ?? '',
          message: body ?? '',
        );
        //onScheduleCallback(NotificationSchedule(time: selectedDateTime.copyWith(second: 00).toString(), recipient: notificationId.toString()));
      } else {
        scheduleNotification(scheduledTime: scheduledTime, notificationId: notificationId, title: title, body: body);
        addFirebaseNotificationSchedule(
          userId: uid,
          time: scheduledTime.toString(),
          recipient: notificationId.toString(),
          title: title ?? '',
          message: body ?? '',
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
          deleteFirebaseNotificationSchedule(userId: uid, time: selectedDateTime.copyWith(second: 00).toString());
        } else {
          deleteFirebaseNotificationSchedule(userId: uid, time: scheduledTime.toString());
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

  Future<void> cancelExistingSchedules(Function(bool isReadyToSchedule) callback) async {
    resetCounter(null, value: 1);
    flutterLocalNotificationsPlugin.cancelAll();
    cancelAllTimers();
    deleteAllFirebaseNotificationSchedule(userId: uid).then((value) => callback(true));
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

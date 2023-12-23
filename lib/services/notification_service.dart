import 'package:quickresponse/main.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal() {
    _audioPlayer = AudioPlayer();
  }

  late final AudioPlayer _audioPlayer;
  final Map<int, Timer> _timers = {};
  int consecutiveAlarms = 1;
  bool isAlarmActive = false;

  int maxActiveAlarms = 100;
  int activeAlarmsCount = 0;

  void scheduleNotificationBatch({
    required DateTime selectedDateTime,
    required void Function() stateCallback,
    required void Function(NotificationSchedule schedule, int count) onTimerCallback,
    String? title,
    String? body,
  }) {
    int intervalInSeconds = travelAlarmInterval * 60; //30*60
    int notificationIdPrefix = 100;

    // Calculate the total number of alarms required based on the selected time
    final int totalAlarms = (selectedDateTime.difference(DateTime.now()).inSeconds.log / intervalInSeconds).ceil();

    cancelExistingSchedules((isReadyToSchedule) {});

    // Schedule the periodic alarms with unique notification IDs
    for (int i = 1; i <= totalAlarms; i++) {
      final int notificationId = notificationIdPrefix + i; // Unique notification ID
      final DateTime scheduledTime = DateTime.now().add(Duration(seconds: i * intervalInSeconds));

      scheduleNotification(scheduledTime: scheduledTime, notificationId: notificationId, title: title, body: body);
      addNotificationSchedule(
        userId: uid,
        time: scheduledTime.toString(),
        recipient: notificationId.toString(),
        title: title ?? '',
        message: body ?? '',
      );

      // Schedule a timer for stopping the alarm and canceling this specific notification after 60 seconds
      Timer(Duration(seconds: (i * intervalInSeconds) + intervalInSeconds), () => flutterLocalNotificationsPlugin.cancel(notificationId));

      final timer = Timer(Duration(seconds: (i * intervalInSeconds)), () {
        startAlarm();
        deleteNotificationScheduleById(userId: uid, recipient: notificationId.toString());
        if (i == totalAlarms) {
          Timer(Duration(seconds: intervalInSeconds), () => cancelExistingSchedules((isReadyToSchedule) {}));
        } else {
          deleteNotificationScheduleById(userId: uid, recipient: notificationId.toString());
        }
        stateCallback();
        consecutiveAlarms++;

        if (totalAlarms < 3) {
          onTimerCallback(NotificationSchedule(recipient: notificationId.toString()), consecutiveAlarms);
        } else if (consecutiveAlarms >= 3) {
          onTimerCallback(NotificationSchedule(recipient: notificationId.toString()), consecutiveAlarms);
        }
        // Remove the timer from the list
        _timers.remove(notificationId);

        ///consecutiveAlarms.log;
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
    stopAlarm();
  }

  Future<void> cancelExistingSchedules(Function(bool isReadyToSchedule) callback) async {
    resetCounter(null, value: 1);
    flutterLocalNotificationsPlugin.cancelAll();
    cancelAllTimers();
    deleteAllNotificationSchedules(userId: uid);
    callback(true);
  }

  void startAlarm() async {
    stopAlarm();
    if (!isAlarmActive) {
      isAlarmActive = true;
      await _audioPlayer.setAsset('assets/alarm.mp3');
      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.play();
    }
  }

  // Stop the alarm using just_audio
  void stopAlarm() async {
    if (isAlarmActive) {
      isAlarmActive = false;
      await _audioPlayer.stop();
    }
  }
}

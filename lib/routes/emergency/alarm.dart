import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/data/emergency/notification_response_model.dart';
import 'package:quickresponse/main.dart';
import 'package:quickresponse/utils/extensions.dart';

import '../../widgets/display/notifications.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  int alarmCount = 0;
  bool isAlarmActive = false;

  void startAlarm() async {
    if (!isAlarmActive) {
      isAlarmActive = true;
      _ringAlarm();

/*      // Schedule a notification
      final scheduledTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
      scheduleNotification(scheduledTime: scheduledTime, notificationId: 1);*/
    }
  }

  void cancelAlarm() {
    isAlarmActive = false;
    FlutterRingtonePlayer().stop();
    cancelNotification(notificationId: 1);
  }

  Future<void> _ringAlarm() async {
    if (isAlarmActive) {
      alarmCount++;
      FlutterRingtonePlayer().playAlarm(looping: true);
      await Future.delayed(
        const Duration(seconds: 5),
        () async {
          FlutterRingtonePlayer().stop();

          context.toast(alarmCount);
        },
      );
      await Future.delayed(const Duration(seconds: 10));

      if (alarmCount < 3) {
        _ringAlarm();
      } else {
        sendDoneMessage();
      }
    }
  }

  void sendDoneMessage() {
    // Implement your logic to send the "done" message.
    // This could be sending an SMS, a notification, or any other method.
    context.toast("DONE");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alarm App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => launch(context, Constants.travellersAlarm, NotificationResponseModel(isMuted: false)) /*startAlarm*/,
              child: const Text("Start Alarm"),
            ),
            ElevatedButton(
              onPressed: cancelAlarm,
              child: const Text("Cancel Alarm"),
            ),
          ],
        ),
      ),
    );
  }
}

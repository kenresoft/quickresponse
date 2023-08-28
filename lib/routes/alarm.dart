import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:quickresponse/utils/extensions.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  int alarmCount = 0;
  bool isAlarmActive = false;

  void startAlarm() {
    if (!isAlarmActive) {
      isAlarmActive = true;
      _ringAlarm();
    }
  }

  void cancelAlarm() {
    isAlarmActive = false;
    FlutterRingtonePlayer.stop();
  }

  Future<void> _ringAlarm() async {
    if (isAlarmActive) {
      alarmCount++;
      FlutterRingtonePlayer.playAlarm(looping: true);
      await Future.delayed(
        const Duration(seconds: 5),
        () async {
          FlutterRingtonePlayer.stop();

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
              onPressed: startAlarm,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  int alarmInterval = 10; // Interval in seconds
  int alarmCount = 0;
  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Alarm Count: $alarmCount',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (!isPaused) {
                  startAlarm();
                }
              },
              child: Text('Start Alarm'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isPaused = !isPaused;
                });
              },
              child: Text(isPaused ? 'Resume' : 'Pause'),
            ),
          ],
        ),
      ),
    );
  }

  void startAlarm() {
    FlutterRingtonePlayer.playAlarm(looping: true);

    Future.delayed(Duration(seconds: alarmInterval), () {
      if (!isPaused) {
        setState(() {
          alarmCount++;
        });

        if (alarmCount < 3) {
          startAlarm();
        } else {
          'Done'.log;
          FlutterRingtonePlayer.stop();
        }
      }
    });
  }

  @override
  void dispose() {
    FlutterRingtonePlayer.stop();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

import '../../data/constants/constants.dart';
import '../../data/emergency/notification_response_model.dart';
import '../../main.dart';
import '../../widgets/display/notifications.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Reminder'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          const Text('Select Date and Time for Reminder', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showTimePicker,
            child: const Text('Pick Date and Time', style: TextStyle(fontSize: 18)),
          ),
          ElevatedButton(
            onPressed: () => launch(context, Constants.travellersAlarm, NotificationResponseModel(isMuted: false)),
            child: const Text('Travellers Alarm', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 20),
          if (selectedDateTime != null) Text('Selected Date and Time: ${selectedDateTime.toString()}', style: const TextStyle(fontSize: 18)),
        ]),
      ),
    );
  }

  void _showTimePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((pickedTime) {
          if (pickedTime != null) {
            setState(() {
              selectedDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );

              if (selectedDateTime != null) {
                scheduleNotification(
                  title: 'Emergency Alert',
                  body: 'Click to mute Alarm',
                  scheduledTime: selectedDateTime!,
                  notificationId: 900,
                );
              }
            });
          }
        });
      }
    });
  }
}

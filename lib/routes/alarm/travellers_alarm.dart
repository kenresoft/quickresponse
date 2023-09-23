import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/services/firebase/firebase_sos.dart';
import 'package:quickresponse/utils/extensions.dart';

import '../../data/constants/colors.dart';
import '../../data/constants/constants.dart';
import '../../data/model/notification_schedule.dart';
import '../../main.dart';
import '../../providers/page_provider.dart';
import '../../services/firebase/firebase_location.dart';
import '../../services/firebase/firebase_notification_schedule.dart';
import '../../services/firebase/firebase_profile.dart';
import '../../services/notification_service.dart';
import '../../utils/density.dart';
import '../../utils/sos_group.dart';
import '../../widgets/appbar.dart';

final notificationService = NotificationService();
const String sosType = 'Travel';
const String sosRecipients = '08012345678';
const String sosMessage = 'Please Help! I have lost my way!';

class TravellersAlarm extends ConsumerStatefulWidget {
  const TravellersAlarm({super.key});

  //final NotificationResponseModel notificationResponse;

  @override
  ConsumerState<TravellersAlarm> createState() => _TravellersAlarmState();
}

class _TravellersAlarmState extends ConsumerState<TravellersAlarm> {
  DateTime? selectedDateTime;
  int consecutiveAlarms = 0;
  Stream<List<NotificationSchedule>>? st;

  @override
  void initState() {
    super.initState();
  }

  void sendSecuritySMS(BuildContext context, NotificationSchedule notificationSchedule, int count) {
    getLocationLogFromSharedPreferences().then(
      (location) => getProfileInfoFromSharedPreferences().then(
        (profileInfo) => addFirebaseSOSHistory(
          userId: profileInfo.uid!,
          type: sosType,
          recipient: sosRecipients,
          message: '${notificationSchedule.recipient} - $sosMessage',
          latitude: location.latitude.toString(),
          longitude: location.longitude.toString(),
        ).whenComplete(() => context.toast('SEND SMS - $count')),
      ),
    );
  }

  void _resetCounter() {
    notificationService.resetCounter((count) => context.toast('Count Reset to: $count'));
  }

  void _cancelAll() {
    notificationService.cancelExistingSchedules();
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

              final notificationService = NotificationService();
              if (selectedDateTime != null) {
                notificationService.scheduleNotificationWithTimer(
                  title: 'Emergency Alert',
                  body: 'Click to mute Alarm',
                  selectedDateTime: selectedDateTime!,
                  onTimerCallback: (schedule, count) => sendSecuritySMS(context, NotificationSchedule(), count),
                );
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    final page = ref.watch(pageProvider.select((value) => value));

    return WillPopScope(
      onWillPop: () async {
        bool isLastPage = page.isEmpty;
        if (isLastPage) {
          launch(context, Constants.home);
          return false;
          //return (await showAnimatedDialog(context))!;
        } else {
          launch(context, page.last);
          ref.watch(pageProvider.notifier).setPage = page..remove(page.last);
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: appBar(
          leading: Icon(CupertinoIcons.increase_quotelevel, color: AppColor.navIconSelected),
          title: const Text('Settings', style: TextStyle(fontSize: 20)),
          actionTitle: '',
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selectedDateTime == null ? 'Select Expected Travel Time' : 'Selected Time: ${selectedDateTime?.hour}:${selectedDateTime?.minute}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showTimePicker,
                  child: const Text('Select Time'),
                ),
                ElevatedButton(
                  onPressed: _resetCounter,
                  child: const Text('Reset Counter'),
                ),
                ElevatedButton(
                  onPressed: _cancelAll,
                  child: const Text('Cancel All Alarm'),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: FutureBuilder(
                      future: getProfileInfoFromSharedPreferences(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final profile = snapshot.data!;
                          return StreamBuilder<List<NotificationSchedule>>(
                            stream: getFirebaseNotificationSchedule(userId: profile.uid!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator(); // Show a loading indicator while data is loading
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final notificationScheduleList = snapshot.data!;

                                // Group SOS history items by date
                                final groupedNotificationSchedule = groupNotificationScheduleByDate(notificationScheduleList);

                                return ListView.builder(
                                  itemCount: groupedNotificationSchedule.length,
                                  itemBuilder: (context, index) {
                                    final group = groupedNotificationSchedule[index];

                                    // Display the date as a separator
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text(group.date.toString()),
                                          // You can customize the separator appearance here
                                          // For example, you can use a Divider or a different widget.
                                          // Here, I'm using a Container with a line separator.
                                          subtitle: Container(
                                            height: 1,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        ...group.items.map((notificationSchedule) {
                                          // Display individual SOS history items for the date
                                          return Card(
                                            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                                            color: AppColor.white,
                                            elevation: 0,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                title: Text(notificationSchedule.title ?? ''),
                                                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(notificationSchedule.message ?? ''),
                                                    const SizedBox(height: 3),
                                                    Text(notificationSchedule.time ?? ''),
                                                  ],
                                                ),
                                                trailing: const Icon(Icons.alarm),
                                                // Add more details as needed
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          );
                          ;
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

int minutesToSeconds(int minutes) {
  return minutes * 60;
}

int secondsToMinutes(int seconds) {
  return (seconds / 60).floor();
}

import 'package:quickresponse/main.dart';

final notificationService = NotificationService();
const String sosType = 'Travel';
const String sosRecipients = '08012345678';
const String sosMessage = 'Please Help! I have lost my way!';

class Emergency extends ConsumerStatefulWidget {
  const Emergency({super.key});

  @override
  ConsumerState<Emergency> createState() => _TravellersAlarmState();
}

class _TravellersAlarmState extends ConsumerState<Emergency> {
  DateTime? selectedDateTime;
  int consecutiveAlarms = 0;
  Stream<List<NotificationSchedule>>? st;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _pageTitles = ['Emergency', 'Travelling Alarms'];
  bool isReadyToSchedule = true;

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
    notificationService.cancelExistingSchedules((value) => isReadyToSchedule = value);
    setState(() {
      selectedDateTime = null;
      isReadyToSchedule = false;
    });
  }

  void _showTimePicker(PageController pageController) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            pickedTime.hour,
            pickedTime.minute,
          );

          final notificationService = NotificationService();
          if (selectedDateTime != null) {
            notificationService.scheduleNotificationBatch(
              title: 'Emergency Alert',
              body: 'Click to mute Alarm',
              selectedDateTime: selectedDateTime!,
              onTimerCallback: (schedule, count) => sendSecuritySMS(context, NotificationSchedule(), count),
            );
            isReadyToSchedule = false;
            pageController.animateToPage(1, duration: const Duration(seconds: 1), curve: Curves.decelerate);
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
        backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
        appBar: CustomAppBar(
          leading: Icon(CupertinoIcons.increase_quotelevel, color: AppColor(theme).navIconSelected),
          title: Text(_pageTitles[_currentPage], style: const TextStyle(fontSize: 20)),
          actionTitle: 'Theme',
          actionIcon: CupertinoIcons.lock_shield,
          onActionClick: () => setState(() {
            theme = !theme;
          }),
        ),
        body: Column(children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildFirstPage(theme, timeFormat, _pageController, context),
                _buildSecondPage(dateFormat, timeFormat),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              2,
              (pageIndex) {
                pageIndex.log;
                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: pageIndex == _currentPage
                        ? AppColor(theme).navIconSelected // Change this color to the desired color
                        : AppColor(theme).text, // Default color
                  ),
                );
              },
            ),
          ),
        ]),
        bottomNavigationBar: const BottomNavigator(currentIndex: 1),
      ),
    );
  }

  Padding _buildFirstPage(bool theme, TimeFormatOption selectedTimeFormat, PageController pageController, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
            color: AppColor(theme).white,
            elevation: 0,
            child: ListTile(
              title: const Text('Custom Messages'),
              subtitle: const Text('Set up custom emergency messages'),
              trailing: const Icon(CupertinoIcons.envelope_fill),
              onTap: () => launch(context, Constants.message),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
            color: AppColor(theme).white,
            elevation: 0,
            child: ListTile(
              title: const Text('Setup Travelling Alarm'),
              subtitle: Text(selectedDateTime == null
                      ? 'Select Expected Travel Time'
                      : 'Selected Time: ${formatTime(
                          ref,
                          selectedDateTime!,
                          selectedTimeFormat,
                        )}'
                  //'${selectedDateTime?.hour}:${selectedDateTime?.minute}',
                  ),
              trailing: const Icon(CupertinoIcons.bus),
              onTap: () => isReadyToSchedule
                  ? _showTimePicker(pageController)
                  : context.toast(
                      'Not ready to schedule yet!\nPlease wait...',
                      TextAlign.center,
                      AppColor(theme).alert_1,
                    ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
            color: AppColor(theme).white,
            elevation: 0,
            child: ListTile(
              title: const Text('Manage Travelling Alarm'),
              subtitle: const Text('Reset or Disable Alarm'),
              trailing: const Icon(CupertinoIcons.car_detailed),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
                      title: Text('Manage Travelling Alarm', style: TextStyle(color: AppColor(theme).title)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _resetCounter();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Reset Security Count'),
                        ),
                        TextButton(
                          onPressed: () {
                            _cancelAll();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel All Alarm'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
            color: AppColor(theme).white,
            elevation: 0,
            child: ListTile(
              title: const Text('Emergency Media'),
              subtitle: const Text('Record pictures/videos/audios'),
              trailing: const Icon(CupertinoIcons.film_fill),
              onTap: () => launch(context, Constants.camera),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
            color: AppColor(theme).white,
            elevation: 0,
            child: ListTile(
              title: const Text('View Media'),
              subtitle: const Text('View pictures/videos/audios'),
              trailing: const Icon(CupertinoIcons.photo_fill_on_rectangle_fill),
              onTap: () => launch(context, Constants.media),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
            color: AppColor(theme).white,
            elevation: 0,
            child: ListTile(
              title: const Text('View Chat'),
              subtitle: const Text('View chats'),
              trailing: const Icon(CupertinoIcons.photo_fill_on_rectangle_fill),
              onTap: () => launch(context, Constants.newChatsList, uid/* ('abc', uid, 'receiver')*/),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSecondPage(DateFormatOption selectedDateFormat, TimeFormatOption selectedTimeFormat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder<ProfileInfo>(
        future: getProfileInfoFromSharedPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(); // Loading indicator while data is loading
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final profile = snapshot.data!;
            profile.displayName.log;
            return StreamBuilder<List<NotificationSchedule>>(
              stream: getFirebaseNotificationSchedule(userId: profile.uid!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // Show a loading indicator while data is loading
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final notificationScheduleList = snapshot.data!;

                  if (notificationScheduleList.isEmpty) {
                    return const Center(
                      child: Text('No travelling alarm scheduled!', style: TextStyle(fontSize: 21)),
                    );
                  }

                  // Group SOS history items by time
                  final groupedNotificationSchedule = groupNotificationScheduleByTime(notificationScheduleList);

                  return ListView.builder(
                    itemCount: groupedNotificationSchedule.length,
                    itemBuilder: (context, index) {
                      final group = groupedNotificationSchedule[index];

                      // Display the time as a separator
                      return Column(
                        children: [
                          ListTile(
                            title: Text('Time: ${formatTime(
                              ref,
                              DateFormat.Hm().parseStrict(group.time),
                              selectedTimeFormat,
                            )}'),
                            // You can customize the separator appearance here
                            // For example, you can use a Divider or a different widget.
                            // Here, I'm using a Container with a line separator.
                            subtitle: Container(
                              height: 1,
                              color: Colors.blue,
                            ),
                          ),
                          ...group.items.map((notificationSchedule) {
                            // Display individual SOS history items for the time
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                              color: AppColor(theme).white,
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(notificationSchedule.title ?? ''),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(notificationSchedule.message ?? ''),
                                      const SizedBox(height: 3),
                                      Text('Date & Time: ${formatDate(ref, DateTime.parse(notificationSchedule.time!), selectedDateFormat)} ${formatTime(
                                        ref,
                                        DateTime.parse(notificationSchedule.time!),
                                        selectedTimeFormat,
                                      )}'),
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
          } else {
            return const Text('No data available'); // Handle the case where data is null
          }
        },
      ),
    );
  }
}

// Define a helper function to group by time
List<GroupedNotificationSchedule> groupNotificationScheduleByTime(List<NotificationSchedule> scheduleList) {
  final groupedMap = <String, List<NotificationSchedule>>{};

  for (final schedule in scheduleList) {
    final timeKey = formatTimeKey(DateTime.parse(schedule.time!)); // Format time as key
    groupedMap.putIfAbsent(timeKey, () => []).add(schedule);
  }

  return groupedMap.entries.map((entry) => GroupedNotificationSchedule(time: entry.key, items: entry.value)).toList();
}

// Define a helper function to format time as a key (e.g., "HH:mm")
String formatTimeKey(DateTime dateTime) {
  return DateFormat.Hm().format(dateTime);
}

// Define a data class to hold grouped items
class GroupedNotificationSchedule {
  final String time;
  final List<NotificationSchedule> items;

  GroupedNotificationSchedule({required this.time, required this.items});
}

int minutesToSeconds(int minutes) {
  return minutes * 60;
}

int secondsToMinutes(int seconds) {
  return (seconds / 60).floor();
}

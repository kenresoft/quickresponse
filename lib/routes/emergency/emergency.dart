import 'package:quickresponse/main.dart';

final notificationService = NotificationService();
const String sosType = 'Travel';
const String sosRecipients = '08012345678';
/*const String sosMessage = 'Please Help! I have lost my way!';*/

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

//H: EDIT HERE>>>
  void sendSecuritySMS(NotificationSchedule notificationSchedule, int count) {
    handleSOS('travel_alarm', count);
    context.toast('Alert Delivered successfully!\nMESSAGE: "$sosMessage" - $count', TextAlign.center, Colors.green.shade300);
  }

  void _resetCounter() {
    notificationService.resetCounter((count) => context.toast('Count Reset to: $count', TextAlign.center, Colors.green.shade300, Colors.white));
  }

  void _cancelAll() {
    notificationService.cancelExistingSchedules((value) => isReadyToSchedule = value);
    setState(() {
      selectedDateTime = null;
      //isReadyToSchedule = true;
    });
  }

  void _showTimePicker(BuildContext context, PageController pageController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int hours = 0;
        int minutes = 0;
        int seconds = 0;

        return AlertDialog(
          backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
          title: Text('Set Duration', style: TextStyle(color: AppColor(theme).title)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) => hours = int.tryParse(value) ?? 0,
                    decoration: const InputDecoration(labelText: 'Hours'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) => minutes = int.tryParse(value) ?? 0,
                    decoration: const InputDecoration(labelText: 'Minutes'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) => seconds = int.tryParse(value) ?? 0,
                    decoration: const InputDecoration(labelText: 'Seconds'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                int totalSeconds = hours * 3600 + minutes * 60 + seconds;
                if (totalSeconds > 0) {
                  setState(() {
                    selectedDateTime = DateTime.now().add(Duration(seconds: totalSeconds));

                    final notificationService = NotificationService();
                    if (selectedDateTime != null) {
                      notificationService.scheduleNotificationBatch(
                        title: 'Emergency Alert',
                        body: 'Click to mute Alarm',
                        selectedDateTime: selectedDateTime!,
                        stateCallback: () {
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        onTimerCallback: (schedule, count) {
                          log('message');
                          sendSecuritySMS(NotificationSchedule(), count);
                        },
                      );
                      isReadyToSchedule = false;
                      pageController.animateToPage(1, duration: const Duration(seconds: 1), curve: Curves.decelerate);
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Set Duration'),
            ),
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);

    return WillPopScope(
      onWillPop: () async {
        launch(context, Constants.home);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
        appBar: CustomAppBar(
          leading: const LogoCard(),
          title: Text(_pageTitles[_currentPage], style: const TextStyle(fontSize: 20)),
          actionTitle: 'Set Interval',
          onActionClick: () => launch(context, Constants.settings, SettingType.travelAlarmInterval),
        ),
        body: Center(
          child: Column(children: [
            RealTimeWidget(selectedTimeFormat: TimeFormatOption.format12Hours, selectedTimeSeparator: timeSeparator, style: TextStyle(fontSize: 15, color: AppColor(theme).text)),
            0.02.dpH(dp).spY,
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
                  ///pageIndex.log;
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
        ),
        bottomNavigationBar: bottomNavigator(context, 1),
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
              subtitle: Text(selectedDateTime == null ? 'Select Expected Travel Time' : 'Selected Time: ${formatTime(selectedDateTime!, selectedTimeFormat)}'
                  //'${selectedDateTime?.hour}:${selectedDateTime?.minute}',
                  ),
              trailing: const Icon(CupertinoIcons.bus),
              onTap: () => isReadyToSchedule
                  ? _showTimePicker(context, pageController)
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
              title: const Text('Settings'),
              subtitle: const Text('View App Settings'),
              trailing: const Icon(CupertinoIcons.settings),
              onTap: () => launch(context, Constants.settings),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSecondPage(DateFormatOption selectedDateFormat, TimeFormatOption selectedTimeFormat) {
    final notificationScheduleList = getNotificationSchedules(userId: uid);

    if (notificationScheduleList.isEmpty) {
      return const Center(
        child: Text('No travelling alarm scheduled!', style: TextStyle(fontSize: 21)),
      );
    }

    // Group SOS history items by time
    final groupedNotificationSchedule = groupNotificationScheduleByTime(notificationScheduleList);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: groupedNotificationSchedule.length,
        itemBuilder: (context, index) {
          final group = groupedNotificationSchedule[index];

          // Display the time as a separator
          return Column(
            children: [
              ListTile(
                title: Text('Time: ${formatTime(DateFormat.Hm().parseStrict(group.time), selectedTimeFormat)}'),
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
                          Text('Date & Time: ${formatDate(DateTime.parse(notificationSchedule.time!), selectedDateFormat)} ${formatTime(DateTime.parse(notificationSchedule.time!), selectedTimeFormat)}'),
                        ],
                      ),
                      trailing: const Icon(Icons.alarm),
                      // Add more details as needed
                    ),
                  ),
                );
              }),
            ],
          );
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

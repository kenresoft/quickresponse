import '../../main.dart';

enum TextFieldDirection { horizontal, vertical }

enum SettingType { locationUpdate, travelAlarmInterval, none }

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage(this.callback, {this.settingType, super.key});

  final SettingType? settingType;
  final VoidCallback callback;

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.settingType == SettingType.none || widget.settingType == SettingType.locationUpdate) {
          launch(context, Constants.home);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
        appBar: const CustomAppBar(
          leading: LogoCard(),
          title: Text('Settings', style: TextStyle(fontSize: 20)),
          actionTitle: '',
          /*actionIcon: Icon(theme ? CupertinoIcons.sun_max_fill : CupertinoIcons.sun_max, color: AppColor(theme).navIconSelected),
          onActionClick: () {
            setState(() => theme = !theme);
            widget.callback();
          },*/
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor(theme).white,
                  elevation: 0,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      textColor: AppColor(theme).text,
                      title: const Text('Require Authentication on App Startup'),
                      trailing: Icon(authenticate ? CupertinoIcons.lock : CupertinoIcons.lock_slash, color: AppColor(theme).navIconSelected),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
                          child: Text(authenticationDescription, style: TextStyle(color: AppColor(theme).title)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CupertinoSwitch(
                            activeColor: AppColor(theme).navIconSelected,
                            value: authenticate,
                            onChanged: (value) => setState(() => authenticate = value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor(theme).white,
                  elevation: 0,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: widget.settingType == SettingType.locationUpdate ? true : false,
                      textColor: AppColor(theme).text,
                      title: const Text('Location Updates'),
                      trailing: Icon(stopLocationUpdate ? CupertinoIcons.location : CupertinoIcons.location_slash, color: AppColor(theme).navIconSelected),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
                          child: Text('Either enable or Disable real-time location updates. \nRequires location service permission.', style: TextStyle(color: AppColor(theme).title)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CupertinoSwitch(
                            activeColor: AppColor(theme).navIconSelected,
                            value: stopLocationUpdate,
                            onChanged: (value) {
                              setState(() => stopLocationUpdate = value);
                              if (stopLocationUpdate) {
                                LocationService.stopLocationUpdates();
                              } /*else {
                                _checkLocationPermission();
                              }*/
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor(theme).white,
                  elevation: 0,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      textColor: AppColor(theme).text,
                      title: const Text('Location Refresh Interval'),
                      trailing: Icon(CupertinoIcons.refresh_thin, color: AppColor(theme).navIconSelected),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
                          child: Text(locationIntervalDescription, style: TextStyle(color: AppColor(theme).title)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: RefreshIntervalToggleButtons(
                            suffix: 's',
                            selectedInterval: locationInterval,
                            onIntervalSelected: (p0) => setState(() => locationInterval = p0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor(theme).white,
                  elevation: 0,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      textColor: AppColor(theme).text,
                      title: const Text('Maximum Allowed Custom Messages'),
                      trailing: Icon(CupertinoIcons.envelope, color: AppColor(theme).navIconSelected),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
                          child: Text(customSOSMessageDescription, style: TextStyle(color: AppColor(theme).title)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: RefreshIntervalToggleButtons(
                            intervalList: const [3, 5, 10],
                            selectedInterval: maxMessageAllowed,
                            onIntervalSelected: (p0) => setState(() => maxMessageAllowed = p0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor(theme).white,
                  elevation: 0,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      textColor: AppColor(theme).text,
                      title: const Text('Items Per Page (History)'),
                      trailing: Icon(CupertinoIcons.list_number, color: AppColor(theme).navIconSelected),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
                          child: Text(itemsPerPageDescription, style: TextStyle(color: AppColor(theme).title)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: RefreshIntervalToggleButtons(
                            intervalList: const [5, 10, 15, 20],
                            selectedInterval: itemsPerPage,
                            onIntervalSelected: (p0) => setState(() => itemsPerPage = p0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor(theme).white,
                  elevation: 0,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      textColor: AppColor(theme).text,
                      title: const Text('Video Record Length'),
                      trailing: Icon(CupertinoIcons.memories_badge_minus, color: AppColor(theme).navIconSelected),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
                          child: Text(videoRecordingLengthDescription, style: TextStyle(color: AppColor(theme).title)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: RefreshIntervalToggleButtons(
                            intervalList: const [10, 20, 30, 45, 60, 120],
                            suffix: 's',
                            selectedInterval: videoRecordLength,
                            onIntervalSelected: (p0) => setState(() => videoRecordLength = p0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor(theme).white,
                  elevation: 0,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: widget.settingType == SettingType.travelAlarmInterval ? true : false,
                      textColor: AppColor(theme).text,
                      title: const Text('Travel Alarm Interval'),
                      trailing: Icon(CupertinoIcons.car_detailed, color: AppColor(theme).navIconSelected),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
                          child: Text(sosAlarmIntervalDescription, style: TextStyle(color: AppColor(theme).title)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: RefreshIntervalToggleButtons(
                            intervalList: const [1, 5, 10, 20, 30, 45, 60, 120],
                            suffix: 'min',
                            selectedInterval: travelAlarmInterval,
                            onIntervalSelected: (p0) => setState(() => travelAlarmInterval = p0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                /*Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor(theme).white,
                  elevation: 0,
                  child: ListTile(
                    title: const Text('Custom Messages'),
                    subtitle: const Text('Set up custom emergency messages'),
                    trailing: const Icon(CupertinoIcons.lock_shield),
                    onTap: () => launch(context, '/cgs'),
                  ),
                ),*/
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor(theme).white,
                  elevation: 0,
                  child: ListTile(
                    title: const Text('Text Field Direction'),
                    trailing: CustomDropdown<TextFieldDirection>(
                      value: textFieldDirection,
                      onChanged: (newValue) => setState(() => textFieldDirection = newValue!),
                      items: [
                        DropdownMenuItem(
                          value: TextFieldDirection.horizontal,
                          child: Text('Horizontal', style: TextStyle(color: AppColor(theme).title)),
                        ),
                        DropdownMenuItem(
                          value: TextFieldDirection.vertical,
                          child: Text('Vertical', style: TextStyle(color: AppColor(theme).title)),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor(theme).white,
                  elevation: 0,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      textColor: AppColor(theme).text,
                      subtitle: const Text('Date & Time Settings'),
                      title: const Text('Date & Time Settings'), // Title for the ExpansionTile
                      children: [
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                          color: AppColor(theme).white,
                          elevation: 0,
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text('Date Format'),
                                leading: Icon(Icons.calendar_month_outlined, color: AppColor(theme).navIconSelected),
                                trailing: CustomDropdown<DateFormatOption>(
                                  width: 160,
                                  value: dateFormat,
                                  onChanged: (newValue) => setState(() => dateFormat = newValue!),
                                  items: [
                                    _buildDateFormatDropdownItem(
                                      DateFormatOption.format1,
                                      'month${dateSeparator}date${dateSeparator}year',
                                      DateFormat('MM${dateSeparator}dd${dateSeparator}yyyy').format(DateTime.now()),
                                      theme,
                                    ),
                                    _buildDateFormatDropdownItem(
                                      DateFormatOption.format2,
                                      'date${dateSeparator}month${dateSeparator}year',
                                      DateFormat('dd${dateSeparator}MMM${dateSeparator}yyyy').format(DateTime.now()),
                                      theme,
                                    ),
                                    _buildDateFormatDropdownItem(
                                      DateFormatOption.format3,
                                      'year${dateSeparator}month${dateSeparator}date',
                                      DateFormat('yyyy${dateSeparator}MM${dateSeparator}dd').format(DateTime.now()),
                                      theme,
                                    ),
                                    _buildDateFormatDropdownItem(
                                      DateFormatOption.format4,
                                      'day, month${dateSeparator}date${dateSeparator}year',
                                      DateFormat('EEE, M${dateSeparator}d${dateSeparator}y').format(DateTime.now()),
                                      theme,
                                    ),
                                    _buildDateFormatDropdownItem(
                                      DateFormatOption.format5,
                                      'day, month${dateSeparator}date${dateSeparator}year',
                                      DateFormat('EEEE, M${dateSeparator}d${dateSeparator}y').format(DateTime.now()),
                                      theme,
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: const Text('Date Separator'),
                                leading: Icon(Icons.date_range_outlined, color: AppColor(theme).navIconSelected),
                                trailing: CustomDropdown<String>(
                                  value: dateSeparator,
                                  onChanged: (newValue) => setState(() => dateSeparator = newValue!),
                                  items: [
                                    DropdownMenuItem(
                                      value: '/',
                                      child: Text('/ (Slash)', style: TextStyle(color: AppColor(theme).title)),
                                    ),
                                    DropdownMenuItem(
                                      value: '.',
                                      child: Text('. (Period)', style: TextStyle(color: AppColor(theme).title)),
                                    ),
                                    DropdownMenuItem(
                                      value: '-',
                                      child: Text('- (Hyphen)', style: TextStyle(color: AppColor(theme).title)),
                                    ),
                                    DropdownMenuItem(
                                      value: ', ',
                                      child: Text(', (Colon)', style: TextStyle(color: AppColor(theme).title)),
                                    ),
                                    DropdownMenuItem(
                                      value: ' ',
                                      child: Text(' (None)', style: TextStyle(color: AppColor(theme).title)),
                                    ),
                                    // Add more separator options as needed
                                  ],
                                ),
                              ),
                              ListTile(
                                title: const Text('Time Format'),
                                leading: Icon(Icons.access_time_outlined, color: AppColor(theme).navIconSelected),
                                trailing: Column(
                                  children: [
                                    CustomDropdown<TimeFormatOption>(
                                      width: 160,
                                      value: timeFormat,
                                      onChanged: (newValue) => setState(() => timeFormat = newValue!),
                                      items: [
                                        _buildTimeFormatDropdownItem(
                                          TimeFormatOption.format12Hours,
                                          '12-Hour (hour${timeSeparator}min)',
                                          timeSeparator,
                                          theme,
                                        ),
                                        _buildTimeFormatDropdownItem(
                                          TimeFormatOption.format24Hours,
                                          '24-Hour (hour${timeSeparator}min)',
                                          timeSeparator,
                                          theme,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: const Text('Time Separator'),
                                leading: Icon(Icons.timelapse_outlined, color: AppColor(theme).navIconSelected),
                                trailing: CustomDropdown<String>(
                                  value: timeSeparator,
                                  onChanged: (newValue) => setState(() => timeSeparator = newValue!),
                                  items: [
                                    DropdownMenuItem(
                                      value: ':',
                                      child: Text(': (Colon)', style: TextStyle(color: AppColor(theme).title)),
                                    ),
                                    DropdownMenuItem(
                                      value: '.',
                                      child: Text('. (Period)', style: TextStyle(color: AppColor(theme).title)),
                                    ),
                                    DropdownMenuItem(
                                      value: '-',
                                      child: Text('- (Hyphen)', style: TextStyle(color: AppColor(theme).title)),
                                    ),
                                    // Add more separator options as needed
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: bottomNavigator(context, 4),
      ),
    );
  }

  String get locationIntervalDescription => 'The Location Refresh Interval setting allows you to customize how frequently the'
      ' app updates your current location. Adjusting this interval impacts the '
      'accuracy of location-based features and services within the app. Choose a '
      'shorter interval for real-time tracking and precise location updates, '
      'or opt for a longer interval to conserve battery life and reduce data usage.';

  String get authenticationDescription => 'Enable this option to require user authentication each time the app is launched. '
      'When enabled, users will need to authenticate using biometrics or a PIN before '
      'gaining access to the app\'s features and content. This adds an extra layer of '
      'security to protect your data and privacy.';

  String get customSOSMessageDescription => 'The Maximum Items of Allowed Custom SOS Message setting enables you to define '
      'the number of personalized SOS messages you can create within the app.';

  String get itemsPerPageDescription => 'The Items Per Page setting allows you to control the number of SOS events displayed '
      'on a single page in the SOS History section.';

  String get videoRecordingLengthDescription => 'The Video Recording Length setting allows you to specify the duration of recorded videos. '
      'Adjust this setting to determine how long each video recording will be. '
      'Ensure to balance video length with available storage space on '
      'your device to manage storage efficiently.';

  String get sosAlarmIntervalDescription => 'The Traveler\'s SOS Alarm Interval setting empowers you to define how frequently '
      'the app checks your safety status when you are on a journey. By customizing '
      'this interval, you can ensure that your safety is regularly monitored and '
      'assistance can be promptly dispatched in case of an emergency. This provides an added layer of '
      'security and peace of mind, especially when exploring unfamiliar destinations.';

  // Helper method to build a DropdownMenuItem with description and sample
  DropdownMenuItem<DateFormatOption> _buildDateFormatDropdownItem(
    DateFormatOption option,
    String description,
    String sample,
    bool theme,
  ) {
    return DropdownMenuItem(
      value: option,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(description, style: TextStyle(fontSize: 14, color: AppColor(theme).title)),
        Text('Current Date: $sample', style: TextStyle(fontSize: 12, color: AppColor(theme).text)),
      ]),
    );
  }

  DropdownMenuItem<TimeFormatOption> _buildTimeFormatDropdownItem(
    TimeFormatOption option,
    String description,
    String sampleSeparator,
    bool theme,
  ) {
    return DropdownMenuItem(
      value: option,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(description, style: TextStyle(fontSize: 14, color: AppColor(theme).title)),
        RealTimeWidget(selectedTimeFormat: option, selectedTimeSeparator: sampleSeparator, style: TextStyle(fontSize: 12, color: AppColor(theme).text)),
      ]),
    );
  }
}

class RefreshIntervalToggleButtons extends StatefulWidget {
  final Function(int) onIntervalSelected;
  final int selectedInterval;
  final List<int>? intervalList;

  final String? suffix;

  const RefreshIntervalToggleButtons({super.key, required this.onIntervalSelected, required this.selectedInterval, this.intervalList, this.suffix});

  @override
  State<RefreshIntervalToggleButtons> createState() => _RefreshIntervalToggleButtonsState();
}

class _RefreshIntervalToggleButtonsState extends State<RefreshIntervalToggleButtons> {
  List<int> intervals = [3, 5, 10, 15, 20, 30, 60, 120];

  @override
  void initState() {
    super.initState();
    intervals = widget.intervalList ?? intervals;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ToggleButtons(
          isSelected: List.generate(intervals.length, (index) => intervals[index] == widget.selectedInterval),
          onPressed: (int index) {
            setState(() {
              widget.onIntervalSelected(intervals[index]);
            });
          },
          borderRadius: BorderRadius.circular(12),
          selectedColor: AppColor(theme).white,
          color: AppColor(theme).alert_1,
          fillColor: AppColor(theme).alert_1,
          borderWidth: 1,
          borderColor: AppColor(theme).alert_1,
          selectedBorderColor: AppColor(theme).alert_1,
          children: intervals.map((interval) => Text(widget.suffix != null ? '$interval ${widget.suffix}' : '$interval')).toList(),
        ),
      ),
    );
  }
}

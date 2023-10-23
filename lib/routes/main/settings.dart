import '../../main.dart';

enum TextFieldDirection { horizontal, vertical }

enum SettingType { locationUpdate, none }

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({this.settingType, super.key});

  final SettingType? settingType;

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    final page = ref.watch(pageProvider.select((value) => value));
    final textFieldDirection = ref.watch(textFieldDirectionProvider.select((value) => value));
    final ExpansionTileController expansionTileController = ExpansionTileController();
    //SharedPreferencesService.remove('dateFormat');
    //SharedPreferencesService.remove('dateSeparator');
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
          title: const Text('Settings', style: TextStyle(fontSize: 20)),
          actionTitle: '',
          actionIcon: Icon(theme ? CupertinoIcons.sun_max_fill : CupertinoIcons.sun_max, color: AppColor(theme).navIconSelected),
          onActionClick: () => setState(() => theme = !theme),
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
                      //controller: expansionTileController,
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
                          child: Text(locationIntervalDescription, style: TextStyle(color: AppColor(theme).title)),
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
                          child: Text(locationIntervalDescription, style: TextStyle(color: AppColor(theme).title)),
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
                  child: ListTile(
                    title: const Text('Custom Messages'),
                    subtitle: const Text('Set up custom emergency messages'),
                    trailing: const Icon(CupertinoIcons.lock_shield),
                    onTap: () => launch(context, '/cgs'),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor(theme).white,
                  elevation: 0,
                  child: ListTile(
                    title: const Text('Text Field Direction'),
                    trailing: CustomDropdown<TextFieldDirection>(
                      value: textFieldDirection,
                      onChanged: (newValue) {
                        ref.watch(textFieldDirectionProvider.notifier).setTextFieldDirection = newValue!;
                      },
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
        bottomNavigationBar: const BottomNavigator(currentIndex: 4),
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

  // Helper method to build a DropdownMenuItem with description and sample
  DropdownMenuItem<DateFormatOption> _buildDateFormatDropdownItem(
    DateFormatOption option,
    String description,
    String sample,
    bool theme,
  ) {
    return DropdownMenuItem(
      value: option,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description, style: TextStyle(fontSize: 14, color: AppColor(theme).title)),
          Text('Current Date: $sample', style: TextStyle(fontSize: 12, color: AppColor(theme).text)),
        ],
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description, style: TextStyle(fontSize: 14, color: AppColor(theme).title)),
          RealTimeTimeWidget(selectedTimeFormat: option, selectedTimeSeparator: sampleSeparator, style: TextStyle(fontSize: 12, color: AppColor(theme).text)),
        ],
      ),
    );
  }

  // Helper method to get the description for the selected date format
  String _getDateFormatDescription(DateFormatOption format) {
    switch (format) {
      case DateFormatOption.format1:
        return 'Month/Day/Year (MM/dd/yyyy)';
      case DateFormatOption.format2:
        return 'Day-Month-Year (dd-MMM-yyyy)';
      case DateFormatOption.format3:
        return 'Year-Month-Day (yyyy-MM-dd)';
      default:
        return '';
    }
  }

  // Helper method to get the sample time based on the selected time format and separator
  String _getSampleTime(TimeFormatOption format, String separator) {
    final currentTime = DateTime.now();
    switch (format) {
      case TimeFormatOption.format12Hours:
        return DateFormat('hh${separator}mm a').format(currentTime);
      case TimeFormatOption.format24Hours:
        return DateFormat('HH${separator}mm').format(currentTime);
      default:
        return '';
    }
  }
}

class RefreshIntervalToggleButtons extends StatefulWidget {
  final Function(int) onIntervalSelected;
  final int selectedInterval;
  final List<int>? intervalList;

  const RefreshIntervalToggleButtons({super.key, required this.onIntervalSelected, required this.selectedInterval, this.intervalList});

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
          children: intervals.map((interval) => Text(widget.intervalList != null ? '$interval' : '$interval s')).toList(),
        ),
      ),
    );
  }
}

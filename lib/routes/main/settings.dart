import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/constants/colors.dart';
import '../../data/constants/constants.dart';
import '../../main.dart';
import '../../providers/page_provider.dart';
import '../../providers/settings/date_format.dart';
import '../../providers/settings/text_field_provider.dart';
import '../../utils/density.dart';
import '../../widgets/appbar.dart';
import '../../widgets/bottom_navigator.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/time_update_widget.dart';

enum TextFieldDirection { horizontal, vertical }

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dp = Density.init(context);
    final page = ref.watch(pageProvider.select((value) => value));
    final textFieldDirection = ref.watch(textFieldDirectionProvider.select((value) => value));
    final selectedDateFormat = ref.watch(dateFormatProvider.select((value) => value));
    final selectedTimeFormat = ref.watch(timeFormatProvider.select((value) => value));
    final selectedDateSeparator = ref.watch(dateSeparatorProvider.select((value) => value));
    final selectedTimeSeparator = ref.watch(timeSeparatorProvider.select((value) => value));

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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor.white,
                  elevation: 0,
                  child: ListTile(
                    title: const Text('Custom Messages'),
                    subtitle: const Text('Set up custom emergency messages'),
                    trailing: const Icon(CupertinoIcons.lock_shield),
                    onTap: () => launch(context, Constants.message),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor.white,
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
                          child: Text('Horizontal', style: TextStyle(color: AppColor.title)),
                        ),
                        DropdownMenuItem(
                          value: TextFieldDirection.vertical,
                          child: Text('Vertical', style: TextStyle(color: AppColor.title)),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                  color: AppColor.white,
                  elevation: 0,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      textColor: AppColor.text,
                      subtitle: const Text('Date & Time Settings'),
                      title: const Text('Date & Time Settings'), // Title for the ExpansionTile
                      children: [
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                          color: AppColor.white,
                          elevation: 0,
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text('Date Format'),
                                leading: Icon(Icons.calendar_month, color: AppColor.navIconSelected),
                                trailing: CustomDropdown<DateFormatOption>(
                                  value: selectedDateFormat,
                                  onChanged: (newValue) {
                                    ref.watch(dateFormatProvider.notifier).setDateFormatOption = newValue!;
                                  },
                                  items: [
                                    _buildDateFormatDropdownItem(
                                      DateFormatOption.format1,
                                      'MM${selectedDateSeparator}dd${selectedDateSeparator}yyyy',
                                      DateFormat('MM${selectedDateSeparator}dd${selectedDateSeparator}yyyy').format(DateTime.now()),
                                    ),
                                    _buildDateFormatDropdownItem(
                                      DateFormatOption.format2,
                                      'dd${selectedDateSeparator}MMM${selectedDateSeparator}yyyy',
                                      DateFormat('dd${selectedDateSeparator}MMM${selectedDateSeparator}yyyy').format(DateTime.now()),
                                    ),
                                    _buildDateFormatDropdownItem(
                                      DateFormatOption.format3,
                                      'yyyy${selectedDateSeparator}MM${selectedDateSeparator}dd',
                                      DateFormat('yyyy${selectedDateSeparator}MM${selectedDateSeparator}dd').format(DateTime.now()),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: const Text('Date Separator'),
                                leading: Icon(Icons.date_range, color: AppColor.navIconSelected),
                                trailing: CustomDropdown<String>(
                                  value: selectedDateSeparator,
                                  onChanged: (newValue) {
                                    ref.watch(dateSeparatorProvider.notifier).setDateSeparator = newValue!;
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      value: '/',
                                      child: Text('/ (Slash)', style: TextStyle(color: AppColor.title)),
                                    ),
                                    DropdownMenuItem(
                                      value: '-',
                                      child: Text('- (Hyphen)', style: TextStyle(color: AppColor.title)),
                                    ),
                                    DropdownMenuItem(
                                      value: '.',
                                      child: Text('. (Period)', style: TextStyle(color: AppColor.title)),
                                    ),
                                    // Add more separator options as needed
                                  ],
                                ),
                              ),
                              ListTile(
                                title: const Text('Time Format'),
                                leading: Icon(Icons.access_time, color: AppColor.navIconSelected),
                                trailing: Column(
                                  children: [
                                    CustomDropdown<TimeFormatOption>(
                                      width: 140,
                                      value: selectedTimeFormat,
                                      onChanged: (newValue) {
                                        ref.watch(timeFormatProvider.notifier).setTimeFormatOption = newValue!;
                                      },
                                      items: [
                                        _buildTimeFormatDropdownItem(
                                          TimeFormatOption.format12Hours,
                                          '12-Hour (hh${selectedTimeSeparator}mm)',
                                          selectedTimeSeparator, // Use selected separator here
                                        ),
                                        _buildTimeFormatDropdownItem(
                                          TimeFormatOption.format24Hours,
                                          '24-Hour (HH${selectedTimeSeparator}mm)',
                                          selectedTimeSeparator, // Use selected separator here
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: const Text('Time Separator'),
                                leading: Icon(Icons.timelapse, color: AppColor.navIconSelected),
                                trailing: CustomDropdown<String>(
                                  value: selectedTimeSeparator,
                                  onChanged: (newValue) {
                                    ref.watch(timeSeparatorProvider.notifier).setTimeSeparator = newValue!;
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      value: ':',
                                      child: Text(': (Colon)', style: TextStyle(color: AppColor.title)),
                                    ),
                                    DropdownMenuItem(
                                      value: '.',
                                      child: Text('. (Period)', style: TextStyle(color: AppColor.title)),
                                    ),
                                    DropdownMenuItem(
                                      value: '-',
                                      child: Text('- (Hyphen)', style: TextStyle(color: AppColor.title)),
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

  // Helper method to build a DropdownMenuItem with description and sample
  DropdownMenuItem<DateFormatOption> _buildDateFormatDropdownItem(
    DateFormatOption option,
    String description,
    String sample,
  ) {
    return DropdownMenuItem(
      value: option,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description, style: TextStyle(fontSize: 14, color: AppColor.title)),
          Text('Current Date: $sample', style: TextStyle(fontSize: 12, color: AppColor.text)),
        ],
      ),
    );
  }

  DropdownMenuItem<TimeFormatOption> _buildTimeFormatDropdownItem(
    TimeFormatOption option,
    String description,
    String sampleSeparator,
    //TimeFormatOption selectedTimeFormat,
  ) {
    return DropdownMenuItem(
      value: option,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description, style: TextStyle(fontSize: 14, color: AppColor.title)),
          RealTimeTimeWidget(selectedTimeFormat: option, selectedTimeSeparator: sampleSeparator, style: TextStyle(fontSize: 12, color: AppColor.text)),
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

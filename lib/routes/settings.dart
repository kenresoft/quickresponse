import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/constants/constants.dart';
import '../main.dart';
import '../providers/page_provider.dart';
import '../providers/settings/date_format.dart';
import '../providers/settings/text_field_provider.dart';
import '../utils/density.dart';
import '../widgets/bottom_navigator.dart';
import '../widgets/time_update_widget.dart';

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
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text('Text Field Direction'),
              trailing: DropdownButton<TextFieldDirection>(
                value: textFieldDirection,
                onChanged: (newValue) {
                  ref.watch(textFieldDirectionProvider.notifier).setTextFieldDirection = newValue!;
                },
                items: const [
                  DropdownMenuItem(
                    value: TextFieldDirection.horizontal,
                    child: Text('Horizontal'),
                  ),
                  DropdownMenuItem(
                    value: TextFieldDirection.vertical,
                    child: Text('Vertical'),
                  ),
                ],
              ),
            ),
            ExpansionPanelList(
              elevation: 1,
              expandedHeaderPadding: EdgeInsets.zero,
              elevation: 1,
              dividerColor: Colors.transparent,
              expandedHeaderPadding: EdgeInsets.zero,
              expansionCallback: (int index, bool isExpanded) {
                // Toggle the expansion state of the panel.
                // You can use a list of bools to control each panel individually.
                ref.read(expandedStateProvider(index).notifier).toggle();
              },
              children: [
                _buildExpansionPanel(
                  'Date Format',
                  DateFormatOption.values,
                  selectedDateFormat,
                  _buildDateFormatDropdownItem,
                  ref,
                ),
                _buildExpansionPanel(
                  'Date Separator',
                  ['/', '-', '.'],
                  selectedDateSeparator,
                  _buildDateSeparatorDropdownItem,
                  ref,
                ),
                _buildExpansionPanel(
                  'Time Format',
                  TimeFormatOption.values,
                  selectedTimeFormat,
                  _buildTimeFormatDropdownItem,
                  ref,
                ),
                _buildExpansionPanel(
                  'Time Separator',
                  [':', '.', '-'],
                  selectedTimeSeparator,
                  _buildTimeSeparatorDropdownItem,
                  ref,
                ),
              ],
            ),
          ],
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
          Text(description, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text('Current Date: $sample', style: const TextStyle(fontSize: 12)),
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
          Text(description, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          RealTimeTimeWidget(selectedTimeFormat: option, selectedTimeSeparator: sampleSeparator, style: const TextStyle(fontSize: 12)),
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

  // Helper method to build an expansion panel
  ExpansionPanel _buildExpansionPanel(
      String title,
      List<dynamic> values,
      dynamic selectedValue,
      Function(dynamic, String, String) buildDropdownItem,
      WidgetRef ref,
      ) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(title),
        );
      },
      body: ListTile(
        title: DropdownButton(
          value: selectedValue,
          onChanged: (newValue) {
            ref.read(expandedStateProvider(title).notifier).toggle();
            buildDropdownItem(newValue, title, selectedValue);
          },
          items: values.map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
        ),
      ),
      isExpanded: ref.watch(expandedStateProvider(title)),
    );
  }
}

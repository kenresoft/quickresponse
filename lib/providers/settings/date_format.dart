// Create an enum for date format options
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/preference.dart';

/*final dateFormatProvider = StateNotifierProvider<DateFormatOptionNotifier, DateFormatOption>((ref) {
  return DateFormatOptionNotifier();
});

class DateFormatOptionNotifier extends StateNotifier<DateFormatOption> {
  DateFormatOptionNotifier() : super(DateFormatOption.format1);

  set setDateFormatOption(DateFormatOption dateFormatOption) => state = dateFormatOption;
}*/

DateFormatOption get dateFormat {
  DateFormatOption timeFormatOption;
  final savedTimeFormat = SharedPreferencesService.getString('dateFormat');
  timeFormatOption = switch (savedTimeFormat) {
    _? => DateFormatOption.values.firstWhere((option) => option.toString() == savedTimeFormat, orElse: () => DateFormatOption.format1),
    _ => DateFormatOption.format1
  };
  return timeFormatOption;
}

String get dateSeparator {
  return SharedPreferencesService.getString('dateSeparator') ?? ':';
}

set dateSeparator(String value) {
  SharedPreferencesService.setString('dateSeparator', value);
}

enum DateFormatOption { format1, format2, format3 }

final expandedStateProvider = StateNotifierProviderFamily<ExpandedStateNotifier, bool, String>((ref, title) {
  return ExpandedStateNotifier();
});

class ExpandedStateNotifier extends StateNotifier<bool> {
  ExpandedStateNotifier() : super(false); // Initial value is false (not expanded)

  void toggle() {
    state = !state;
  }
}

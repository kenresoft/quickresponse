/*import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickresponse/services/preference.dart';

final timeFormatProvider = StateNotifierProvider<TimeFormatOptionNotifier, TimeFormatOption>(
  (ref) => TimeFormatOptionNotifier(),
);

class TimeFormatOptionNotifier extends StateNotifier<TimeFormatOption> {
  TimeFormatOptionNotifier() : super(TimeFormatOption.format24Hours);

  TimeFormatOption get timeFormat {
    final savedTimeFormat = SharedPreferencesService.getString('timeFormat');
    if (savedTimeFormat != null) {
      state = TimeFormatOption.values.firstWhere(
        (option) => option.toString() == savedTimeFormat,
        orElse: () => TimeFormatOption.format24Hours,
      );
    }
    return state;
  }

  set timeFormat(TimeFormatOption newTimeFormat) {
    SharedPreferencesService.setString('timeFormat', newTimeFormat.toString());
    state = newTimeFormat;
  }
}*/

import '../../services/preference.dart';

TimeFormatOption get timeFormat {
  TimeFormatOption timeFormatOption;
  final savedTimeFormat = SharedPreferencesService.getString('timeFormat');
  timeFormatOption = switch (savedTimeFormat) {
    _? => TimeFormatOption.values.firstWhere((option) => option.toString() == savedTimeFormat, orElse: () => TimeFormatOption.format24Hours),
    _ => TimeFormatOption.format24Hours
  };
  return timeFormatOption;
}

String get timeSeparator {
  return SharedPreferencesService.getString('timeSeparator') ?? ':';
}

set timeSeparator(String value) {
  SharedPreferencesService.setString('timeSeparator', value);
}

enum TimeFormatOption { format12Hours, format24Hours }

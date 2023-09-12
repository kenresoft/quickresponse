// Create an enum for date format options
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DateFormatOption { format1, format2, format3 }

enum TimeFormatOption { format12Hours, format24Hours }

final dateFormatProvider = StateNotifierProvider<DateFormatOptionNotifier, DateFormatOption>((ref) {
  return DateFormatOptionNotifier();
});

class DateFormatOptionNotifier extends StateNotifier<DateFormatOption> {
  DateFormatOptionNotifier() : super(DateFormatOption.format1);

  set setDateFormatOption(DateFormatOption dateFormatOption) => state = dateFormatOption;
}

final timeFormatProvider = StateNotifierProvider<TimeFormatOptionNotifier, TimeFormatOption>((ref) {
  return TimeFormatOptionNotifier();
});

class TimeFormatOptionNotifier extends StateNotifier<TimeFormatOption> {
  TimeFormatOptionNotifier() : super(TimeFormatOption.format24Hours);

  set setTimeFormatOption(TimeFormatOption timeFormatOption) => state = timeFormatOption;
}

final dateSeparatorProvider = StateNotifierProvider<DateSeparatorNotifier, String>((ref) {
  return DateSeparatorNotifier();
});

class DateSeparatorNotifier extends StateNotifier<String> {
  DateSeparatorNotifier() : super('/'); // Set the default separator

  set setDateSeparator(String dateSeparator) => state = dateSeparator;
}

final timeSeparatorProvider = StateNotifierProvider<TimeSeparatorNotifier, String>((ref) {
  return TimeSeparatorNotifier();
});

class TimeSeparatorNotifier extends StateNotifier<String> {
  TimeSeparatorNotifier() : super(':'); // Set the default separator

  set setTimeSeparator(String timeSeparator) => state = timeSeparator;
}

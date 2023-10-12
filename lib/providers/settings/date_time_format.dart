import '../../services/preference.dart';

DateFormatOption get dateFormat {
  DateFormatOption timeFormatOption;
  final savedTimeFormat = SharedPreferencesService.getString('dateFormat');
  timeFormatOption = switch (savedTimeFormat) {
    _? => DateFormatOption.values.firstWhere((option) => option.toString() == savedTimeFormat, orElse: () => DateFormatOption.format1),
    _ => DateFormatOption.format1
  };
  return timeFormatOption;
}

TimeFormatOption get timeFormat {
  TimeFormatOption timeFormatOption;
  final savedTimeFormat = SharedPreferencesService.getString('timeFormat');
  timeFormatOption = switch (savedTimeFormat) {
    _? => TimeFormatOption.values.firstWhere((option) => option.toString() == savedTimeFormat, orElse: () => TimeFormatOption.format24Hours),
    _ => TimeFormatOption.format24Hours
  };
  return timeFormatOption;
}

enum DateFormatOption { format1, format2, format3, format4, format5 }

enum TimeFormatOption { format12Hours, format24Hours }

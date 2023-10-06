import '../../services/preference.dart';
import 'date_time_format.dart';

// H: Theme
bool get theme {
  return SharedPreferencesService.getBool('theme') ?? false;
}

set theme(bool value) {
  SharedPreferencesService.setBool('theme', value);
}

// H: Date~Time
set dateFormat(DateFormatOption dateFormatOption) {
  SharedPreferencesService.setString('dateFormat', dateFormatOption.toString());
}

set timeFormat(TimeFormatOption timeFormatOption) {
  SharedPreferencesService.setString('timeFormat', timeFormatOption.toString());
}

// H: Date Separator
String get dateSeparator {
  return SharedPreferencesService.getString('dateSeparator') ?? ':';
}

set dateSeparator(String value) {
  SharedPreferencesService.setString('dateSeparator', value);
}

// H: Time Separator
String get timeSeparator {
  return SharedPreferencesService.getString('timeSeparator') ?? ':';
}

set timeSeparator(String value) {
  SharedPreferencesService.setString('timeSeparator', value);
}

// H: Note
String get note {
  return SharedPreferencesService.getString('note') ?? ':';
}

set note(String value) {
  SharedPreferencesService.setString('note', value);
}

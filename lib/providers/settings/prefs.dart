import '../../services/preference.dart';
import 'date_time_format.dart';

// H: Theme
bool get theme {
  return SharedPreferencesService.getBool('theme') ?? true;
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
  return SharedPreferencesService.getString('dateSeparator') ?? ', ';
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
  return SharedPreferencesService.getString('note') ?? 'You don\'t have any Note yet!';
}

set note(String value) {
  SharedPreferencesService.setString('note', value);
}

//H: Position
String get longitude {
  return SharedPreferencesService.getString('longitude') ?? '0';
}

set longitude(String value) {
  SharedPreferencesService.setString('longitude', value);
}

String get latitude {
  return SharedPreferencesService.getString('latitude') ?? '0';
}

set latitude(String value) {
  SharedPreferencesService.setString('latitude', value);
}

//H: Authentication
bool get authenticate {
  return SharedPreferencesService.getBool('authenticate') ?? true;
}

set authenticate(bool value) {
  SharedPreferencesService.setBool('authenticate', value);
}

//H: Location Refresh Interval
int get locationInterval {
  return SharedPreferencesService.getInt('locationInterval')??0;
}

set locationInterval(int value) {
  SharedPreferencesService.setInt('locationInterval', value);
}

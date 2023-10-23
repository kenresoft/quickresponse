import 'package:quickresponse/data/emergency/emergency_alert.dart';
import 'package:quickresponse/main.dart';

// H: Theme
bool get theme {
  return SharedPreferencesService.getBool('theme') ?? true;

  /// Light Theme
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
double get longitude {
  return SharedPreferencesService.getDouble('longitude') ?? 0;
}

set longitude(double value) {
  SharedPreferencesService.setDouble('longitude', value);
}

double get latitude {
  return SharedPreferencesService.getDouble('latitude') ?? 0;
}

set latitude(double value) {
  SharedPreferencesService.setDouble('latitude', value);
}

//H: Authentication
bool get authenticate {
  return SharedPreferencesService.getBool('authenticate') ?? false;

  /// Launch home directly
}

set authenticate(bool value) {
  SharedPreferencesService.setBool('authenticate', value);
}

//H: Location Updates Pause
bool get stopLocationUpdate {
  return SharedPreferencesService.getBool('isLocationUpdatesPaused') ?? false;
}

set stopLocationUpdate(bool value) {
  SharedPreferencesService.setBool('isLocationUpdatesPaused', value);
}

//H: Location Refresh Interval
int get locationInterval {
  return SharedPreferencesService.getInt('locationInterval') ?? 30;
}

set locationInterval(int value) {
  SharedPreferencesService.setInt('locationInterval', value);
}

//H : User
String get uid {
  return SharedPreferencesService.getString('uid') ?? 'No uid';
}

set uid(String value) {
  SharedPreferencesService.setString('uid', value);
}

//H: Maximum Message Allowed
int get maxMessageAllowed {
  return SharedPreferencesService.getInt('maxMessageAllowed') ?? 3;
}

set maxMessageAllowed(int value) {
  SharedPreferencesService.setInt('maxMessageAllowed', value);
}

//H: Items Per Page
int get itemsPerPage {
  return SharedPreferencesService.getInt('itemsPerPage') ?? 5;
}

set itemsPerPage(int value) {
  SharedPreferencesService.setInt('itemsPerPage', value);
}

//H: 1- Emergency Alert
List<EmergencyAlert> get emergencyAlerts {
  final alertJson = SharedPreferencesService.getString('emergencyAlerts');
  if (alertJson != null) {
    final List<dynamic> alertList = json.decode(alertJson);
    return alertList.map((json) => EmergencyAlert.fromJson(json)).toList();
  }
  return [];
}

set emergencyAlerts(List<EmergencyAlert> value) {
  final alertJson = json.encode(value.map((alert) => alert.toJson()).toList());
  SharedPreferencesService.setString('emergencyAlerts', alertJson);
}

void deleteEmergencyAlert(EmergencyAlert emergencyAlert) {
  List<EmergencyAlert> alerts = emergencyAlerts;
  alerts.removeWhere((alert) => alert.id.log == emergencyAlert.id.log);
  emergencyAlerts = alerts;
}

// H: Alert Message
String get sosMessage {
  return SharedPreferencesService.getString('sosMessage') ?? '';
}

set sosMessage(String value) {
  SharedPreferencesService.setString('sosMessage', value);
}

List<String> get customMessagesList {
  return (SharedPreferencesService.getStringList('savedMessages') ?? []).map(
    (jsonString) {
      try {
        final json = jsonDecode(jsonString);
        return CustomMessage.fromJson(json).message;
      } catch (e) {
        return 'Invalid Message';
      }
    },
  ).toList();
}

// H:

// H: Theme
bool get isButtonDisabled {
  return SharedPreferencesService.getBool('isButtonDisabled') ?? false;
}

set isButtonDisabled(bool value) {
  SharedPreferencesService.setBool('isButtonDisabled', value);
}

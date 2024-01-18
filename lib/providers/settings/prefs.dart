import 'package:quickresponse/main.dart';

// H: Theme
/// Light Theme
bool get theme => SharedPreferencesService.getBool('theme') ?? true;

set theme(bool value) => SharedPreferencesService.setBool('theme', value);

// H: Date~Time
set dateFormat(DateFormatOption dateFormatOption) => SharedPreferencesService.setString('dateFormat', dateFormatOption.toString());

set timeFormat(TimeFormatOption timeFormatOption) => SharedPreferencesService.setString('timeFormat', timeFormatOption.toString());

// H: Date Separator
String get dateSeparator => SharedPreferencesService.getString('dateSeparator') ?? ' ';

set dateSeparator(String value) => SharedPreferencesService.setString('dateSeparator', value);

// H: Time Separator
String get timeSeparator => SharedPreferencesService.getString('timeSeparator') ?? ':';

set timeSeparator(String value) => SharedPreferencesService.setString('timeSeparator', value);

// H: Text Field Direction
TextFieldDirection get textFieldDirection {
  TextFieldDirection textFieldDirection;
  final savedTextFieldDirection = SharedPreferencesService.getString('textFieldDirection');
  textFieldDirection = switch (savedTextFieldDirection) {
    _? => TextFieldDirection.values.firstWhere((option) => option.toString() == savedTextFieldDirection, orElse: () => TextFieldDirection.vertical),
    _ => TextFieldDirection.vertical
  };
  return textFieldDirection;
}

set textFieldDirection(TextFieldDirection textFieldDirection) => SharedPreferencesService.setString('textFieldDirection', textFieldDirection.toString());

// H: Note
String get note => SharedPreferencesService.getString('note') ?? 'You don\'t have any Note yet!';

set note(String value) => SharedPreferencesService.setString('note', value);

//H: Position
double get longitude => SharedPreferencesService.getDouble('longitude') ?? 0;

set longitude(double value) => SharedPreferencesService.setDouble('longitude', value);

double get latitude => SharedPreferencesService.getDouble('latitude') ?? 0;

set latitude(double value) => SharedPreferencesService.setDouble('latitude', value);

String get locationData => SharedPreferencesService.getString('locationData') ?? 'Not available';

set locationData(String value) => SharedPreferencesService.setString('locationData', value);

//H: Authentication
/// Launch home directly
bool get authenticate => SharedPreferencesService.getBool('authenticate') ?? false;

set authenticate(bool value) => SharedPreferencesService.setBool('authenticate', value);

//H: Location Updates Pause
bool get stopLocationUpdate => SharedPreferencesService.getBool('isLocationUpdatesPaused') ?? false;

set stopLocationUpdate(bool value) => SharedPreferencesService.setBool('isLocationUpdatesPaused', value);

//H: Location Refresh Interval
int get locationInterval => SharedPreferencesService.getInt('locationInterval') ?? 30;

set locationInterval(int value) => SharedPreferencesService.setInt('locationInterval', value);

//H : User
String get uid => SharedPreferencesService.getString('uid') ?? 'No uid';

set uid(String value) => SharedPreferencesService.setString('uid', value);

//H: Maximum Message Allowed
int get maxMessageAllowed => SharedPreferencesService.getInt('maxMessageAllowed') ?? 3;

set maxMessageAllowed(int value) => SharedPreferencesService.setInt('maxMessageAllowed', value);

//H: Items Per Page
int get itemsPerPage => SharedPreferencesService.getInt('itemsPerPage') ?? 5;

set itemsPerPage(int value) => SharedPreferencesService.setInt('itemsPerPage', value);

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
  alerts.removeWhere((alert) => alert.id == emergencyAlert.id);
  emergencyAlerts = List.from(alerts);
}

/*List<EmergencyAlert> updateSelectedAlerts() {
  List<EmergencyAlert> updatedList = _filterAndSortAlerts(emergencyAlerts);
  return List.from(updatedList);
}*/

void deleteAllEmergencyAlerts() {
  SharedPreferencesService.remove('emergencyAlerts');
  emergencyAlerts.clear();
}

// H: Alert Message
String get sosMessage => SharedPreferencesService.getString('sosMessage') ?? '';

set sosMessage(String value) => SharedPreferencesService.setString('sosMessage', value);

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
bool get isButtonDisabled => SharedPreferencesService.getBool('isButtonDisabled') ?? false;

set isButtonDisabled(bool value) => SharedPreferencesService.setBool('isButtonDisabled', value);

//H: Video Record Length
int get videoRecordLength => SharedPreferencesService.getInt('videoRecordLength') ?? 10;

set videoRecordLength(int value) => SharedPreferencesService.setInt('videoRecordLength', value);

//H: Travel Alarm Interval
int get travelAlarmInterval => SharedPreferencesService.getInt('travelAlarmInterval') ?? 30;

set travelAlarmInterval(int value) => SharedPreferencesService.setInt('travelAlarmInterval', value);

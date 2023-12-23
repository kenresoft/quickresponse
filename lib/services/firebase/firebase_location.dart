
import 'package:quickresponse/data/model/location_info.dart';
import 'package:quickresponse/imports.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

///users/userId/location/locationLog
///
///SAVE
Future<void> saveUserLocationToFirestore(String userId, Position position) async {
  LocationLog locationLog = LocationLog(timestamp: Timestamp.now(), latitude: position.latitude, longitude: position.longitude);
  try {
    await _firestore.collection('users').doc(userId).collection('location').doc('locationLog').set(locationLog.toJson());
    await saveLocationLogToSharedPreferences(locationLog);
  } catch (e) {
    'Error creating user location: $e'.log;
  }
}

///FETCH
Future<LocationLog?> fetchUserLocation(String userId) async {
  try {
    final DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).collection('location').doc('locationLog').get();
    if (snapshot.exists) {
      return LocationLog.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  } catch (e) {
    'Error fetching user location: $e'.log;
    return null;
  }
}

///UPDATE
Future<void> updateUserLocation(String userId, Map<String, dynamic> updatedLocationData) async {
  try {
    await _firestore.collection('users').doc(userId).collection('location').doc('locationLog').update(updatedLocationData);
  } catch (e) {
    'Error updating user location: $e'.log;
  }
}

///DELETE
Future<void> deleteUserLocation(String userId) async {
  try {
    await _firestore.collection('users').doc(userId).collection('location').doc('locationLog').delete();
  } catch (e) {
    'Error deleting user location: $e'.log;
  }
}

/// Save LocationLog to SharedPreferences
Future<void> saveLocationLogToSharedPreferences(LocationLog locationLog) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final locationJson = jsonEncode(locationLog.toJson());
  await prefs.setString('locationLog', locationJson);
}

/// Retrieve LocationLog from SharedPreferences
LocationLog location()  {
  final locationJson = SharedPreferencesService.getString('locationLog');
  if (locationJson != null) {
    final Map<String, dynamic> locationMap = jsonDecode(locationJson);
    return LocationLog.fromJson(locationMap);
  } else {
    return LocationLog(); // Return an empty LocationLog object if no data is found
  }
}

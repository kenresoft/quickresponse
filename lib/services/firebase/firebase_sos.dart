import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/model/sos_history.dart';
import '../../utils/wrapper.dart';

final CollectionReference sosHistoryCollection = FirebaseFirestore.instance.collection('users');

// Create a new SOS history record
Future<void> addFirebaseSOSHistory({
  required String userId,
  required String type,
  required String recipient,
  required String latitude,
  required String longitude,
  required String message,
}) async {
  final userRef = sosHistoryCollection.doc(userId);
  final sosHistoryData = {
    'userId': userId,
    'type': type,
    'recipient': recipient,
    'timestamp': Timestamp.now(),
    'latitude': latitude,
    'longitude': longitude,
    'message': message,
  };

  await userRef.collection('sosHistory').doc('$recipient - ${generateRandomId(length: 8)}').set(sosHistoryData);
}

// Read SOS history records for a specific user
Stream<List<SOSHistory>> getFirebaseSOSHistory({required String userId, String? filter}) {
  final query = sosHistoryCollection
      .doc(userId) // Assuming you want to retrieve SOS Alerts for a specific user
      .collection('sosHistory')
      .where('type', isEqualTo: filter)
      .orderBy('timestamp', descending: true);

  return query.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => SOSHistory.fromSnapshot(doc)).toList();
  });
}

// Update an existing SOSAlert record
/// (usually not needed)
Future<void> _updateFirebaseSOSHistory({
  required String userId,
  required String sosAlertId,
  required Timestamp timestamp,
  required String location,
  required String message,
}) async {
  final sosHistoryRef = sosHistoryCollection
      .doc(userId) // Assuming you want to update an SOS Alert for a specific user
      .collection('sosAlerts')
      .doc(sosAlertId);

  final sosHistoryData = {
    'timestamp': timestamp,
    'location': location,
    'message': message,
  };

  await sosHistoryRef.update(sosHistoryData);
}

// Delete an existing SOS history record
///(usually not needed)
Future<void> deleteSOSAlert({
  required String userId,
  required String sosAlertId,
}) async {
  final sosAlertRef = sosHistoryCollection
      .doc(userId) // Assuming you want to delete an SOS Alert for a specific user
      .collection('sosAlerts')
      .doc(sosAlertId);

  await sosAlertRef.delete();
}

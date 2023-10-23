import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/model/emergency_contact.dart';

final CollectionReference contactsCollection = FirebaseFirestore.instance.collection('users');

// Create a new emergency contact
Future<void> addFirebaseContact({
  required String userId,
  required String name,
  required String phoneNumber,
}) async {
  final userRef = contactsCollection.doc(userId);
  final contactData = {
    'name': name,
    'phoneNumber': phoneNumber,
    'timestamp': Timestamp.now(),
  };

  await userRef.collection('emergencyContacts').doc(phoneNumber).set(contactData);
}

// Read emergency contacts for a user
Stream<List<EmergencyContact>> getFirebaseContacts({required String userId}) {
  final userRef = contactsCollection.doc(userId);

  return userRef.collection('emergencyContacts').orderBy('timestamp', descending: true).snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => EmergencyContact.fromSnapshot(doc)).toList();
  });
}

// Update an existing emergency contact
Future<void> updateFirebaseContact({
  required String userId,
  required String name,
  required String phoneNumber,
  required String relationship,
  required String age,
}) async {
  final userRef = contactsCollection.doc(userId);
  final contactRef = userRef.collection('emergencyContacts').doc(phoneNumber);
  final contactData = {
    'name': name,
    'phoneNumber': phoneNumber,
    'relationship': relationship,
    'age': age,
    'timestamp': Timestamp.now(),
  };

  await contactRef.update(contactData);
}

// Delete an existing emergency contact
Future<void> deleteFirebaseContact({
  required String userId,
  required String phoneNumber,
}) async {
  final userRef = contactsCollection.doc(userId);
  final contactRef = userRef.collection('emergencyContacts').doc(phoneNumber);

  await contactRef.delete();
}

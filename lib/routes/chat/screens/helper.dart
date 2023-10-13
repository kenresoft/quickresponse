import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

String generateRandomGroupId() {
  const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random.secure();
  String randomId = String.fromCharCodes(Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  return randomId;
}

String generateRandomMessageId(String userName) {
  DateTime now = DateTime.now();
  String formattedDate = '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';
  return '$userName-$formattedDate';
}


String getCurrentUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    throw Exception('User not authenticated');
  }
}

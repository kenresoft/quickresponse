import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickresponse/data/model/profile_info.dart';
import 'package:quickresponse/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

///users/userId/profile/profileInfo
///SAVE
Future<void> saveUserProfileToFirestore(User user) async {
  ProfileInfo profileInfo = ProfileInfo(
    displayName: user.displayName,
    email: user.email,
    phoneNumber: user.phoneNumber,
    photoURL: user.photoURL,
  );
  try {
    await _firestore.collection('users').doc(user.uid).collection('profile').doc('profileInfo').set(profileInfo.toJson());
    await saveProfileInfoToSharedPreferences(profileInfo);
  } catch (e) {
    'Error creating user profile: $e'.log;
  }
}

///FETCH
Future<ProfileInfo?> fetchUserProfile(String userId) async {
  try {
    final DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).collection('profile').doc('profileInfo').get();
    if (snapshot.exists) {
      return ProfileInfo.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  } catch (e) {
    'Error fetching user profile: $e'.log;
    return null;
  }
}

///UPDATE
Future<void> updateUserProfile(String userId, Map<String, dynamic> updatedProfileData) async {
  try {
    await _firestore.collection('users').doc(userId).collection('profile').doc('profileInfo').update(updatedProfileData);
  } catch (e) {
    'Error updating user profile: $e'.log;
  }
}

///DELETE
Future<void> deleteUserProfile(String userId) async {
  try {
    await _firestore.collection('users').doc(userId).collection('profile').doc('profileInfo').delete();
  } catch (e) {
    'Error deleting user profile: $e'.log;
  }
}

/// Save ProfileInfo to SharedPreferences
Future<void> saveProfileInfoToSharedPreferences(ProfileInfo profileInfo) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final profileJson = jsonEncode(profileInfo.toJson());
  await prefs.setString('profileInfo', profileJson);
}

/// Retrieve ProfileInfo from SharedPreferences
Future<ProfileInfo> getProfileInfoFromSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final profileJson = prefs.getString('profileInfo');
  if (profileJson != null) {
    final Map<String, dynamic> profileMap = jsonDecode(profileJson);
    return ProfileInfo.fromJson(profileMap);
  } else {
    return ProfileInfo(); // Return an empty ProfileInfo object if no data is found
  }
}

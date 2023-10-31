import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickresponse/data/model/profile_info.dart';
import 'package:quickresponse/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../preference.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

///users/userId/profile/profileInfo
///
///SAVE
Future<void> saveUserProfileToFirestore(User user) async {
  var profile = await fetchUserProfile(user.uid);
  ProfileInfo profileInfo;
  try {
    // Check if the user already exists in Firestore
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).collection('profile').doc('profileInfo').get();
    if (userDoc.exists) {
      // User already exists, handle the logic (e.g., show an error message)
      profileInfo = ProfileInfo(
        uid: profile!.uid,
        displayName: profile.displayName,
        email: profile.email,
        phoneNumber: profile.phoneNumber,
        photoURL: profile.photoURL,
        //timestamp: Timestamp.now(),
      );
    } else {
      // User doesn't exist, save the profile
      profileInfo = ProfileInfo(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        photoURL: user.photoURL,
        //timestamp: Timestamp.now(),
      );
    }
    await _firestore.collection('users').doc(user.uid).collection('profile').doc('profileInfo').set(profileInfo.toJson());
    await saveProfileInfoToSharedPreferences(profileInfo);
    profileInfo.uid;
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
ProfileInfo getProfileInfoFromSharedPreferences()  {
  final profileJson = SharedPreferencesService.getString('profileInfo');
  try {
    if (profileJson != null) {
      final Map<String, dynamic> profileMap = jsonDecode(profileJson);
      return ProfileInfo.fromJson(profileMap);
    } else {
      return ProfileInfo(); // Return an empty ProfileInfo object if no data is found
    }
  } catch (e) {
    e.log;
    print('Error reading profile info from SharedPreferences: $e');
  }
  return ProfileInfo(); // Return a default ProfileInfo object if there's an error or no data is found
}

Future<void> updatePhoneNumberInSharedPreferences(String newPhoneNumber, bool isProfileComplete) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('profileInfo');

    if (profileJson != null) {
      final Map<String, dynamic> profileMap = jsonDecode(profileJson);
      // Update the phoneNumber field
      profileMap['phoneNumber'] = newPhoneNumber;
      profileMap['isComplete'] = isProfileComplete;
      // Encode the updated profileMap to JSON and save it back to SharedPreferences
      await prefs.setString('profileInfo', jsonEncode(profileMap));
    } else {
      // Handle the case where there's no existing profile info
      print('No existing profile info found in SharedPreferences');
    }
  } catch (e) {
    // Handle errors if any occur during the update process
    print('Error updating phoneNumber in SharedPreferences: $e');
  }
}

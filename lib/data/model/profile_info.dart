import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileInfo {
  final String? uid;
  final String? displayName;
  final String? email;
  late final String? phoneNumber;
  final String? photoURL;
  final bool isComplete;
  //final Timestamp? timestamp;

  // String? _phoneNumber;

  //String? get phoneNumber => _phoneNumber;

  setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  ProfileInfo({
    this.uid,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoURL,
    this.isComplete = false,
    //this.timestamp,
  });

  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      uid: json['uid'] as String?,
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      photoURL: json['photoURL'] as String?,
      isComplete: json['isComplete'] as bool,
      /*timestamp: json['timestamp'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(int.parse(json['timestamp'] as String))
          : null, // Convert String to int and then to Timestamp, if not null*/
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'isComplete': isComplete,
      //'timestamp': timestamp?.millisecondsSinceEpoch.toString(), // Convert Timestamp to milliseconds and then to String
    };
  }

}

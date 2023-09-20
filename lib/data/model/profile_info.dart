class ProfileInfo {
  final String? displayName;
  final String? email;
  final String? phoneNumber;
  final String? photoURL;

  ProfileInfo({
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoURL,
  });

  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      photoURL: json['photoURL'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
    };
  }
}

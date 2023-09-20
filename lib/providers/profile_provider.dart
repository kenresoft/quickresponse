import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/profile_info.dart';

final profileInfoProvider = StateNotifierProvider<ProfileInfoNotifier, ProfileInfo?>((ref) {
  return ProfileInfoNotifier();
});

class ProfileInfoNotifier extends StateNotifier<ProfileInfo?> {
  ProfileInfoNotifier() : super(null);

  set setProfile(ProfileInfo? index) => state = index;
}

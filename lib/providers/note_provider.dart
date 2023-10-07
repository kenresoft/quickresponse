import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileNoteProvider = StateNotifierProvider<ProfileNoteNotifier, bool>((ref) {
  return ProfileNoteNotifier();
});

class ProfileNoteNotifier extends StateNotifier<bool> {
  ProfileNoteNotifier() : super(false);

  set editNote(bool value) => state = value;
}

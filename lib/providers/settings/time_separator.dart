/*import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/preference.dart';

final timeSeparatorProvider = StateNotifierProvider<TimeSeparatorNotifier, String>((ref) {
  return TimeSeparatorNotifier();
});

class TimeSeparatorNotifier extends StateNotifier<String> {
  TimeSeparatorNotifier() : super(':'); // Set the default separator

  String get timeSeparator {
    state = SharedPreferencesService.getString('timeSeparator')!;
    return state;
  }

  set timeSeparator(String newTimeFormat) {
    SharedPreferencesService.setString('timeSeparator', newTimeFormat.toString());
    state = newTimeFormat;
  }
}*/

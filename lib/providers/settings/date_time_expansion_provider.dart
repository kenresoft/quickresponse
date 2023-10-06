import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateTimeExpansionStateProvider = StateNotifierProviderFamily<DateTimeExpansionStateNotifier, bool, String>(
  (ref, title) {
    return DateTimeExpansionStateNotifier();
  },
);

class DateTimeExpansionStateNotifier extends StateNotifier<bool> {
  DateTimeExpansionStateNotifier() : super(false); // Initial value is false (not expanded)

  void toggle() {
    state = !state;
  }
}

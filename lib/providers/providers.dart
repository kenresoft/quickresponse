
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(true);

  void toggleTheme(bool isDarkEnabled) => state = isDarkEnabled;
}

final tabProvider = StateNotifierProvider<TabNotifier, int>((ref) {
  return TabNotifier();
});

class TabNotifier extends StateNotifier<int> {
  TabNotifier() : super(0);

  set setTab(int index) => state = index;
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/init.dart';

//final locationProvider = StateProvider<Position?>((ref) => null);

// final locationProvider = StreamProvider<Position?>((ref) {
//   return Geolocator.getPositionStream(locationSettings: locationSettings);
// });

final locationProvider = StreamNotifierProvider<LocationNotifier, Position?>(() {
  return LocationNotifier();
});

class LocationNotifier extends StreamNotifier<Position?> {
  LocationNotifier() : super();

  @override
  Stream<Position?> build() {
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  set setPosition(AsyncValue<Position> position) => state = position;
}

/*final locationProvider = StateNotifierProvider<PositionNotifier, bool>((ref) {
  return PositionNotifier();
});

class PositionNotifier extends StateNotifier<bool> {
  PositionNotifier() : super(true);

  void toggleTheme(bool isDarkEnabled) => state = isDarkEnabled;
}*/

/*final tabProvider = StateNotifierProvider<TabNotifier, int>((ref) {
  return TabNotifier();
});

class TabNotifier extends StateNotifier<int> {
  TabNotifier() : super(0);

  set setTab(int index) => state = index;
}*/

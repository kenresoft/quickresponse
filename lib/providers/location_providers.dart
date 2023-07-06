import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/init.dart';

//final locationProvider = StateProvider<Position?>((ref) => null);

// final locationProvider = StreamProvider<Position?>((ref) {
//   return Geolocator.getPositionStream(locationSettings: locationSettings);
// });

/*final locationProvider = StreamNotifierProvider<LocationNotifier, Position?>(() {
  return LocationNotifier();
});

class LocationNotifier extends StreamNotifier<Position?> {
  LocationNotifier() : super();

  @override
  Stream<Position?> build() {
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  set setPosition(AsyncValue<Position> position) => state = position;
}*/

/*final locationProvider = StateNotifierProvider<PositionNotifier, bool>((ref) {
  return PositionNotifier();
});

class PositionNotifier extends StateNotifier<bool> {
  PositionNotifier() : super(true);

  void toggleTheme(bool isDarkEnabled) => state = isDarkEnabled;
}*/

final positionProvider = StateNotifierProvider<PositionNotifier, Position?>((ref) {
  return PositionNotifier();
});

class PositionNotifier extends StateNotifier<Position?> {
  PositionNotifier() : super(null);

  set setPosition(Position? index) => state = index;
}

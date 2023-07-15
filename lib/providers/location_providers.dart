import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';

import '../data/db/database_client.dart';

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

final locationDbProvider = StateNotifierProvider<LocationDbNotifier, Database?>((ref) {
  return LocationDbNotifier();
});

class LocationDbNotifier extends StateNotifier<Database?> {
  LocationDbNotifier() : super(null);

  Future<void> initialize() async {
    Database? db = await DatabaseClient().db;
    state = db;
  }
}

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';

class LocationDB {
  LocationDB(this.db);

  final Database? db;
  late Map<String, Object?> location;

  Future<void> insert(Position position, List<Placemark> placemarks) async {
    location = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': placemarks[0].name,
    };
    await db?.insert('location', location);
  }

  Future<void> initialize() async {
    location = {"latitude": 1.0, "longitude": 1.0, "address": "a"};
    await db?.insert('location', location, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, Object?>>?> getLocation() async {
    // Fetch the location from the database.
    return await db?.query('location');
  }

  updateLocation(Position position, List<Placemark> placemarks) async {
    if (await getLocation() == null) {
      insert(position, placemarks);
    }
    // Update the location in the database.
    var location = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': placemarks.last.name,
    };
    await db?.update('location', location, where: 'id = ?', whereArgs: [1]);
  }

  deleteLocation() async {
    // Delete the location from the database.
    await db?.delete('location', where: 'id = ?', whereArgs: [1]);
  }
}

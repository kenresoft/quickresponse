import 'package:quickresponse/imports.dart';

class LocationService {
  static bool _isRunning = false;
  //static bool _stopService = false;

  static Future<void> startLocationUpdates(
    Function(Position) onLocationUpdate,
    Function(bool) onPermissionDenied,
  ) async {
    if (_isRunning) {
      return;
    }

    bool serviceEnabled;
    LocationPermission permission;

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      onPermissionDenied(true);
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        onPermissionDenied(true);
        return;
      }
    }

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    ///serviceEnabled.log;
    if (!serviceEnabled) {
      onPermissionDenied(false);
      //return;
    }

    _isRunning = true;

    while (stopLocationUpdate) {
      'Loop is running...'.log;
      try {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        if (!stopLocationUpdate) {
          break;
        }

        // Notify the callback function with the latest location
        onLocationUpdate(position.log);

        if (!stopLocationUpdate) {
          break;
        }

        await Future.delayed(Duration(seconds: locationInterval));
      } catch (e) {
        // Handle errors here
        '...$e'.log;
        await Future.delayed(Duration(seconds: locationInterval));
      }
    }
    _isRunning = false;
    //_stopService = false;
  }

  static void stopLocationUpdates() {
    if (_isRunning) {
      stopLocationUpdate = true;
    }
  }
}

/*
import 'package:geolocator/geolocator.dart';
import 'package:quickresponse/utils/extensions.dart';

import '../providers/settings/prefs.dart';

class LocationService {
  bool _isRunning = false;

  Future<void> startLocationUpdates(Function(Position) onLocationUpdate, Function(bool) onPermissionDenied) async {
    if (_isRunning) {
      return;
    }

    bool serviceEnabled;
    LocationPermission permission;

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      onPermissionDenied(true);
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        onPermissionDenied(true);
        return;
      }
    }

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    serviceEnabled.log;
    if (!serviceEnabled) {
      onPermissionDenied(false);
      stopLocationUpdates();
      //return;
    }

    _isRunning = true;

    while (_isRunning) {
      'Loop is running...'.log;
      try {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        // Notify the callback function with the latest location
        onLocationUpdate(position.log);

        await Future.delayed(Duration(seconds: locationInterval));
      } catch (e) {
        // Handle errors here
        '...$e'.log;
        await Future.delayed(Duration(seconds: locationInterval));
      }
    }
  }

  void stopLocationUpdates() {
    _isRunning = false;
  }
}
*/

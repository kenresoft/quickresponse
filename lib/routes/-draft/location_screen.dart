/*
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:quickresponse/services/location_service.dart';
import 'package:quickresponse/utils/extensions.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> with WidgetsBindingObserver {
  final LocationService _locationService = LocationService();
  late String _locationData;
  late String _streetAddress;
  bool _isPermissionDenied = false;
  bool _isLocationUpdatesPaused = false;

  @override
  void initState() {
    super.initState();
    _locationData = 'Fetching location...';
    _streetAddress = 'Fetching address...';
    WidgetsBinding.instance.addObserver(this);
    _checkLocationPermission();
  }

  void _checkLocationPermission() async {
    bool isPermissionDenied = false;
    await _locationService.startLocationUpdates(
      (position) async {
        setState(() {
          if (!_isLocationUpdatesPaused) {
            _locationData = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
            _getAddressFromCoordinates(position.latitude, position.longitude);
          }
        });
      },
      (isDenied) {
        setState(() {
          isPermissionDenied = isDenied;
        });
      },
    );

    setState(() {
      _isPermissionDenied = isPermissionDenied;
    });
  }

  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          _streetAddress = placemark.thoroughfare ?? 'Address not found';
        });
      }
    } catch (e) {
      setState(() {
        _streetAddress = 'Address not found';
      });
      'Error fetching address: $e'.log;
    }
  }

  void _toggleLocationUpdates() {
    setState(() {
      _isLocationUpdatesPaused = !_isLocationUpdatesPaused;
    });

    if (_isLocationUpdatesPaused) {
      _locationService.stopLocationUpdates();
    } else {
      _checkLocationPermission();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      'resumed'.log;
      if (!_isLocationUpdatesPaused) {
        _checkLocationPermission();
      }
    } else if (state == AppLifecycleState.paused) {
      'paused'.log;
      _locationService.stopLocationUpdates();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationService.stopLocationUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isPermissionDenied
                ? const Text(
                    'Location permission denied.',
                    textAlign: TextAlign.center,
                  )
                : Text(
                    _locationData,
                    textAlign: TextAlign.center,
                  ),
            Text(
              'Street Address: $_streetAddress',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: _toggleLocationUpdates,
              child: Text(_isLocationUpdatesPaused ? 'Resume Location Updates' : 'Pause Location Updates'),
            ),
          ],
        ),
      ),
    );
  }

}
*/

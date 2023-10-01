import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickresponse/utils/extensions.dart';

class InternetConnection {
  InternetConnection() {
    _connectivity = Connectivity();
    _initConnectivity();
  }

  Connectivity? _connectivity;

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String _connectionStatus = 'Unknown';

  void Function()? _state;

  String status(Function() state) {
    _state = state;
    return _connectionStatus;
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }

  Future<void> _initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    if (_connectivity == null) {
      _connectivity = Connectivity();
      await _connectivity!.checkConnectivity();
      _connectivitySubscription = _connectivity!.onConnectivityChanged.listen(_updateConnectionStatus);
    } else {
      try {
        result = await _connectivity!.checkConnectivity();
      } catch (e) {
        e.log;
      }
      _updateConnectionStatus(result);
      _connectivitySubscription = _connectivity!.onConnectivityChanged.listen(_updateConnectionStatus);
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        _connectionStatus = 'Connected to WiFi';
        break;
      case ConnectivityResult.mobile:
        _connectionStatus = 'Connected to Mobile Network';
        break;
      case ConnectivityResult.none:
        _connectionStatus = 'No Internet Connection';
        break;
      default:
        _connectionStatus = 'Unknown';
        break;
    }
    _state!();
  }
}

/*StreamSubscription<bool> connectivityCheck() async {
  final ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
}*/

StreamSubscription<Position> getLocation(ValueChanged callback) {
  return Geolocator.getPositionStream().listen((event) {
    callback(event);
  });
}

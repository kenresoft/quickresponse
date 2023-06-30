import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:quickresponse/utils/init.dart';

class LocationStream {
  final StreamController<Position> _controller = StreamController<Position>();

  Stream<Position> get stream => _controller.stream;

  Future<void> start() async {

    _controller.onListen = () {
      var locationStream = Geolocator.getPositionStream(locationSettings: locationSettings);
      locationStream.listen((position) {
        _controller.add(position);
      }, onError: (error) {
        _controller.addError(error);
      });
    };

    _controller.onPause = () {
      //Geolocator.stopLocationUpdates();
    };

    _controller.onResume = () {
      start();
    };

    start();
  }

  Future<void> stop() async {
    _controller.close();
  }
}

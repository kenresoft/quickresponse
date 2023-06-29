import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Call extends StatefulWidget {
  const Call({super.key});

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late Future<Marker> marker;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  void initState() {
    super.initState();
    // Obtain the current location
    Future<Marker> getMarker() async {
      final position = await Geolocator.getCurrentPosition();
      final marker = Marker(
        position: LatLng(position.latitude, position.longitude),
        markerId: const MarkerId('current_location'),
        icon: BitmapDescriptor.defaultMarker,
      );
      return marker;
    }

    marker = getMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Object>(
          future: marker,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GoogleMap(
                markers: <Marker>{snapshot.data as Marker},
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
                initialCameraPosition: _kGooglePlex,
              );
            }
            else {
              return const Text("Loading..");
            }
          }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

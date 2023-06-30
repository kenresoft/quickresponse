import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

/*  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );*/

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final position = GoRouterState.of(context).extra as Position;
    final marker = Marker(
      position: LatLng(position.latitude, position.longitude),
      markerId: const MarkerId('current_location'),
      icon: BitmapDescriptor.defaultMarker,
    );
    return Scaffold(
      body: GoogleMap(
        markers: <Marker>{marker},
        onMapCreated: (controller) {
          _controller.complete(controller);
        },
        initialCameraPosition: CameraPosition(target: marker.position, zoom: 14.4746) /*_kGooglePlex*/,
      ),
      /*FutureBuilder<Object>(
        future: marker,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final mark = snapshot.data as Marker;
            log(mark.position.toString());
            return GoogleMap(
              markers: <Marker>{mark},
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
              initialCameraPosition: CameraPosition(target: mark.position, zoom: 14.4746) */ /*_kGooglePlex*/ /*,
            );
          } else {
            return const Center(child: Text("Loading.."));
          }
        },
      ),*/
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

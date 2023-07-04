// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickresponse/data/constants/colors.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/utils/map_style.dart';

import '../data/constants/api.dart';
import '../data/constants/density.dart';
import '../data/model/pin_pill_info.dart';
import '../providers/location_providers.dart';
import '../widgets/map_pin_pill.dart';
import '../widgets/toast.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
//const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(5.476310, 7.025853);

class LocationMap extends ConsumerStatefulWidget {
  const LocationMap({super.key});

  @override
  ConsumerState<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends ConsumerState<LocationMap> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  final Set<Marker> _markers = <Marker>{};

  // for my drawn routes on the map
  final Set<Polyline> _polyLines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  // for my custom marker pins
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;

  // the user's initial location and current location as it moves
  Position? currentLocation;

  // a reference to the destination location
  Position? destinationLocation;

  late GeolocatorPlatform geolocator;

  double pinPillPosition = -150;

  bool showToast = false;

  PinInformation currentlySelectedPin = PinInformation(
    pinPath: '',
    avatarPath: '',
    location: const LatLng(0, 0),
    locationName: '',
    labelColor: Colors.grey,
  );

  late PinInformation sourcePinInfo;
  late PinInformation destinationPinInfo;

  @override
  void initState() {
    super.initState();

    geolocator = GeolocatorPlatform.instance;
    polylinePoints = PolylinePoints();

    // subscribe to changes in the user's location by "listening" to the location's onLocationChanged event
    getLocation();
    // set the initial location
    //setInitialLocation();
    // set custom marker pins
    setSourceAndDestinationIcons();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void getLocation() {
    // Get the current location from the provider
    var locationStream = ref.watch(locationProvider.select((value) => value)) /* as Stream<Position>*/;
    // Listen to the location stream
    locationStream.when(
      data: (Position? p) {
        // Update the UI
        if (p != null) {
          // Update the location provider
          currentLocation = p;
          // hard-coded destination for this example
          destinationLocation = Position.fromMap({"latitude": DEST_LOCATION.latitude, "longitude": DEST_LOCATION.longitude});

          updatePinOnMap();
          showToast = true;
          log('Current location: ${p.toString()}');
        }
      },
      error: (Object error, StackTrace stackTrace) {
        log("ERROR: $error");
      },
      loading: () {
        log('Map Loading...');
      },
    );
  }

  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.0),
      Constants.drivingPin,
    ).then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.0),
      Constants.destinationMapMarker,
    ).then((onValue) {
      destinationIcon = onValue;
    });
  }

/*  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    final k = await geolocator.getCurrentPosition(locationSettings: locationSettings);
    setState(() {
      currentLocation = k;
    });

    // hard-coded destination for this example
    destinationLocation = Position.fromMap({"latitude": DEST_LOCATION.latitude, "longitude": DEST_LOCATION.longitude});
  }*/

  final CameraPosition _destination = const CameraPosition(
    target: DEST_LOCATION,
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    final position = GoRouterState.of(context).extra as Position;
    //currentLocation = position /*await geolocator.getLastKnownPosition()*/;

    CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
    );
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
        target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
      );
    } else {
      initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
      );
    }

    return Scaffold(
      body: Stack(children: <Widget>[
        GoogleMap(
          myLocationEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: false,
          markers: _markers,
          polylines: _polyLines,
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          onTap: (LatLng loc) {
            setState(() {
              pinPillPosition = -150;
            });
            log(loc.toString());
          },
          trafficEnabled: true,
          mapToolbarEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            controller.setMapStyle(MapStyle.getStyle);
            _controller.complete(controller);
            // my map has completed being created;
            // i'm ready to show the pins on the map
            showPinsOnMap();
          },
        ),
        Toast(text: "Current location not available!", show: showToast),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 0.43.dpW(dp),
            child: MaterialButton(
              color: AppColor.alert_1.withOpacity(0.7),
              padding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              onPressed: () async {
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(CameraUpdate.newCameraPosition(_destination));
              },
              child: Row(children: [
                Icon(Icons.directions_run, color: AppColor.white),
                Text('Destination', style: TextStyle(color: AppColor.white)),
              ]),
            ),
          ),
        ),
        MapPinPillComponent(
          pinPillPosition: pinPillPosition,
          currentlySelectedPin: currentlySelectedPin,
        ),
      ]),
    );
  }

  void setPolyLines() async {
    PolylineResult polyline = await polylinePoints.getRouteBetweenCoordinates(
      Api.googleAPIKey,
      PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
      PointLatLng(destinationLocation!.latitude, destinationLocation!.longitude),
    );
    List<PointLatLng> result = polyline.points;

    if (result.isNotEmpty) {
      for (var point in result) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {
        _polyLines.add(
          Polyline(
            width: 5, // set the width of the polyLines
            polylineId: const PolylineId("poly"),
            color: const Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates,
          ),
        );
      });
    }
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition = LatLng(
      currentLocation!.latitude,
      currentLocation!.longitude,
    );
    // get a LatLng out of the LocationData object
    var destPosition = LatLng(
      destinationLocation!.latitude,
      destinationLocation!.longitude,
    );

    sourcePinInfo = PinInformation(
      locationName: "Start Location",
      location: LatLng(currentLocation!.latitude, currentLocation!.longitude),
      pinPath: Constants.drivingPin,
      avatarPath: Constants.profile,
      labelColor: Colors.blueAccent,
    );

    destinationPinInfo = PinInformation(
      locationName: "End Location",
      location: DEST_LOCATION,
      pinPath: Constants.destinationMapMarker,
      avatarPath: Constants.moon,
      labelColor: Colors.purple,
    );

    // add the initial source location pin
    _markers.add(
      Marker(
        markerId: const MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo;
            pinPillPosition = 0;
            showToast = true;
          });
        },
        icon: sourceIcon,
      ),
    );
    // destination pin
    _markers.add(
      Marker(
        markerId: const MarkerId('destPin'),
        position: destPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = destinationPinInfo;
            pinPillPosition = 0;
            showToast = true;
          });
        },
        icon: destinationIcon,
      ),
    );
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolyLines();
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition = LatLng(currentLocation!.latitude, currentLocation!.longitude);

      sourcePinInfo.location = pinPosition;

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(
        Marker(
          markerId: const MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          position: pinPosition, // updated position
          icon: sourceIcon,
        ),
      );
    });
  }
}

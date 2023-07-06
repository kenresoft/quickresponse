import 'dart:developer';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickresponse/data/constants/colors.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/data/constants/density.dart';
import 'package:quickresponse/utils/init.dart';
import 'package:quickresponse/widgets/bottom_navigator.dart';
import 'package:quickresponse/widgets/suggestion_card.dart';

import '../main.dart';
import '../providers/location_providers.dart';
import '../widgets/alert_button.dart';
import '../widgets/toast.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool isLocationServiceEnabled = false;
  late LocationPermission _permission;
  late GeolocatorPlatform _geolocator;
  Position? _position;
  bool showToast = false;

  @override
  void initState() {
    super.initState();
    _geolocator = GeolocatorPlatform.instance;
    _requestPermission();

    // Check if the location service is enabled.
    //_requestGPS();
    //_startLocationUpdates();
  }

/*  Future<void> _requestGPS() async {
    // Check if the location service is enabled.
    isLocationServiceEnabled = await _geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      _geolocator.getLastKnownPosition().then((location) {
        if (location != null) {
          _position = location;
        } else {
          // Show a dialog to the user asking them to enable the location service.
          _showDialog(context);
        }
      });
    }
  }*/

/*  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LocationDialog();
      },
    );
  }*/

  void _requestPermission() async {
    _permission = await _geolocator.requestPermission();
    if (_permission == LocationPermission.denied) {
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission denied'),
        content: const Text('You need to grant location permission in order to use this app.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              _requestPermission();
            },
          ),
        ],
      ),
    );
  }

/*  void _startLocationUpdates() {
    _geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? p) {
      log(p == null ? 'Unknown' : 'aa ${p.latitude.toString()}, ${p.longitude.toString()}');
      ref.watch(positionProvider.notifier).setPosition = p;
      showToast = false;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    _position = ref.watch(positionProvider.select((value) => value));
    log('Pos: $_position');
/*    if (_position == null) {
      _geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? p) {
        log(p == null ? 'Unknown' : 'aa ${p.latitude.toString()}, ${p.longitude.toString()}');
        ref.watch(positionProvider.notifier).setPosition = p;
        showToast = false;
      });
    }*/
    return StreamBuilder<Position>(
        stream: _geolocator.getPositionStream(),
        builder: (context, snapshot) {
          Position? position;
          var isLoading = true;
          if (snapshot.hasData) {
            position = snapshot.data;
            if (position != null) {
              Future(() => ref.watch(positionProvider.notifier).setPosition = position);
              isLoading = false;
              showToast = false;
            }
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
          } else {
            Toast('Loading position...', show: isLoading);
          }
          return Scaffold(
            backgroundColor: AppColor.background,
            appBar: AppBar(toolbarHeight: 0, backgroundColor: AppColor.background),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Center(
                    child: Column(children: [
                      // 1
                      //Util.loadStream(Geolocator.getServiceStatusStream(), (data) {
                      /*if (data == ServiceStatus.enabled && _position == null) {
                        setState(() {});
                      }*/
                      /* return */ Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: buildRow(context, _position),
                      ),
                      //}),

                      0.04.dpH(dp).spY,

                      // 2
                      0.7.dpW(dp).spaceX(Text(
                            'Emergency help needed?',
                            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColor.title),
                            textAlign: TextAlign.center,
                          )),
                      0.01.dpH(dp).spY,

                      // 3
                      Text(
                        'Just hold the button to call',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: AppColor.text),
                      ),
                      0.05.dpH(dp).spY,

                      // 4
                      GestureDetector(
                        onTap: () => setState(() {}) /*launch(context, Constants.call, (false, ''))*/,
                        child: const AlertButton(height: 190, width: 185, borderWidth: 3, shadowWidth: 15, iconSize: 45),
                      ),
                      0.08.dpH(dp).spY,

                      // 5
                      Text(
                        'Not sure what to do?',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColor.title),
                      ),

                      // 6
                      Text('Pick the subject to chat', style: TextStyle(fontSize: 16, color: AppColor.text)),
                      0.03.dpH(dp).spY,

                      // 7
                      .12.dpH(dp).spaceY(ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (BuildContext context, int index) {
                            return const SuggestionCard(text: 'He had an accident');
                          })),

                      0.03.dpH(dp).spY,

                      // 8
                    ]),
                  ),
                  Toast("Current location not available!", show: showToast),
                ],
              ),
            ),
            bottomNavigationBar: const BottomNavigator(currentIndex: 0),
          );
        });
  }

  Row buildRow(BuildContext context, Position? position) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        const Image(
          image: ExactAssetImage(Constants.tech),
          height: 45,
          width: 45,
        ),
        Column(children: [
          Text(
            'Hi Susan!',
            style: TextStyle(fontSize: 15, color: AppColor.text),
          ),
          Text(
            'Complete profile',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColor.action),
          ),
        ])
      ]),
      GestureDetector(
        onTap: () {
          // log(position.toString());
          if (position == null) {
            setState(() {
              showToast = true;
            });
          } else {
            setState(() {
              showToast = false;
            });
            launch(context, Constants.locationMap /*, position*/);
          }
        },
        child: Row(children: [
          Column(children: [
            Text(
              'Ludwika Waryn...',
              style: TextStyle(fontSize: 15, color: AppColor.text),
            ),
            Text(
              'See your location',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColor.action),
            ),
          ]),
          Icon(Icons.location_on_rounded, color: AppColor.action),
        ]),
      ),
    ]);
  }
}

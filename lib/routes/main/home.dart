import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickresponse/data/constants/colors.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/data/db/location_db.dart';
import 'package:quickresponse/data/emergency/emergency.dart';
import 'package:quickresponse/data/model/profile_info.dart';
import 'package:quickresponse/main.dart';
import 'package:quickresponse/providers/location_providers.dart';
import 'package:quickresponse/providers/page_provider.dart';
import 'package:quickresponse/services/firebase/firebase_location.dart';
import 'package:quickresponse/services/firebase/firebase_profile.dart';
import 'package:quickresponse/utils/density.dart';
import 'package:quickresponse/utils/extensions.dart';
import 'package:quickresponse/utils/wrapper.dart';
import 'package:quickresponse/widgets/alert_button.dart';
import 'package:quickresponse/widgets/blinking_text.dart';
import 'package:quickresponse/widgets/bottom_navigator.dart';
import 'package:quickresponse/widgets/exit_dialog.dart';
import 'package:quickresponse/widgets/tips_carousel.dart';
import 'package:quickresponse/widgets/toast.dart';
import 'package:sqflite/sqflite.dart';

import '../../widgets/html_dialog.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<EmergencyTip>> _tips;
  late GeolocatorPlatform _geolocator;
  Position? _position;
  List<Map>? _location;
  bool isLocationReady = false;
  List<Placemark>? placemarks;
  Widget mPage = const SizedBox();
  bool isAppLaunched = false;
  String? url;
  bool connected = false;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String _connectionStatus = 'Unknown';

  Stream<ServiceStatus>? _locationStatusStream;
  String _locationStatus = 'Unknown';

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    _tips = loadEmergencyTips();
    Future(() => ref.watch(locationDbProvider.notifier).initialize());
    _geolocator = GeolocatorPlatform.instance;
/*    _geolocator.requestPermission().then((value) {
      if (value == LocationPermission.always || value == LocationPermission.whileInUse) {
        setState(() {});
      }
    });*/

    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _locationStatusStream = Geolocator.getServiceStatusStream();
    _locationStatusStream?.listen((status) {
      setState(() {
        _locationStatus = _getStatusString(status);
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    Database? db = ref.watch(locationDbProvider.select((value) => value));
    _position = ref.watch(positionProvider.select((value) => value));
    getLocationFromStorage(db);
    log('Loc: $_location');
    log('Pos: $_position');
    getPlacemarks(db);

    if (!isAppLaunched) {
      setState(() {
        isAppLaunched = true;
        mPage = buildPage(context, dp);
      });
    } else {
      _geolocator.requestPermission();
    }

    final page = ref.watch(pageProvider.select((value) => value));

    // Show the bottom sheet when location is not ready
/*    if (!isLocationReady) {
      _showBottomSheet(context);
    }*/

    return WillPopScope(
      onWillPop: () async {
        bool isLastPage = page.isEmpty;
        if (isLastPage) {
          return (await showExitDialog(context))!;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColor.background,
        appBar: AppBar(toolbarHeight: 0, backgroundColor: AppColor.background),
        body: SingleChildScrollView(
          child: Stack(children: [
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                child: mPage,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOutBack),
                  child: child,
                ),
              ),
            ),
          ]),
        ),
        bottomNavigationBar: const BottomNavigator(currentIndex: 0),
      ),
    );
  }

/*  void _showBottomSheet(BuildContext context) {
    _scaffoldKey.currentState?.showBottomSheet(
      (context) {
        return BottomSheetContent(
          locationStatus: _locationStatus,
          connectionStatus: _connectionStatus,
        );
      },
    );
  }*/

  String _getStatusString(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.enabled:
        return 'Location Services Enabled';
      case ServiceStatus.disabled:
        return 'Location Services Disabled';
    }
  }

  Future<void> _initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
    }
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
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
    });
  }

/*  Future<Widget> showConnectivityMessage() async {
    final String message = await checkConnectivityAndShowToast();
    return Toast(_connectionStatus,, show: !isLocationReady, top: 20);
  }

  Future<String> checkConnectivityAndShowToast() async {
    final bool isConnected = await connectivityCheck();
    if (isConnected) {
      // You are connected to the internet
      return "The location service on the device is disabled!";
    } else {
      // No internet connectivity
      return "No Internet connectivity";
    }
  }*/

  StreamBuilder<Position> buildStreamBuilder(Density dp) {
    return StreamBuilder<Position>(
        stream: _geolocator.getPositionStream(),
        builder: (context, snapshot) {
          Position? position;

          if (snapshot.hasData) {
            position = snapshot.data;
            if (position != null) {
              Future(() => ref.watch(positionProvider.notifier).setPosition = position);
              isLocationReady = true;
            }
          } else if (snapshot.hasError) {
            isLocationReady = false;
            log("Error: ${snapshot.error}");
            //return ErrorPage(error: snapshot.error.toString());
          } else {
            if (placemarks == null && _position != null) {
              rebuild();
            }
            log(placemarks.toString());
            log(_position.toString());

            if (_location != null) {
              if (_location!.isNotEmpty) {
                Map<String, Object> map = {
                  'latitude': _location?.first['latitude'],
                  'longitude': _location?.first['longitude'],
                };
                log('if');
                Future(() => ref.watch(positionProvider.notifier).setPosition = Position.fromMap(map));
              }
            } else {
              log('else');
              //initLocationDb(db);
              rebuild();
              //ref.watch(positionProvider.select((value) => value));
            }
          }

          /// ADD A BUTTON TO FETCH AND/OR REFRESH LOCATION
          /// attention:
          return buildPage(context, dp);
        });
  }

  /// HOME PAGE
  Widget buildPage(BuildContext context, Density dp) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: buildRow(context, _position, dp),
      ),

      0.03.dpH(dp).spY,

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
      Stack(
        children: [
          Center(
            child: Tooltip(
              message: 'Alert for self',
              child: AlertButton(
                height: 180,
                width: 176,
                borderWidth: 3,
                shadowWidth: 15,
                iconSize: 50,
                onPressed: () => launch(context, Constants.camera),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Tooltip(
                message: 'Alert for contacts',
                child: AlertButton(
                  height: 56,
                  width: 55,
                  borderWidth: 0,
                  shadowWidth: 0,
                  showSecondShadow: false,
                  iconSize: 20,
                  onPressed: () => signOut().then((value) => launch(context, Constants.authentication)) /*launch(context, Constants.subscription)*/,
                ),
              ),
            ),
          ),
        ],
      ),
      0.08.dpH(dp).spY,

      // 5
      GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => const HTMLDialog(
              htmlAsset1: 'assets/data/quickresponse_policies.html', // Path to your HTML asset file 1
              htmlAsset2: 'assets/data/quickresponse_terms.html', // Path to your HTML asset file 2
            ),
          );
        },
        child: Text(
          'Not sure what to do?',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColor.title),
        ),
      ),
      SizedBox(height: 0.03.dpH(dp)),
      // 6
      GestureDetector(
          onTap: () {
            getProfileInfoFromSharedPreferences().then(
              (profileInfo) => launch(context, Constants.chatsList, profileInfo.uid),
            );
          },
          child: Text('Pick the subject to chat', style: TextStyle(fontSize: 16, color: AppColor.text))),
      0.03.dpH(dp).spY,

      // 7
      FutureBuilder<List<EmergencyTip>>(
        future: _tips,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError || snapshot.data == null) {
              return const Center(
                child: Text('Error loading tips'),
              );
            }
            final tips = snapshot.data!;
            return SizedBox(
              width: double.infinity,
              height: 150,
              child: TipSlider(tips: tips),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),

      /*.12.dpH(dp).spaceY(ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            return const SuggestionCard(text: 'He had an accident');
          })),*/

      0.03.dpH(dp).spY,

      // 8
    ]);
  }

  void rebuild({dynamic action}) {
    if (action == null) {
      Future(() => setState(() {}));
    } else {
      Future(() => action);
    }
  }

  Future<void> initLocationDb(Database? db) async {
    await LocationDB(db).initialize();
  }

  Future<void> getLocationFromStorage(Database? db) async {
    _location = await LocationDB(db).getLocation().then((value) {
      log("Location: $value");
      return value;
    });
  }

  Future<void> getPlacemarks(Database? db) async {
    if (_position != null) {
      placemarks = await GeocodingPlatform.instance.placemarkFromCoordinates(_position!.latitude, _position!.longitude);
      getProfileInfoFromSharedPreferences().then(
        (profileInfo) => saveUserLocationToFirestore(
          profileInfo.uid!,
          _position!,
        ),
      );
      await LocationDB(db).updateLocation(_position!, placemarks!);
    }
  }

  /// TOP ROW
  Row buildRow(BuildContext context, Position? position, Density dp) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        buildImage(),
        const SizedBox(width: 5),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Hi Susan!', style: TextStyle(fontSize: 15, color: AppColor.text)),
          Row(children: [
            Text('Complete profile', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColor.action)),
            const SizedBox(width: 5),
            Icon(CupertinoIcons.check_mark_circled, size: 12, color: AppColor.action),
          ]),
        ])
      ]),
      GestureDetector(
        onTap: () {
          isLocationReady
              ? launch(context, Constants.locationMap)
              : setState(() {
                  mPage = buildPage(context, dp);
                });
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              mPage = buildStreamBuilder(dp);
            });
          });
        },
        child: Row(children: [
          Column(children: [
            BlinkingText(
              isLocationReady
                  ? placemarks == null
                      ? 'Loading...'
                      : '${placemarks!.first.name!}...'
                  : 'Tap to load',
              blink: isLocationReady ? true : false,
              style: TextStyle(
                fontSize: 15,
                color: isLocationReady
                    ? placemarks == null
                        ? Colors.amber
                        : Colors.green
                    : AppColor.text,
              ),
            ),
            Text(
              'See your location',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColor.action),
            ),
          ]),
          Icon(CupertinoIcons.location_solid, color: AppColor.action),
        ]),
      ),
    ]);
  }

  Widget buildImage() {
    return SizedBox(
      width: 32,
      height: 32,
      child: FutureBuilder<ProfileInfo?>(
        future: getProfileInfoFromSharedPreferences(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          if (user != null && user.photoURL != null) {
            return ClipOval(
              child: CachedNetworkImage(
                imageUrl: user.photoURL!,
                placeholder: (context, url) => buildIcon,
                errorWidget: (context, url, error) => Icon(CupertinoIcons.exclamationmark_triangle, color: AppColor.action),
              ),
            );
          } else {
            return buildIcon;
          }
        },
      ),
    );
  }

  Widget get buildIcon => const SizedBox();
}

class BottomSheetContent extends StatefulWidget {
  final String locationStatus;
  final String connectionStatus;

  const BottomSheetContent({
    super.key,
    required this.locationStatus,
    required this.connectionStatus,
  });

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Toast(widget.locationStatus, show: true, top: 20),
        Toast(widget.connectionStatus, show: true, top: 60),
      ],
    );
  }
}

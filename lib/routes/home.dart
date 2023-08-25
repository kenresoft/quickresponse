import 'dart:developer';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickresponse/data/constants/colors.dart';
import 'package:quickresponse/data/constants/constants.dart';
import 'package:quickresponse/data/constants/density.dart';
import 'package:quickresponse/data/db/location_db.dart';
import 'package:quickresponse/widgets/suggestion_card.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';
import '../providers/location_providers.dart';
import '../providers/page_provider.dart';
import '../widgets/alert_button.dart';
import '../widgets/blinking_text.dart';
import '../widgets/bottom_navigator.dart';
import '../widgets/exit_dialog.dart';
import '../widgets/toast.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  late GeolocatorPlatform _geolocator;
  Position? _position;
  List<Map>? _location;
  bool isLocationReady = false;
  List<Placemark>? placemarks;
  Widget mPage = const SizedBox();
  bool isAppLaunched = false;

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addObserver(this);
    Future(() => ref.watch(locationDbProvider.notifier).initialize());
    _geolocator = GeolocatorPlatform.instance;
    _geolocator.requestPermission().then((value) {
      if (value == LocationPermission.always || value == LocationPermission.whileInUse) {
        setState(() {});
      }
    });
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
    return WillPopScope(
      onWillPop: () async {
        bool isLastPage = page.isEmpty;
        if (isLastPage) {
          return (await showAnimatedDialog(context))!;
        } else {
          return true;
        }
      },
      child: Scaffold(
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
            Toast("The location service on the device is disabled!", show: !isLocationReady),
          ]),
        ),
        bottomNavigationBar: const BottomNavigator(currentIndex: 0),
      ),
    );
  }

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
      AlertButton(
        height: 190,
        width: 185,
        borderWidth: 3,
        shadowWidth: 15,
        iconSize: 45,
        onPressed: () => launch(context, Constants.camera),
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
      await LocationDB(db).updateLocation(_position!, placemarks!);
    }
  }

  /// TOP ROW
  Row buildRow(BuildContext context, Position? position, Density dp) {
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
          Icon(Icons.location_on_rounded, color: AppColor.action),
        ]),
      ),
    ]);
  }
}

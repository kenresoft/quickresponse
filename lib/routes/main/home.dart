import '../../main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<EmergencyTip>> _tips;

  //final LocationService _locationService = LocationService();
  late String _locationData;
  late String _streetAddress;
  bool _isPermissionDenied = false;

  //bool _isLocationUpdatesPaused = false;

  @override
  void initState() {
    super.initState();
    _tips = loadEmergencyTips();
    _locationData = 'Fetching location...';
    _streetAddress = 'Fetching address...';
    WidgetsBinding.instance.addObserver(this);
    _checkLocationPermission();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  void _checkLocationPermission() async {
    bool isPermissionDenied = false;
    await LocationService.startLocationUpdates(
      (position) async {
        setState(() {
          if (stopLocationUpdate) {
            _locationData = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
            _getAddressFromCoordinates(position.latitude, position.longitude);
            latitude = position.latitude;
            longitude = position.longitude;
          }
        });
      },
      (isDenied) {
        setState(() => isPermissionDenied = isDenied);
      },
    );

    setState(() => _isPermissionDenied = isPermissionDenied);
  }

  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() => _streetAddress = placemark.thoroughfare ?? 'Address not found');
      }
    } catch (e) {
      setState(() => _streetAddress = 'Address not found');
      'Error fetching address: $e'.log;
    }
  }

  // void _toggleLocationUpdates() {
  //   setState(() => isLocationUpdatesPaused = !isLocationUpdatesPaused);
  //
  //   if (isLocationUpdatesPaused) {
  //     _locationService.stopLocationUpdates();
  //   } else {
  //     _checkLocationPermission();
  //   }
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      'resumed'.log;
      if (stopLocationUpdate) {
        _checkLocationPermission();
      }
    } else if (state == AppLifecycleState.paused) {
      'paused'.log;
      // H: uncommenting this will automatically turn off the location updates when the page is paused
      //LocationService.stopLocationUpdates();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // H: uncommenting this will automatically turn off the location updates when the page is exited
    //LocationService.stopLocationUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    return WillPopScope(
      onWillPop: () async => (await showExitDialog(context, theme))!,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
        appBar: AppBar(toolbarHeight: 0),
        body: SingleChildScrollView(child: Center(child: buildPage(context, dp))),
        bottomNavigationBar: const BottomNavigator(currentIndex: 0),
      ),
    );
  }

  Widget buildPage(BuildContext context, Density dp) {
    return Column(children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: buildRow(context, dp)),

      0.015.dpH(dp).spY,

      condition(
        _isPermissionDenied,
        const Text('Location permission denied.', textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
        GestureDetector(
          onTap: () => launch(context, Constants.settings, SettingType.locationUpdate),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            condition(
              !stopLocationUpdate,
              const Text('Location Updates Paused:', style: TextStyle(color: Colors.red)),
              const Text('Location Updates Active:', style: TextStyle(color: Colors.green)),
            ),
            0.01.dpW(dp).spX,
            condition(
              !stopLocationUpdate,
              Text('Resume?', style: TextStyle(fontWeight: FontWeight.w900, color: AppColor(theme).title)),
              Text('Pause?', style: TextStyle(fontWeight: FontWeight.w900, color: AppColor(theme).title)),
            )
          ]),
        ),
      ),

      0.001.dpH(dp).spY,

      // 2
      0.7.dpW(dp).spaceX(Text('Emergency help needed?', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColor(theme).title), textAlign: TextAlign.center)),
      0.01.dpH(dp).spY,

      // 3
      Text('Just hold the button to call', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: AppColor(theme).text)),
      0.05.dpH(dp).spY,

      // 4
      Stack(children: [
        Center(
          child: Tooltip(
            message: 'Alert for self',
            child: AlertButton(
              height: 180,
              width: 175,
              borderWidth: 3,
              shadowWidth: 15,
              iconSize: 75,
              onPressed: () => conditionFunction(
                !isSignedIn(),
                () => _showSignInDialog,
                () {
                  conditionFunction(
                    customMessagesList.isNotEmpty,
                    () {
                      conditionFunction(sosMessage.isNotEmpty, () {
                        final newEmergencyAlert = EmergencyAlert.autoIncrement(
                          type: EmergencyAlert.getAlertTypeFromCustomMessage(sosMessage),
                          dateTime: DateTime.now(),
                          location: 'Latitude: $latitude, Longitude: $longitude',
                          details: 'From ${getProfileInfoFromSharedPreferences().displayName}',
                          customMessage: sosMessage,
                          hasLocationData: latitude != 0 && longitude != 0,
                        );

                        // H: SEND SOS FROM HERE

                        var alerts = emergencyAlerts;
                        alerts.add(newEmergencyAlert);
                        emergencyAlerts = alerts;

                        context.toast('Alert Delivered successfully!\nMESSAGE: "$sosMessage"', TextAlign.center, Colors.green.shade300);
                      }, () => context.toast('Default Message Not Selected!', TextAlign.center, Colors.orange.shade300));
                    },
                    () => context.toast('No Defined SOS Message!', TextAlign.center, Colors.red.shade300),
                  );
                },
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: FloatingActionButton(
              elevation: 0,
              shape: const CircleBorder(),
              backgroundColor: AppColor(theme).miniAlert,
              tooltip: 'Alert for contacts',
              onPressed: conditionFunction(!isSignedIn(), () => _showSignInDialog, () => _showSOSDialog),
              child: const Icon(CupertinoIcons.mail),
            ),
          ),
        ),
      ]),
      0.08.dpH(dp).spY,

      // 5
      GestureDetector(
          //onTap: () => setState(() => authenticate = !authenticate),
          child: Text('Not sure what to do?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColor(theme).title))),
      SizedBox(height: 0.03.dpH(dp)),
      // 6
      GestureDetector(
        onTap: () => launch(context, '/cgs'),
        //onTap: () => replace(context, authenticate ? Constants.authentication : Constants.home), // H: important for restart or so...
        child: Text('Pick the subject to chat', style: TextStyle(fontSize: 16, color: AppColor(theme).text)),
      ),
      0.03.dpH(dp).spY,

      // 7
      FutureBuilder<List<EmergencyTip>>(
        //future: _tips,
        future: loadEmergencyTips(),
        builder: (context, snapshot) {
          //if (snapshot.connectionState == ConnectionState.done) {}
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error loading tips: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final tips = snapshot.data!;
          return SizedBox(width: double.infinity, height: 155, child: TipSlider(tips: tips, action: () => setState(() {})));
        },
      ),

      0.03.dpH(dp).spY,

      // 8
    ]);
  }

  void _showSOSDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SOSDialog(
          sosMessages: customMessagesList,
          onMessageSelected: (message) {
            setState(() => sosMessage = message);
            // Here you can send the SOS message
          },
        );
      },
    );
  }

  void _showSignInDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => SignInDialog(action: () => setState(() {})),
    );
  }

  Row buildRow(BuildContext context, Density dp) {
    var user = getProfileInfoFromSharedPreferences();
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GestureDetector(
        onTap: () => conditionFunction(
          isButtonDisabled,
          () {},
          () => isSignedIn() ? replace(context, Constants.userProfilePage) : _showSignInDialog(),
        ),
        child: Row(children: [
          buildImage(user),
          const SizedBox(width: 5),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '${isSignedIn() ? 'Hi ${getFirstName(user.displayName)}' : 'Welcome'} !',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColor(theme).text),
            ),
            Row(children: [
              condition(
                isSignedIn(),
                condition(
                  user.isComplete,
                  const Text('Profile is completed!', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.green)),
                  Text('Complete your profile!', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColor(theme).action)),
                ),
                const Text('Sign In to continue', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              ),
              const SizedBox(width: 5),
              condition(
                isSignedIn(),
                condition(
                  user.isComplete,
                  Icon(CupertinoIcons.check_mark_circled, size: 12, color: AppColor(theme).action_2),
                  Icon(CupertinoIcons.xmark_circle, size: 12, color: AppColor(theme).action),
                ),
                Icon(CupertinoIcons.nosign, size: 12, color: AppColor(theme).action),
              )
            ]),
          ])
        ]),
      ),
      Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            if (_streetAddress != 'Fetching address...' && _streetAddress.isNotEmpty) launch(context, Constants.locationMap);
          },
          child: Row(children: [
            Column(children: [
              BlinkingText(trim(_streetAddress), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColor(theme).text)),
              const Text('See your location', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.green)),
            ]),
            const Icon(CupertinoIcons.location_solid, color: Colors.green, size: 13),
          ]),
        );
      }),
    ]);
  }
}

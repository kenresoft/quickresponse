import 'dart:ui';

import 'package:local_auth/local_auth.dart';
import 'package:quickresponse/main.dart';

import '../../widgets/display/color_mix.dart';

class DeviceAuthentication extends ConsumerStatefulWidget {
  const DeviceAuthentication({super.key});

  @override
  ConsumerState<DeviceAuthentication> createState() => _DeviceAuthenticationState();
}

class _DeviceAuthenticationState extends ConsumerState<DeviceAuthentication> {
  final LocalAuthentication auth = LocalAuthentication();
  bool isAuthenticating = false;
  bool isAuthenticated = false;
  bool authError = false;

  double _progressValue = 0.0;
  bool _showProgress = false;

  bool biometricOnly = true;

  void _startProgress() {
    setState(() {
      _showProgress = true;
    });
  }

  void _updateProgress(double value) {
    setState(() {
      _progressValue = value;
    });
  }

  void _stopProgress() {
    setState(() {
      _showProgress = false;
    });
  }

  Future<void> _delayedNavigation() async {
    _startProgress();
    final startTime = DateTime.now();
    const duration = Duration(seconds: 2);

    // Create a Tween animation for the progress indicator
    final Tween<double> tween = Tween(begin: 0.0, end: 1.0);

    // Use a periodic timer to update the progress value
    Timer.periodic(const Duration(milliseconds: 1), (Timer timer) {
      final currentTime = DateTime.now();
      final elapsedTime = currentTime.difference(startTime);

      if (elapsedTime >= duration) {
        // Stop the timer and progress when 3 seconds have passed
        timer.cancel();
        _stopProgress();
        // Navigate to the main app screen
        /*isSignedIn() ? */replace(context, Constants.home)/* : replace(context, Constants.signIn)*/;
      } else {
        // Update the progress value gradually
        final progress = elapsedTime.inMilliseconds / duration.inMilliseconds;
        _updateProgress(tween.transform(progress));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Check if biometrics are available on the device
    _checkBiometrics();
  }

  // Check if biometrics are available on the device
  void _checkBiometrics() {
    auth.canCheckBiometrics.then((canCheckBiometrics) {
      if (canCheckBiometrics) {
        // Biometrics are available, initiate authentication here
        context.toast('Device Biometrics are available');
        //_authenticate();
      } else {
        // Biometrics are not available, display a dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Biometrics Not Available'),
              content: const Text('Biometric authentication is not available on this device.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // You can provide an alternative authentication method here if needed.
                  },
                ),
              ],
            );
          },
        );
      }
    }).catchError((e) {
      // Handle any errors when checking biometrics availability
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(title: const Text('Error'), content: Text('Error checking biometrics availability: $e'), actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ]);
        },
      );
    });
  }

  Future<void> _authenticate() async {
    if (isAuthenticating || isAuthenticated) {
      return; // Avoid initiating authentication if it's already in progress or already authenticated
    }

    setState(() {
      authError = false;
      isAuthenticating = true;
      isAuthenticated = false;
    });

    try {
      auth
          .authenticate(
              localizedReason: ' ', // NOTE: Cannot be null or Empty else will throw an error
              options: AuthenticationOptions(useErrorDialogs: false, stickyAuth: true, sensitiveTransaction: true, biometricOnly: biometricOnly))
          .then((authenticated) {
        if (authenticated) {
          // Authentication successful, navigate to the main app screen
          setState(() {
            isAuthenticated = true;
          });
          // Start the progress indicator and delay navigation
          _delayedNavigation();
        } else {
          // Authentication failed, handle accordingly (e.g., show an error message)
          setState(() {
            authError = true;
          });
        }
      }).catchError((e) {
        // Handle any errors during authentication
        'Authentication error: $e'.log;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Authentication Error'),
              content: const Text('An error occurred during authentication. Please try again.'),
              actions: [
                TextButton(child: const Text('OK'), onPressed: () => Navigator.of(context).pop()),
              ],
            );
          },
        );
      });
    } finally {
      setState(() {
        isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    //final theme = ref.watch(themeProvider.select((value) => value));
    return Scaffold(
      backgroundColor: theme ? AppColor(theme).background : AppColor(theme).backgroundDark,
      appBar: CustomAppBar(
        title: const Text('Quick Response', style: TextStyle(fontSize: 20)),
        leading: Container(
          margin: const EdgeInsets.all(10),
          child: AppColor(theme).blend(const Image(image: ExactAssetImage(Constants.logo)), AppColor(theme).background),
        ),
        actionTitle: '',
        actionIcon: AppColor(theme).blend(const Icon(CupertinoIcons.padlock_solid), color(theme)),
        onActionClick: () {
          context.toast('Authenticate to access the app');
        },
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Card(
                elevation: 0,
                color: AppColor(theme).overlay,
                margin: EdgeInsets.symmetric(vertical: 0.15.dpH(dp), horizontal: 0.08.dpW(dp)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.08.dpH(dp), horizontal: 0.08.dpW(dp)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    BlinkingText(
                      'Security Pass',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, letterSpacing: 2, color: !theme ? AppColor(theme).white : AppColor(theme).black),
                    ),
                    const SizedBox(height: 70),
                    InkWell(
                      onTap: _authenticate,
                      child: ColorMix(
                        gradient: gradient,
                        child: const Icon(Icons.fingerprint, size: 120.0),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      isAuthenticated
                          ? '\nAuthentication\nSuccessful'
                          : authError
                              ? 'Authentication Failed!\nUnable to authenticate.\nPlease try again'
                              : '\nTap the fingerprint icon to authenticate',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: color(theme),
                      ),
                    ),
                    if (_showProgress) // Conditionally show the progress indicator
                      const SizedBox(height: 20),
                    if (_showProgress)
                      Container(
                        decoration: BoxDecoration(color: AppColor(theme).black, borderRadius: BorderRadius.circular(30)),
                        width: double.infinity,
                        height: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: LinearProgressIndicator(
                            value: _progressValue,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green), // Customize the progress color
                            backgroundColor: Colors.transparent, // Customize the background color
                          ),
                        ),
                      ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient get gradient => isAuthenticated
      ? AppColor(theme).authSuccess
      : authError
          ? AppColor(theme).authError
          : AppColor(theme).authDefault;

  Color color(bool theme) => isAuthenticated
      ? Colors.green
      : authError
          ? Colors.red
          : !theme
              ? AppColor(theme).white
              : AppColor(theme).black;
}

import 'dart:async';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontresoft/fontresoft.dart';
import 'package:go_router/go_router.dart';
import 'package:quickresponse/camera_screen.dart';
import 'package:quickresponse/data/constants/colors.dart';
import 'package:quickresponse/providers/providers.dart';
import 'package:quickresponse/routes/alarm.dart';
import 'package:quickresponse/routes/authentication.dart';
import 'package:quickresponse/routes/contact_details.dart';
import 'package:quickresponse/routes/contact_page.dart';
import 'package:quickresponse/routes/contacts.dart';
import 'package:quickresponse/routes/custom_messages.dart';
import 'package:quickresponse/routes/edit_contact_page.dart';
import 'package:quickresponse/routes/emergency_history.dart';
import 'package:quickresponse/routes/error.dart';
import 'package:quickresponse/routes/home.dart';
import 'package:quickresponse/routes/location_map.dart';
import 'package:quickresponse/routes/settings.dart';
import 'package:quickresponse/routes/subscription_page.dart';

import 'data/constants/constants.dart';
import 'data/db/database_client.dart';
import 'data/model/contact.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseClient();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColor.background,
      systemNavigationBarColor: AppColor.text,
      systemNavigationBarDividerColor: AppColor.divider,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then(appCallback);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        var state = ref.watch(themeProvider.select((value) => value));
        //log(state.toString());
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: Constants.appName,
          themeMode: condition(state, ThemeMode.light, ThemeMode.dark),
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: Colors.redAccent,
            fontFamily: FontResoft.sourceSansPro,
            package: FontResoft.package,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            typography: Typography.material2021(englishLike: Typography.dense2021),
            textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.redAccent,
            fontFamily: FontResoft.inter,
            package: FontResoft.package,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            textTheme: const TextTheme(bodyMedium: TextStyle()),
          ),
          routeInformationProvider: _router.routeInformationProvider,
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          shortcuts: {
            ...WidgetsApp.defaultShortcuts,
            const SingleActivator(LogicalKeyboardKey.select): const ActivateIntent(),
          },
          localizationsDelegates: const [],
        );
      },
    );
  }
}

final GoRouter _router = GoRouter(
  routes: <GoRoute>[
    route(Constants.root, const Home()),
    route(Constants.home, const Home()),
    route(Constants.camera, const CameraScreen()),
    route(Constants.contacts, const Contacts()),
    //route(Constants.contactDetails, const ContactDetails()),
    //route(Constants.editContactPage, const EditContactPage()),
    _route(Constants.contactDetails, (context, state) {
      final contact = state.extra as ContactModel; // Retrieve the contact data from extra
      return ContactDetails(contact: contact); // Pass the contact data to ContactDetails
    }),
    _route(Constants.editContactPage, (context, state) {
      final contact = state.extra as ContactModel; // Retrieve the contact data from extra
      return EditContactPage(contact: contact); // Pass the contact data to EditContactPage
    }),
    route(Constants.contactsPage, const ContactPage()),
    //route(Constants.call, const Call()),
    route(Constants.locationMap, const LocationMap()),
    route(Constants.alarm, const AlarmScreen()),
    route(Constants.message, const CustomMessageGeneratorPage()),
    route(Constants.history, const EmergencyHistoryPage()),
    route(Constants.settings, const SettingsPage()),
    route(Constants.subscription, const SubscriptionPage()),
    route(Constants.authentication, const Authentication()),
    //route(Constants.mapScreen, const MapScreen()),
    route(Constants.error, const ErrorPage()),
  ],
  errorBuilder: (context, state) => const ErrorPage(),
);

GoRoute route(String path, Widget route) {
  return routeTransition(path, route);
  /*return GoRoute(
    path: path,
    builder: (BuildContext context, GoRouterState state) => route,
  );*/
}

GoRoute _route(String path, Widget Function(BuildContext, GoRouterState)? builder) {
  //return routeTransition(path, route);
  return GoRoute(
    path: path,
    builder: (BuildContext context, GoRouterState state) => builder!(context, state),
  );
}

GoRoute routeTransition(String path, Widget route) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) => CustomTransitionPage(
      child: route,
      transitionsBuilder: (context, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOutBack),
        child: child,
      ),
      transitionDuration: const Duration(seconds: 1),
    ),
  );
}

launch(BuildContext context, String route, [Object? extra]) {
  GoRouter.of(context).push(route, extra: extra);
}

// Next Page without toolbar leading arrow
replace(BuildContext context, String route, [Object? extra]) {
  GoRouter.of(context).replace(route, extra: extra);
}

// Next Page with toolbar leading arrow
launchReplace(BuildContext context, String route, [Object? extra]) {
  GoRouter.of(context).pushReplacement(route, extra: extra);
}

finish(BuildContext context) => GoRouter.of(context).pop();

FutureOr appCallback(void value) async {
  //await Firebase.initializeApp();
  /*FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );*/
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/*
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);*/

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontresoft/fontresoft.dart';
import 'package:go_router/go_router.dart';
import 'package:quickresponse/providers/settings/time_format.dart';
import 'package:quickresponse/providers/settings/time_separator.dart';
import 'package:quickresponse/services/preference.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'data/constants/constants.dart';
import 'data/constants/styles.dart';
import 'data/db/database_client.dart';
import 'data/model/contact.dart';
import 'firebase_options.dart';
import 'providers/providers.dart';
import 'routes/authentication/device_authentication.dart';
import 'routes/authentication/sign_in.dart';
import 'routes/camera/camera_screen.dart';
import 'routes/chat/chat_list_screen.dart';
import 'routes/chat/chat_screen.dart';
import 'routes/chat/new_chat_screen.dart';
import 'routes/chat/user_search_screen.dart';
import 'routes/contact/contact_details.dart';
import 'routes/contact/contact_page.dart';
import 'routes/contact/contacts.dart';
import 'routes/contact/edit_contact_page.dart';
import 'routes/emergency/alarm.dart';
import 'routes/emergency/custom_messages.dart';
import 'routes/emergency/emergency_history.dart';
import 'routes/emergency/media_screen.dart';
import 'routes/emergency/reminder_page.dart';
import 'routes/emergency/travellers_alarm.dart';
import 'routes/main/error.dart';
import 'routes/main/home.dart';
import 'routes/main/settings.dart';
import 'routes/main/subscription_page.dart';
import 'routes/map/location_map.dart';
import 'services/notification_service.dart';
import 'widgets/display/notifications.dart';

final notificationService = NotificationService();
final providerContainer = ProviderContainer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  await SharedPreferencesService.init();
  tz.initializeTimeZones();

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/notification_icon'),
    ),
    onDidReceiveNotificationResponse: (notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (notificationResponse.payload != null) {
        debugPrint('notification payload: $payload');
      }

      if (payload == 'alarm') {
        notificationService.resetCounter(null);
      }
      //_router.push(Constants.travellersAlarm, extra: NotificationResponseModel(isMuted: true));
    },
  );

  DatabaseClient();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: appColor.background,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: appColor.text,
      systemNavigationBarDividerColor: appColor.divider,
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
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final dp = Density.init(context);
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        var state = ref.watch(themeProvider.select((value) => value));
        initAppPreferences(ref);

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
              textTheme: TextTheme(bodyMedium: TextStyle(color: appColor.title_2)),
              cardColor: Colors.white,
              dialogBackgroundColor: Colors.white,
              dividerColor: appColor.divider,
              //scaffoldBackgroundColor: appColor.background,
              //bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: appColor.white),
              appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent)),
          darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.redAccent,
              fontFamily: FontResoft.sourceSansPro,
              package: FontResoft.package,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              textTheme: TextTheme(bodyMedium: TextStyle(color: appColor.title_2)),
              cardColor: appColor.black,
              dialogBackgroundColor: appColor.black,
              dividerColor: appColor.divider,
              //scaffoldBackgroundColor: appColor.backgroundDark,
              appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent)),
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

  Future<void> initAppPreferences(WidgetRef ref) async {
    final bool theme = SharedPreferencesService.getBool('theme') ?? true;
    await Future(() => ref.watch(themeProvider.notifier).toggleTheme(theme));
    //ref.watch(timeFormatProvider.notifier).timeFormat;
    //timeFormat;
    //ref.watch(timeSeparatorProvider.notifier).timeSeparator;

  }
}

final GoRouter _router = GoRouter(
  /*redirect: (context, state) {
    bool isAuthenticated = isSignedIn();
    if (!isAuthenticated) {
      return Constants.authentication;
    }
    return null;
  },*/
  routes: <GoRoute>[
    route(Constants.root, const DeviceAuthentication()),
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

    _route(Constants.chat, (context, state) {
      final record = state.extra as (String, String, String); // Retrieve the contact data from extra
      return ChatScreen(chatId: record.$1, userId: record.$2, receiverId: record.$3); // Pass the contact data to EditContactPage
    }),

    _route(Constants.chatsList, (context, state) {
      final user = state.extra as String; // Retrieve the contact data from extra
      return ChatListScreen(userId: user); // Pass the contact data to EditContactPage
    }),

    _route(Constants.newChatsList, (context, state) {
      final user = state.extra as String; // Retrieve the contact data from extra
      return NewChatScreen(userId: user); // Pass the contact data to EditContactPage
    }),

    /*_route(Constants.travellersAlarm, (context, state) {
      final response = state.extra as NotificationResponseModel; // Retrieve the contact data from extra
      return TravellersAlarm(notificationResponse: response); // Pass the contact data to EditContactPage
    }),*/
    route(Constants.userSearchScreen, const UserSearchScreen()),
    route(Constants.contactsPage, const ContactPage()),
    //route(Constants.call, const Call()),
    route(Constants.locationMap, const LocationMap()),
    route(Constants.alarm, const AlarmScreen()),
    route(Constants.message, const CustomMessageGeneratorPage()),
    route(Constants.history, const EmergencyHistoryPage()),
    route(Constants.settings, const SettingsPage()),
    route(Constants.subscription, const SubscriptionPage()),
    route(Constants.authentication, const DeviceAuthentication()),
    route(Constants.signIn, const SignIn()),
    route(Constants.reminderPage, const ReminderPage()),
    route(Constants.travellersAlarm, const TravellersAlarm()),
    route(Constants.media, const MediaScreen()),

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
  runApp(
    ProviderScope(
      parent: providerContainer,
      child: const MyApp(),
    ),
  );
}

import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:quickresponse/routes/contact/edit_contact_page.dart';
import 'package:quickresponse/routes/main/hero_page.dart';
import 'package:quickresponse/routes/user/faq.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'imports.dart';

export 'imports.dart';

// final notificationService = NotificationService();

int id = 0;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream = StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();

const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = 'notification_send_port';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print('notification action tapped with input: ${notificationResponse.input}');
  }
}

/// IMPORTANT: running the following code on its own won't work as there is
/// setup required for each platform head project.
///

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
  if (!kIsWeb) {
    await BackgroundService.init();
  }

/*  initializeTimeZones();

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
  );*/

  await _configureLocalTimeZone();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb && Platform.isLinux ? null : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  //String initialRoute = Home.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails!.notificationResponse?.payload;
    //initialRoute = SecondPage.routeName;
  }

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/notification_icon');

  final List<DarwinNotificationCategory> darwinNotificationCategories = <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
    notificationCategories: darwinNotificationCategories,
  );
  final LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(
    defaultActionName: 'Open notification',
    defaultIcon: AssetsLinuxIcon('@mipmap/notification_icon'),
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  DatabaseClient();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      //statusBarColor: AppColor(theme).background,
      systemNavigationBarColor: AppColor(theme).text,
      systemNavigationBarDividerColor: AppColor(theme).divider,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((value) => appCallback());
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.notificationAppLaunchDetails});

  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      themeMode: condition(theme, ThemeMode.light, ThemeMode.dark),
      theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: Colors.redAccent,
          fontFamily: FontResoft.sourceSansPro,
          package: FontResoft.package,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          typography: Typography.material2021(englishLike: Typography.dense2021),
          //textTheme: TextTheme(bodyMedium: TextStyle(color: AppColor(theme).title_2)),
          cardColor: Colors.white,
          dialogBackgroundColor: Colors.white,
          dividerColor: AppColor(theme).divider),
      darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.redAccent,
          fontFamily: FontResoft.sourceSansPro,
          package: FontResoft.package,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          //textTheme: TextTheme(bodyMedium: TextStyle(color: AppColor(theme).title_2)),
          cardColor: AppColor(theme).black,
          dialogBackgroundColor: AppColor(theme).black,
          dividerColor: AppColor(theme).divider),
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      shortcuts: {
        ...WidgetsApp.defaultShortcuts,
        const SingleActivator(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      localizationsDelegates: const [],
    );
  }

  final GoRouter _router = GoRouter(
    redirect: (context, state) {
      bool isAuthenticated = isSignedIn();
      if (!isAuthenticated) {
        if (authenticate) {
          return Constants.authentication;
        }
        return Constants.home;
      }
      return null;
    },
    routes: <GoRoute>[
      route(Constants.root, authenticate ? const DeviceAuthentication() : const Home()),
      route(Constants.home, const Home()),
      route(Constants.camera, const CameraScreen()),
      route(Constants.contacts, const Contacts()),

      /*_route(Constants.home, (context, state) {
        final notificationAppLaunchDetails = state.extra as NotificationAppLaunchDetails;
        return Home(notificationAppLaunchDetails: notificationAppLaunchDetails);
      }),*/

      _route(Constants.editContactPage, (context, state) {
        final contact = state.extra as ContactModel;
        return EditContactPage(contact: contact);
      }),

      _route(Constants.settings, (context, state) {
        final type = state.extra as SettingType?;
        return SettingsPage(() => runApp(const ProviderScope(child: MyApp())), settingType: type ?? SettingType.none);
      }),

      _route('/m', (context, state) {
        final record = state.extra as (String, String);
        return GroupMembersScreen(groupId: record.$1, currentUserId: record.$2);
      }),

      _route(Constants.heroPage, (context, state) {
        final tip = state.extra as EmergencyTip;
        return HeroPage(tip: tip);
      }),

      route(Constants.contactsPage, const ContactPage()),
      //route(Constants.call, const Call()),
      route(Constants.locationMap, const LocationMap()),
      route(Constants.alarm, const AlarmScreen()),
      route(Constants.message, const CustomMessageGeneratorPage()),
      route(Constants.history, const EmergencyHistoryPage()),
      route(Constants.subscription, const SubscriptionPage()),
      route(Constants.authentication, const DeviceAuthentication()),
      route(Constants.signIn, const SignIn()),
      route(Constants.reminderPage, const ReminderPage()),
      route(Constants.travellersAlarm, const Emergency()),
      route(Constants.media, const MediaScreen()),
      route(Constants.userProfilePage, const UserProfilePage()),
      route(Constants.faq, const FAQScreen()),
      route('/cgs', CreateGroupScreen()),
      route('/cs', const GroupsScreen()),
      //route('cg', const GroupChatScreen(group: group)),
      route(Constants.error, const ErrorPage()),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
  );
}

GoRoute route(String path, Widget route) {
  return routeTransition(path, route);
  /*return GoRoute(
    path: path,
    builder: (BuildContext context, GoRouterState state) => route,
  );*/
}

GoRoute _route(String path, Widget Function(BuildContext, GoRouterState)? builder) {
  return _routeTransition(path, builder);
  /*return GoRoute(
    path: path,
    builder: (BuildContext context, GoRouterState state) => builder!(context, state),
  );*/
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

GoRoute _routeTransition(String path, Widget Function(BuildContext, GoRouterState)? builder) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) => CustomTransitionPage(
      child: builder!(context, state),
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

FutureOr appCallback() async {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

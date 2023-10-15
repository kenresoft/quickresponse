import 'imports.dart';

export 'imports.dart';

final notificationService = NotificationService();

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
  await BackgroundService.init();
  initializeTimeZones();

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
      statusBarColor: AppColor(theme).background,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColor(theme).text,
      systemNavigationBarDividerColor: AppColor(theme).divider,
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
    Future(() => setState(() => theme = theme));

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
          textTheme: TextTheme(bodyMedium: TextStyle(color: AppColor(theme).title_2)),
          cardColor: Colors.white,
          dialogBackgroundColor: Colors.white,
          dividerColor: AppColor(theme).divider,
          //scaffoldBackgroundColor: AppColor(theme).background,
          //bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: AppColor(theme).white),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent)),
      darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.redAccent,
          fontFamily: FontResoft.sourceSansPro,
          package: FontResoft.package,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          textTheme: TextTheme(bodyMedium: TextStyle(color: AppColor(theme).title_2)),
          cardColor: AppColor(theme).black,
          dialogBackgroundColor: AppColor(theme).black,
          dividerColor: AppColor(theme).divider,
          //scaffoldBackgroundColor: AppColor(theme).backgroundDark,
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
  }

/*  Future<void> initAppPreferences() async {
    theme = theme;
    //final bool theme = SharedPreferencesService.getBool('theme') ?? true;
    //await Future(() => ref.watch(themeProvider.notifier).toggleTheme(theme));
    //ref.watch(timeFormatProvider.notifier).timeFormat;
    //timeFormat;
    //ref.watch(timeSeparatorProvider.notifier).timeSeparator;
  }*/
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
    route(Constants.root, authenticate ? const DeviceAuthentication() : const Home()),
    route(Constants.home, const Home()),
    route(Constants.camera, const CameraScreen()),
    route(Constants.contacts, const Contacts()),
    //route(Constants.contactDetails, const ContactDetails()),
    //route(Constants.editContactPage, const EditContactPage()),
    _route(Constants.contactDetails, (context, state) {
      final contact = state.extra as ContactModel;
      return ContactDetails(contact: contact); // Pass the contact data to ContactDetails
    }),
    _route(Constants.editContactPage, (context, state) {
      final contact = state.extra as ContactModel;
      return EditContactPage(contact: contact);
    }),

    _route(Constants.chat, (context, state) {
      final record = state.extra as (String, String, String);
      return ChatScreen(chatId: record.$1, userId: record.$2, receiverId: record.$3);
    }),

    _route(Constants.chatsList, (context, state) {
      final user = state.extra as String;
      return ChatListScreen(userId: user);
    }),

    _route(Constants.newChatsList, (context, state) {
      final user = state.extra as String;
      return NewChatScreen(userId: user);
    }),

    _route(Constants.settings, (context, state) {
      final type = state.extra as SettingType?;
      return SettingsPage(settingType: type ?? SettingType.none);
    }),

    _route('/m', (context, state) {
      final record = state.extra as (String, String);
      return GroupMembersScreen(groupId: record.$1, currentUserId: record.$2);
    }),

    /*_route(Constants.travellersAlarm, (context, state) {
      final response = state.extra as NotificationResponseModel;
      return TravellersAlarm(notificationResponse: response);
    }),*/
    route(Constants.userSearchScreen, const UserSearchScreen()),
    route(Constants.contactsPage, const ContactPage()),
    //route(Constants.call, const Call()),
    route(Constants.locationMap, const LocationMap()),
    route(Constants.alarm, const AlarmScreen()),
    route(Constants.message, const CustomMessageGeneratorPage()),
    route(Constants.history, const EmergencyHistoryPage()),
    //route(Constants.settings, const SettingsPage()),
    route(Constants.subscription, const SubscriptionPage()),
    route(Constants.authentication, const DeviceAuthentication()),
    route(Constants.signIn, const SignIn()),
    route(Constants.reminderPage, const ReminderPage()),
    route(Constants.travellersAlarm, const Emergency()),
    route(Constants.media, const MediaScreen()),
    route(Constants.userProfilePage, const UserProfilePage()),

    route('/cgs', CreateGroupScreen()),
    route('/cs', const GroupsScreen()),
    //route('cg', const GroupChatScreen(group: group)),

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
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

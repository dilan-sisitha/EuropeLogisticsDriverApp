import 'dart:async';
import 'dart:io';
import 'package:euex/components/cons.dart';
import 'package:euex/config/environment.dart';
import 'package:euex/database/hivedb.dart';
import 'package:euex/database/sqlLitedb.dart';
import 'package:euex/helpers/firebaseAuthUser.dart';
import 'package:euex/providers/TimerServiceProvider.dart';
import 'package:euex/providers/authProvider.dart';
import 'package:euex/providers/chatDataProvider.dart';
import 'package:euex/providers/currentOrderDataProvider.dart';
import 'package:euex/providers/gpsStatusProvider.dart';
import 'package:euex/providers/networkConnectivityProvider.dart';
import 'package:euex/routes/routeGenerator.dart';
import 'package:euex/screens/chat/chatPage.dart';
import 'package:euex/screens/home/home.dart';
import 'package:euex/screens/login/login.dart';
import 'package:euex/services/chatService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';
import 'services/schedularService.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    Map<String, dynamic> data = message.data;
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'live_chat',
      'live chat notification',
      channelDescription: 'display incoming chat messages',
      importance: Importance.max,
      priority: Priority.high,
    );
    const DarwinNotificationDetails iosNotificationDetails =
    DarwinNotificationDetails(
      threadIdentifier: "live_chat",
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.cancel(0);
    await flutterLocalNotificationsPlugin.show(
      0,
      data['title'],
      data['body'],
      platformChannelSpecifics,
    );
  }
}

isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('auth_token');
  return token != null;
}

void callbackDispatcher() async {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case 'update_time':
        {
          try {
            await SchedulerService().updateFailedOrdersTime();
            return Future.value(true);
          } catch (e, stackTrace) {
            return Future.error(e, stackTrace);
          }
        }
    }
    return Future.value(true);
  });
}

initialMessageStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final bool? initLoadStatus = prefs.getBool('init_load');
  final bool? initMessageAcceptStatus = prefs.getBool('init_message');
  return {
    'initLoad': initLoadStatus ?? true,
    'initMessage': initMessageAcceptStatus ?? false
  };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  /**
   *  change app environment according to the deployment instance Env.development or Env.production
   */
  await Environment().initConfig(Env.development);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
  await HiveDatabase().initDataTables();
  HttpOverrides.global = MyHttpOverrides();
  bool loginStatus = await isLoggedIn();
  Map initMessage = await initialMessageStatus();
  await SqlLiteDb().initDatabase();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  SchedulerService().registerFailedOrderUpdateCron();
  bool launchChat = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    launchChat = true;
  }
  runApp(MyApp(
    loggedInStatus: loginStatus,
    initMessage: initMessage,
    launchChat: launchChat,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp(
      {Key? key,
      required this.loggedInStatus,
      required this.initMessage,
      required this.launchChat})
      : super(key: key);
  final bool loggedInStatus;
  final Map initMessage;
  final bool launchChat;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => NetworkConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => TimerDataProvider()),
        ChangeNotifierProvider(create: (context) => CurrentOrderDataProvider()),
        ChangeNotifierProvider(create: (context) => GpsStatusProvider()),
        ChangeNotifierProvider(create: (context) => ChatDataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Europe Express App',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        /*supportedLocales: const [
          Locale('en') , Locale('pl')
        ],*/
        theme: ThemeData(
          primaryColor: bPrimaryColor,
          scaffoldBackgroundColor: whiteColor,
          fontFamily: 'openSans',
        ),
        initialRoute: '/',
        navigatorKey: navigatorKey,
        onGenerateRoute: RouteGenerator.generateRoute,
        home: StartScreen(
          navigatorKey: navigatorKey,
          loginStatus: widget.loggedInStatus,
          initMessage: widget.initMessage,
          launchChat: widget.launchChat,
        ),
      ),
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen(
      {this.navigatorKey,
      required this.initMessage,
      required this.launchChat,
      Key? key,
      required this.loginStatus})
      : super(key: key);
  final navigatorKey;
  final bool loginStatus;
  final bool isFirstTime = true;
  final Map initMessage;
  final bool launchChat;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Provider.of<AuthProvider>(context, listen: false).navigationKey =
          widget.navigatorKey;
    });
    if (widget.loginStatus) {
      Future.delayed(Duration.zero, () async {
        AuthProvider().automaticLogOut(context);
        ChatService().onReceiveNewMessage(context, widget.navigatorKey);
        await FirebaseAuthUser().checkCurrentUserState();
      });
      if (widget.launchChat) {
        ChatService().updateInbox(widget.navigatorKey);
        return const ChatPage(launchedWithNotification: true,);
      }
      return const Home();
    }
    if (widget.initMessage['initLoad'] && !widget.initMessage['initMessage']) {
      return AlertDialog(
        scrollable: true,
        elevation: 2.0,
        title: Text(AppLocalizations.of(context)!.backgroundLocationAccess),
        content: Text(AppLocalizations.of(context)!.initInfoMessage),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.proceed),
            onPressed: () async {
              await FirebaseAuthUser().signOut();
              final pref = await SharedPreferences.getInstance();
              pref.setBool('init_load', false);
              pref.setBool('init_message', true);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () async {
              final pref = await SharedPreferences.getInstance();
              pref.setBool('init_message', false);
              SystemNavigator.pop();
            },
          )
        ],
      );
    } else {
      return LoginScreen(navigatorKey: widget.navigatorKey,);
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:strangify/providers/user_provider.dart';
import 'package:strangify/screens/splash_screen.dart';

import 'constants.dart';
import 'helpers/routes.dart';
import 'providers/settings_provider.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late AndroidNotificationChannel channel;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              icon: '@drawable/ic_notification'),
        ),
        payload: message.notification!.android!.link.toString());
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final gsheets = GSheets(gsheetCredentials);

  var spreadsheetRef =
      await gsheets.spreadsheet("1p6opsFPGCrWtYJMiqDzyl887tKEUzdzbdwz-uZ3o0_g");
  print(spreadsheetRef.url);
  worksheet = spreadsheetRef.worksheetByTitle(
      "${DateTime.now().day > 15 ? 16 : 1}-${DateTime.now().month}-${DateTime.now().year}");
  worksheet ??= await spreadsheetRef.addWorksheet(
      "${DateTime.now().day > 15 ? 16 : 1}-${DateTime.now().month}-${DateTime.now().year}");
  print(worksheet?.title);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      // notificationUrl = message.notification!.android!.link.toString();
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              icon: '@drawable/ic_notification'),
        ),
        payload: message.notification!.android!.link.toString());
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) async {
    // await urlHelper(event.notification!.android!.link.toString());
  });

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
        'high_importance_channel', 'App Notifications',
        description: 'This channel is used for app notifications.',
        importance: Importance.high);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');
//Initialization Settings for iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false);

    // selectNotification(String? payload) {
    //   //  urlHelper(payload.toString());
    // }

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const int blackPrimaryValue = 0xFF000000;
  static const MaterialColor primaryBlack = MaterialColor(
    blackPrimaryValue,
    <int, Color>{
      50: Color(0xFF080808),
      100: Color(0xFF080808),
      200: Color(0xFF080808),
      300: Color(0xFF080808),
      400: Color(0xFF080808),
      500: Color(blackPrimaryValue),
      600: Color(0xFF080808),
      700: Color(0xFF080808),
      800: Color(0xFF080808),
      900: Color(0xFF080808)
    },
  );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => SettingsProvider(),
          ),
        ],
        child: MaterialApp(
            title: 'Strangify',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: primaryBlack),
            home: const SplashScreen(),
            onGenerateRoute: RouteGenerator.onGenerateRoute));
  }
}

// Session status
// 1. waiting
// 2. active
// 3. done
// 4. cancelled
// 5. rejected
// 6. expired
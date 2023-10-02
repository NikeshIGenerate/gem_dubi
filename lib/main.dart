import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/common/constants.dart';
import 'package:gem_dubi/common/models/local_notification.dart';
import 'package:gem_dubi/common/screens/splash_screen.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:gem_dubi/common/utils/local_db.dart';
import 'package:gem_dubi/common/utils/theme.dart';
import 'package:gem_dubi/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalDatabaseProvider.initDB();
  print('Handling a background message ${message.messageId}');
  print(message);
  print(message.notification);
  print(message.data.toString());
  print(message.notification?.android);
  RemoteNotification? notification = message.notification;
  await LocalDatabaseProvider.insertNotification(
    LocalNotification(
      id: notification.hashCode,
      title: notification!.title!,
      body: notification.body!,
      createdAt: DateTime.now(),
    ),
  );
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel!);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    LocalDatabaseProvider.initDB();
    signInUsingEmailPassword();
    var initializationSettingAndroid = const AndroidInitializationSettings('@drawable/ic_stat_name');
    var initializationSettingIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) {
          print('Id: $id');
          print('title: $title');
          print('body: $body');
          print('payload: $payload');
        });
    var initializeSettings = InitializationSettings(
      android: initializationSettingAndroid,
      iOS: initializationSettingIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializeSettings);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      Map<String, dynamic>? data = message.data;
      print('onMessageOpenApp: ${data}');
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('onMessage() called');
      print(message);
      print(message.notification);
      print(message.data.toString());
      print(message.notification?.android);
      RemoteNotification? notification = message.notification;
      await LocalDatabaseProvider.insertNotification(
        LocalNotification(
          id: notification.hashCode,
          title: notification!.title!,
          body: notification.body!,
          createdAt: DateTime.now(),
        ),
      );
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              // icon: 'app_logo',
              color: Colors.black,
              sound: channel.sound,
              playSound: true,
              priority: Priority.high,
              importance: Importance.high,
              largeIcon: const DrawableResourceAndroidBitmap('@drawable/launcher_icon'),
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GEM Dubai',
      navigatorKey: router.key,
      theme: themeData,
      darkTheme: darkThemeData,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }

  static Future<void> signInUsingEmailPassword() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: kFirebaseEmail,
        password: kFirebasePassword,
      );
      print('SUCCESSFULLY SIGNIN ${userCredential.user}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }
  }
}

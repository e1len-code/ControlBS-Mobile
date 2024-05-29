import 'package:controlbs_mobile/core/constants/color_schemes.g.dart';
import 'package:controlbs_mobile/core/config/valueListenables/theme_stuff.dart';
import 'package:controlbs_mobile/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:controlbs_mobile/features/file/presentation/provider/file_provider.dart';
import 'package:controlbs_mobile/injections.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'injections.dart' as di;
import 'core/routes/go_router.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

AndroidNotificationChannel? channel;

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
late FirebaseMessaging messaging;

void notificationTapBackground(NotificationResponse notificationResponse) {
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  //If subscribe based sent notification then use this token
  final fcmToken = await messaging.getToken();
  print(fcmToken);

  //If subscribe based on topic then use this
  await messaging.subscribeToTopic('all');

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
        'flutter_notification', // id
        'flutter_notification_title', // title
        importance: Importance.high,
        enableLights: true,
        enableVibration: true,
        showBadge: true,
        playSound: true);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = DarwinInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin!.initialize(initSettings,
        onDidReceiveNotificationResponse: notificationTapBackground,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground);

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  await di.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<AttendanceProvider>()),
    ChangeNotifierProvider(create: (_) => getIt<FileProvider>())
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    ThemeData dark = ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      fontFamily: GoogleFonts.lato().fontFamily,
    );
    ThemeData light = ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      fontFamily: GoogleFonts.lato().fontFamily,
    );

    ThemeStuff appValueNotifier = ThemeStuff.instance();

    return ValueListenableBuilder(
      valueListenable: appValueNotifier.theme,
      builder: (context, value, child) {
        return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            themeMode: value,
            theme: light,
            darkTheme: dark,
            routerConfig: router);
      },
    );
  }
}

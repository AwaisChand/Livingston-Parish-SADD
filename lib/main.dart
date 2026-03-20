import 'package:dp_sad/res/notification_service.dart';
import 'package:dp_sad/res/providers.dart';
import 'package:dp_sad/view_model/auth_view_model/auth_view_model.dart';
import 'package:dp_sad/Screens/HomeScreen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// ✅ Background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Background message: ${message.notification?.title}");
}

/// ✅ Request permission
Future<void> _requestNotificationPermission() async {
  NotificationSettings settings =
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('🔔 Permission: ${settings.authorizationStatus}');
}

/// ✅ Setup listeners
void _setupFirebaseMessageListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('💬 Foreground message: ${message.notification?.title}');

    if (message.notification != null) {
      NotificationService.showNotification(
        title: message.notification!.title ?? 'No Title',
        body: message.notification!.body ?? 'No Body',
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('📲 Notification clicked: ${message.notification?.title}');
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// ✅ Background handler
  FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler);

  /// ✅ Init local notifications
  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
  InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  /// ✅ CREATE CHANNEL (IMPORTANT)
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'login_channel',
    'Login Notifications',
    description: 'Notifications for login',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// ✅ Permission
  await _requestNotificationPermission();

  /// ✅ GET TOKEN (IMPORTANT)
  String? token = await FirebaseMessaging.instance.getToken();
  print("🔥 FCM TOKEN: $token");

  /// ✅ Setup listeners
  _setupFirebaseMessageListeners();

  final authVM = AuthViewModel();
  await authVM.initUser();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(MyApp(authVM: authVM));
}

class MyApp extends StatelessWidget {
  final AuthViewModel authVM;
  const MyApp({super.key, required this.authVM});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(value: authVM),
        ...providers.where(
              (p) => !(p is ChangeNotifierProvider<AuthViewModel>),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LPSADD',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
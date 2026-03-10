import 'package:dp_sad/Screens/HomeScreen/home_screen.dart';
import 'package:dp_sad/res/notification_service.dart';
import 'package:dp_sad/res/providers.dart';
import 'package:dp_sad/view_model/auth_view_model/auth_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// ✅ Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Background message received: ${message.notification?.title}");
}

/// ✅ Request user permission for notifications
Future<void> _requestNotificationPermission() async {
  NotificationSettings settings = await FirebaseMessaging.instance
      .requestPermission(alert: true, badge: true, sound: true);
  print('🔔 Notification permission status: ${settings.authorizationStatus}');
}

/// ✅ Listen for foreground + background messages
void _setupFirebaseMessageListeners() {
  // Foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('💬 Foreground message: ${message.notification?.title}');
    if (message.notification != null) {
      NotificationService.showNotification(
        title: message.notification?.title ?? 'No Title',
        body: message.notification?.body ?? 'No Body',
      );
    }
  });

  // When user taps a notification and app opens
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('📲 Notification opened app: ${message.notification?.title}');
    // You can navigate to a specific screen here if needed
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final authVM = AuthViewModel();
  await authVM.initUser();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await _requestNotificationPermission();
  _setupFirebaseMessageListeners();

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
        ...providers.where((p) => p is! ChangeNotifierProvider<AuthViewModel>),
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

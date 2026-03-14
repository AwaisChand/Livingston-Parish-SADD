import 'package:dp_sad/Screens/HomeScreen/home_screen.dart';
import 'package:dp_sad/res/notification_service.dart';
import 'package:dp_sad/res/providers.dart';
import 'package:dp_sad/view_model/auth_view_model/auth_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    debugPrint('Background message received: ${message.notification?.title}');
  }
}

/// Request user permission for notifications (non-blocking)
Future<void> _requestNotificationPermission() async {
  try {
    final NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);
    if (kDebugMode) {
      debugPrint('Notification permission: ${settings.authorizationStatus}');
    }
  } catch (e) {
    if (kDebugMode) debugPrint('Notification permission error: $e');
  }
}

/// Listen for foreground + background messages
void _setupFirebaseMessageListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      NotificationService.showNotification(
        title: message.notification!.title ?? 'No Title',
        body: message.notification!.body ?? 'No Body',
      );
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (kDebugMode) {
      debugPrint('Notification opened app: ${message.notification?.title}');
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AuthViewModel authVM;
  try {
    await Firebase.initializeApp();
  } catch (e, st) {
    if (kDebugMode) {
      debugPrint('Firebase init error: $e');
      debugPrint('$st');
    }
    authVM = AuthViewModel();
    runApp(MyApp(authVM: authVM));
    return;
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  authVM = AuthViewModel();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
        requestAlertPermission: false,
        requestSoundPermission: false,
        requestBadgePermission: false,
      );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  try {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  } catch (e) {
    if (kDebugMode) debugPrint('Local notifications init error: $e');
  }

  _setupFirebaseMessageListeners();

  runApp(MyApp(authVM: authVM));

  _runAfterFirstFrame(() async {
    await authVM.initUser();
    await _requestNotificationPermission();
  });
}

void _runAfterFirstFrame(void Function() callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
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

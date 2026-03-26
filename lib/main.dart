import 'package:dp_sad/Screens/HomeScreen/home_screen.dart';
import 'package:dp_sad/core/notifications/notification_service.dart';
import 'package:dp_sad/firebase_options.dart';
import 'package:dp_sad/res/providers.dart';
import 'package:dp_sad/view_model/auth_view_model/auth_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationService.instance.initialize(
    onNavigateFromNotification: (data) {},
  );

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

class MyApp extends StatefulWidget {
  final AuthViewModel authVM;
  const MyApp({super.key, required this.authVM});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    NotificationService.instance.requestPermissions();
    NotificationService.instance.debugPrintCurrentState();
    NotificationService.instance.wireMessageHandlers(
      onNavigateFromNotification: _handleNotificationNavigation,
    );
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    debugPrint('Notification tapped with data: $data');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(value: widget.authVM),
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

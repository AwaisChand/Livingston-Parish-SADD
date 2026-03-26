import 'dart:convert';

import 'package:dp_sad/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint(
    '[FCM][BG] messageId=${message.messageId} '
    'title=${message.notification?.title} '
    'body=${message.notification?.body} '
    'data=${message.data}',
  );
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important alerts',
    importance: Importance.max,
  );

  Future<void> initialize({
    required void Function(Map<String, dynamic> data)
    onNavigateFromNotification,
  }) async {
    debugPrint('[FCM][INIT] Initializing local notifications');
    const androidInit = AndroidInitializationSettings(
      '@drawable/ic_stat_notification',
    );
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      defaultPresentBanner: true,
      defaultPresentList: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint(
          '[FCM][LOCAL_TAP] actionId=${response.actionId} '
          'payload=${response.payload}',
        );
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        try {
          final data = jsonDecode(payload) as Map<String, dynamic>;
          onNavigateFromNotification(data);
        } catch (_) {
          debugPrint('Invalid local notification payload: $payload');
        }
      },
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTap,
    );
    debugPrint('[FCM][INIT] Local notifications initialized');

    final androidImpl =
        _local
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidImpl?.createNotificationChannel(_channel);
    debugPrint('[FCM][INIT] Android channel created: ${_channel.id}');
  }

  Future<void> requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('[FCM][PERMISSION] status=${settings.authorizationStatus}');

    final androidImpl =
        _local
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    final granted = await androidImpl?.requestNotificationsPermission();
    debugPrint('[FCM][ANDROID_PERMISSION] granted=$granted');
  }

  Future<void> wireMessageHandlers({
    required void Function(Map<String, dynamic> data)
    onNavigateFromNotification,
  }) async {
    debugPrint('[FCM][WIRE] Binding message handlers');
    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint(
        '[FCM][FG] messageId=${message.messageId} '
        'title=${message.notification?.title} '
        'body=${message.notification?.body} '
        'data=${message.data}',
      );
      await showRemoteMessageAsLocal(message);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
        '[FCM][INITIAL_MESSAGE] messageId=${initialMessage.messageId} '
        'data=${initialMessage.data}',
      );
      onNavigateFromNotification(initialMessage.data);
    } else {
      debugPrint('[FCM][INITIAL_MESSAGE] none');
    }

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint(
        '[FCM][OPENED_APP] messageId=${message.messageId} '
        'data=${message.data}',
      );
      onNavigateFromNotification(message.data);
    });

    final details = await _local.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      debugPrint(
        '[FCM][LOCAL_LAUNCH] didLaunch=true payload='
        '${details?.notificationResponse?.payload}',
      );
      final payload = details!.notificationResponse?.payload;
      if (payload != null && payload.isNotEmpty) {
        try {
          final data = jsonDecode(payload) as Map<String, dynamic>;
          onNavigateFromNotification(data);
        } catch (_) {
          debugPrint('Invalid launch payload: $payload');
        }
      }
    } else {
      debugPrint('[FCM][LOCAL_LAUNCH] didLaunch=false');
    }
  }

  Future<void> showRemoteMessageAsLocal(RemoteMessage message) async {
    final data = message.data;
    final title =
        message.notification?.title ??
        data['title']?.toString() ??
        'Notification';
    final body =
        message.notification?.body ?? data['body']?.toString() ?? 'New message';

    final android = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      visibility: NotificationVisibility.public,
    );

    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(android: android, iOS: ios);
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    debugPrint(
      '[FCM][LOCAL_SHOW] id=$id title="$title" body="$body" payload=$data',
    );
    await _local.show(id, title, body, details, payload: jsonEncode(data));
  }

  Future<String?> getFcmToken() async {
    final token = await _messaging.getToken();
    debugPrint('[FCM][TOKEN] $token');
    return token;
  }

  Future<void> debugPrintCurrentState() async {
    final settings = await _messaging.getNotificationSettings();
    debugPrint('[FCM][STATE] permission=${settings.authorizationStatus}');
    try {
      final apnsToken = await _messaging.getAPNSToken();
      debugPrint('[FCM][STATE] apnsToken=$apnsToken');
    } catch (e) {
      debugPrint('[FCM][STATE] apnsTokenError=$e');
    }
    final token = await _messaging.getToken();
    debugPrint('[FCM][STATE] fcmToken=$token');
  }
}

@pragma('vm:entry-point')
void _onBackgroundNotificationTap(NotificationResponse response) {
  debugPrint('Background local notification tap payload: ${response.payload}');
}

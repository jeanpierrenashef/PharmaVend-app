import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// make sure app is still running in bg
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseApi.instance.setupFlutterNotifications();
  await FirebaseApi.instance.showNotification(message);
}

class FirebaseApi {
  FirebaseApi._();
  static final FirebaseApi instance = FirebaseApi._();

  // instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize({context}) async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // request permission
    await requestPermission();

    // setup message handlers
    await setupMessageHandlers(context);

    // get FCM token
    final token = await _firebaseMessaging.getToken();
    print("FCM token: $token");
  }

  Future<void> allowNotifications({context}) async {
    await FirebaseApi.instance.initialize();
  }

  Future<String?> getToken() async {
    // get FCM token
    final token = await _firebaseMessaging.getToken();
    return token;
  }

  Future<void> requestPermission() async {
    // request permission from user
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );
    print("Permission status :${settings.authorizationStatus}");
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    // android setup
    const channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializeSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    // ios setup
    final initializationSettingsDarwin = DarwinInitializationSettings(
      // handle ios foreground notifications
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initializationSettings = InitializationSettings(
      android: initializeSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    //Flutter notification setup
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (details) {},
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // id
            'High Importance Notifications', // title
            channelDescription:
                'This channel is used for important notifications.', // description
            importance: Importance.high,
            priority: Priority.high,
            icon: "@mipmap/ic_launcher",
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> setupMessageHandlers(context) async {
    //foreground message
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
      _handleMessage(message, context);
    });

    //background message
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _handleMessage(message, context));

    // opened app
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage, context);
    }
  }

  void _handleMessage(RemoteMessage message, context) {}
}

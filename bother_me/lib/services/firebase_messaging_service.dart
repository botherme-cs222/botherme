import 'package:bother_me/services/local_notifications_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  // Private constructor for singeton pattern
  FirebaseMessagingService._internal();

  // singleton instance
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();

  // factory constructor to provide singleton instance
  factory FirebaseMessagingService.instance() => _instance;

  // Reference to local notifications service for displaying notifications
  LocalNotificationsService? _localNotificationsService;

  /// Initialize Firebase Messaging and sets up all message listeners
  Future<void> init({required LocalNotificationsService localNotificationsService}) async {
    // Init local notifications service
    _localNotificationsService = localNotificationsService;

    // handle FCM token
    _handlePushNotificationsToken();

    // Request user permission for notifications
    _requestPermission();

    // register handler for background messages (app terminated)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // listen for messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // listen for notification taps when the app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // check for initial message that opened the app from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  // retrieves and manages the FCM token for push notifications
  Future<void> _handlePushNotificationsToken() async {
    // Listen for firebase installation id (fid) first
    FirebaseMessaging.instance.onRegistered.listen((String fid) {
      print('Firebase Installation ID: $fid');
      //TODO: send fid to backend by saving it next to the user's account in our database: user_123 -> fid: "dK9x_...123"
    }).onError((error){
      // handle errors during token refresh
      print('Error refreshing FCM token: $error');
    });
    // trigger registration
    await FirebaseMessaging.instance.register();
  }

  // requests notifications permissions from user
  Future<void> _requestPermission() async {
    // request permission for alerts, badges, and sounds
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // log the user's permission decision
    print('User granted permission: ${result.authorizationStatus}');
  }
  // handles messages received while app is in foreground
  void _onForegroundMessage(RemoteMessage message){
    print('Foreground message received: ${message.data.toString()}');
    final notificationData = message.notification;
    if (notificationData != null) {
      _localNotificationsService?.showNotification(notificationData.title, notificationData.body, message.data.toString());
    }
  }

  // handles notification taps when app is opened from background or terminated state
  void _onMessageOpenedApp(RemoteMessage message){
    print('Notification caused the app to open: ${message.data.toString()}');
    // TODO: Add navigation or specific handling based on message data
  }
}

/// background message handler (must be top-level function or static)
/// handles messages when app is fully terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.data.toString()}');
  // Ensure Firebase & Local Notifications are initialized in the background isolate
  await Firebase.initializeApp();

  final notificationData = message.notification;
  final title = notificationData?.title ?? message.data['title'];
  final body = notificationData?.body ?? message.data['body'];

  if (title != null || body != null) {
    final localNotificationsService = LocalNotificationsService.instance();
    await localNotificationsService.init();
    await localNotificationsService.showNotification(title, body, message.data.toString());
  }
}
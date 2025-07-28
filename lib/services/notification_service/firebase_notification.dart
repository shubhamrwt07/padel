import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

/// Professional notification service handling both local and Firebase notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  // Notification channels
  static const String _channelId = 'default_channel';
  static const String _channelName = 'Default Notifications';
  static const String _channelDescription = 'Default notification channel';

  static const String _highPriorityChannelId = 'high_priority_channel';
  static const String _highPriorityChannelName = 'High Priority Notifications';
  static const String _highPriorityChannelDescription =
      'High priority notification channel';

  // Plugin instances
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Notification callback handlers
  Function(String)? onNotificationTapped;
  Function(RemoteMessage)? onForegroundMessage;
  Function(RemoteMessage)? onBackgroundMessage;

  bool _isInitialized = false;

  /// Initialize the notification service
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Initialize local notifications
      await _initializeLocalNotifications();

      // Initialize Firebase messaging
      await _initializeFirebaseMessaging();

      // Request permissions
      await _requestPermissions();

      _isInitialized = true;
      log('NotificationService initialized successfully');
      return true;
    } catch (e) {
      log('Failed to initialize NotificationService: $e');
      return false;
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      // Default channel
      await androidImplementation.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.defaultImportance,
        ),
      );

      // High priority channel
      await androidImplementation.createNotificationChannel(
        const AndroidNotificationChannel(
          _highPriorityChannelId,
          _highPriorityChannelName,
          description: _highPriorityChannelDescription,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ),
      );
    }
  }

  /// Initialize Firebase messaging
  Future<void> _initializeFirebaseMessaging() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages (when app is in background but not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // Handle messages when app is opened from terminated state
    final RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  /// Handle foreground Firebase messages
  void _handleForegroundMessage(RemoteMessage message) {
    log('Received foreground message: ${message.messageId}');

    // Show local notification for foreground messages
    showNotification(
      id: message.hashCode,
      title: message.notification?.title ?? 'New Message',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );

    onForegroundMessage?.call(message);
  }

  /// Handle background Firebase messages
  void _handleBackgroundMessage(RemoteMessage message) {
    log('Handling background message: ${message.messageId}');
    onBackgroundMessage?.call(message);
  }

  /// Handle local notification taps
  void _onNotificationTapped(NotificationResponse response) {
    log('Notification tapped with payload: ${response.payload}');
    onNotificationTapped?.call(response.payload ?? '');
  }

  /// Request necessary permissions
  Future<bool> _requestPermissions() async {
    bool allGranted = true;

    // Request notification permission
    final notificationStatus = await Permission.notification.request();
    if (!notificationStatus.isGranted) {
      log('Notification permission denied');
      allGranted = false;
    }

    // Request Firebase messaging permission (iOS)
    final NotificationSettings firebaseSettings = await _firebaseMessaging
        .requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );

    if (firebaseSettings.authorizationStatus !=
        AuthorizationStatus.authorized) {
      log('Firebase messaging permission denied');
      allGranted = false;
    }

    return allGranted;
  }

  /// Show a simple notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool highPriority = false,
  }) async {
    if (!_isInitialized) {
      log('NotificationService not initialized');
      return;
    }

    final String channelId = highPriority ? _highPriorityChannelId : _channelId;
    final Importance importance = highPriority
        ? Importance.high
        : Importance.defaultImportance;
    final Priority priority = highPriority
        ? Priority.high
        : Priority.defaultPriority;

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          channelId,
          highPriority ? _highPriorityChannelName : _channelName,
          channelDescription: highPriority
              ? _highPriorityChannelDescription
              : _channelDescription,
          importance: importance,
          priority: priority,
          showWhen: true,
          when: DateTime.now().millisecondsSinceEpoch,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  /// Show a scheduled notification
  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    bool highPriority = false,
  }) async {
    if (!_isInitialized) {
      log('NotificationService not initialized');
      return;
    }

    final tz.TZDateTime scheduledTZTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    final String channelId = highPriority ? _highPriorityChannelId : _channelId;
    final Importance importance = highPriority
        ? Importance.high
        : Importance.defaultImportance;
    final Priority priority = highPriority
        ? Priority.high
        : Priority.defaultPriority;

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          channelId,
          highPriority ? _highPriorityChannelName : _channelName,
          channelDescription: highPriority
              ? _highPriorityChannelDescription
              : _channelDescription,
          importance: importance,
          priority: priority,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTZTime,
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Show a notification with custom action buttons
  Future<void> showNotificationWithActions({
    required int id,
    required String title,
    required String body,
    required List<AndroidNotificationAction> actions,
    String? payload,
  }) async {
    if (!_isInitialized) {
      log('NotificationService not initialized');
      return;
    }

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          actions: actions,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  /// Get Firebase messaging token
  Future<String?> getFirebaseToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      log('Failed to get Firebase token: $e');
      return null;
    }
  }

  /// Subscribe to a Firebase topic
  Future<bool> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      log('Subscribed to topic: $topic');
      return true;
    } catch (e) {
      log('Failed to subscribe to topic $topic: $e');
      return false;
    }
  }

  /// Unsubscribe from a Firebase topic
  Future<bool> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      log('Unsubscribed from topic: $topic');
      return true;
    } catch (e) {
      log('Failed to unsubscribe from topic $topic: $e');
      return false;
    }
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _localNotifications.pendingNotificationRequests();
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _localNotifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      return await androidImplementation?.areNotificationsEnabled() ?? false;
    }
    return true; // iOS doesn't have a direct way to check this
  }

  /// Set notification callback handlers
  void setCallbacks({
    Function(String)? onTapped,
    Function(RemoteMessage)? onForeground,
    Function(RemoteMessage)? onBackground,
  }) {
    onNotificationTapped = onTapped;
    onForegroundMessage = onForeground;
    onBackgroundMessage = onBackground;
  }

  /// Dispose resources (call this when app is being destroyed)
  void dispose() {
    _isInitialized = false;
    onNotificationTapped = null;
    onForegroundMessage = null;
    onBackgroundMessage = null;
  }
}

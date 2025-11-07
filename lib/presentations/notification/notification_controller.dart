// controllers/notification_controller.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../services/notification_service/firebase_notification.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  final NotificationService _notificationService = NotificationService();
  final GetStorage _storage = GetStorage();

  // Observable variables
  final RxString firebaseToken = ''.obs;
  final RxBool isNotificationEnabled = false.obs;
  final RxBool isInitialized = false.obs;
  final RxList<Map<String, dynamic>> notificationHistory =
      <Map<String, dynamic>>[].obs;
  final RxMap<String, bool> topicSubscriptions = <String, bool>{}.obs;

  // Storage keys
  static const String _tokenKey = 'firebase_token';
  static const String _notificationEnabledKey = 'notification_enabled';
  static const String _historyKey = 'notification_history';
  static const String _topicsKey = 'topic_subscriptions';

  @override
  void onInit() {
    super.onInit();
    _loadStoredData();
    _initializeNotifications();
  }

  /// Load stored data
  void _loadStoredData() {
    // Load token
    final storedToken = _storage.read(_tokenKey);
    if (storedToken != null) {
      firebaseToken.value = storedToken;
    }

    // Load notification enabled status
    final enabled = _storage.read(_notificationEnabledKey) ?? false;
    isNotificationEnabled.value = enabled;

    // Load notification history
    final history = _storage.read(_historyKey) ?? [];
    if (history is List) {
      notificationHistory.assignAll(history.cast<Map<String, dynamic>>());
    }

    // Load topic subscriptions
    final topics = _storage.read(_topicsKey) ?? {};
    if (topics is Map) {
      topicSubscriptions.assignAll(topics.cast<String, bool>());
    }
  }

  /// Initialize notification service and request permissions
  Future<void> _initializeNotifications() async {
    try {
      // Initialize the notification service
      final bool initialized = await _notificationService.initialize();

      if (initialized) {
        isInitialized.value = true;
        // Set up callback handlers
        _notificationService.setCallbacks(
          onTapped: _handleNotificationTapped,
          onForeground: _handleForegroundMessage,
          onBackground: _handleBackgroundMessage,
        );

        // Get and store Firebase token
        await _getAndStoreFirebaseToken();

        // Check notification permission status
        await _checkNotificationPermission();

        // Subscribe to stored topics
        await _restoreTopicSubscriptions();

        if (kDebugMode) {
          print('✅ Notification service initialized successfully');
        }
      } else {
        if (kDebugMode) {
          print('❌Failed to initialize notification service');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌Error initializing notifications: $e');
      }
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (!isInitialized.value) {
      print('⚠️ Notification service not initialized');
      return false;
    }

    try {
      final NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission(
            alert: true,
            badge: true,
            sound: true,
            provisional: false,
            criticalAlert: false,
            announcement: false,
          );

      final bool granted =
          settings.authorizationStatus == AuthorizationStatus.authorized;
      isNotificationEnabled.value = granted;

      await _storage.write(_notificationEnabledKey, granted);

      if (granted) {
        await _getAndStoreFirebaseToken();
        print('✅ Notification permissions granted');
      } else {
        print('❌ Notification permissions denied');
      }

      return granted;
    } catch (e) {
      print('❌ Error requesting permissions: $e');
      return false;
    }
  }

  /// Get and store Firebase token
  Future<void> _getAndStoreFirebaseToken() async {
    try {
      final String? token = await _notificationService.getFirebaseToken();

      if (token != null && token.isNotEmpty) {
        firebaseToken.value = token;
        await _storage.write(_tokenKey, token);
        await _sendTokenToServer(token);
        if (kDebugMode) {
          print('✅ Firebase token retrieved: ${token.substring(0, 20)}...');
        }
      } else {
        if (kDebugMode) {
          print('❌ Failed to get Firebase token');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting Firebase token: $e');
      }
    }
  }

  /// Check current notification permission status
  Future<void> _checkNotificationPermission() async {
    try {
      final bool enabled = await _notificationService.areNotificationsEnabled();
      isNotificationEnabled.value = enabled;
      await _storage.write(_notificationEnabledKey, enabled);
    } catch (e) {
      print('❌ Error checking notification permission: $e');
    }
  }
  /// Restore topic subscriptions from storage
  Future<void> _restoreTopicSubscriptions() async {
    try {
      for (final entry in topicSubscriptions.entries) {
        if (entry.value) {
          await _notificationService.subscribeToTopic(entry.key);
        }
      }
      print('✅ Restored topic subscriptions');
    } catch (e) {
      print('❌ Error restoring topic subscriptions: $e');
    }

  }

  /// Send token to server
  Future<void> _sendTokenToServer(String token) async {
    try {
      // TODO: Replace with your actual API endpoint
      print('📤 Token should be sent to server: $token');
    } catch (e) {
      print('❌ Error sending token to server: $e');
    }
  }
  /// Handle notification tap
  void _handleNotificationTapped(String payload) {
    print('🔔 Notification tapped with payload: $payload');

    try {
      if (payload.isNotEmpty) {
        if (payload.contains('creatematch')) {
          Get.toNamed('/creatematch-details');
        } else if (payload.contains('booking')) {
          Get.toNamed('/booking-details');
        } else {
          Get.toNamed('/notifications');
        }
      }
    } catch (e) {
      print('❌ Error handling notification tap: $e');
    }
  }


  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    print('🔔 Foreground message: ${message.notification?.title}');

    // Add to history
    _addToHistory(message);

    if (message.notification != null) {
      Get.snackbar(
        message.notification!.title ?? 'New Message',
        message.notification!.body ?? '',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    }
  }

  /// Handle background messages
  void _handleBackgroundMessage(RemoteMessage message) {
    print('🔔 Background message: ${message.notification?.title}');
    _addToHistory(message);
    _processMessageData(message.data);
  }

  /// Add notification to history
  void _addToHistory(RemoteMessage message) {
    final notification = {
      'title': message.notification?.title ?? 'No title',
      'body': message.notification?.body ?? 'No body',
      'timestamp': DateTime.now().toString(),
      'data': message.data,
    };

    notificationHistory.insert(0, notification);
    // Keep only last 50 notifications
    if (notificationHistory.length > 50) {
      notificationHistory.removeRange(50, notificationHistory.length);
    }

    _storage.write(_historyKey, notificationHistory.toList());
  }

  /// Process message data
  void _processMessageData(Map<String, dynamic> data) {
    final String? type = data['type'];
    switch (type) {
      case 'match_invitation':
        break;
      case 'booking_confirmation':
        break;
      case 'payment_success':
        break;
      default:
        print('Unknown notification type: $type');
    }
  }

  /// Show local notification manually
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    bool highPriority = false,
  }) async {
    if (!isInitialized.value) return;

    await _notificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      payload: payload,
      highPriority: highPriority,
    );

    // Add to history
    _addToHistory(
      RemoteMessage(
        messageId: DateTime.now().toString(),
        notification: RemoteNotification(title: title, body: body),
        data: {'type': 'local', 'payload': payload ?? ''},
      ),
    );
  }

  /// Schedule a notification
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!isInitialized.value) return;

    await _notificationService.showScheduledNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      payload: payload,
    );
  }


  /// Subscribe to a topic
  Future<bool> subscribeToTopic(String topic) async {
    final success = await _notificationService.subscribeToTopic(topic);
    if (success) {
      topicSubscriptions[topic] = true;
      await _storage.write(_topicsKey, topicSubscriptions);
    }
    return success;
  }

  /// Unsubscribe from a topic
  Future<bool> unsubscribeFromTopic(String topic) async {
    final success = await _notificationService.unsubscribeFromTopic(topic);
    if (success) {
      topicSubscriptions[topic] = false;
      await _storage.write(_topicsKey, topicSubscriptions);
    }
    return success;
  }

  /// Check if subscribed to topic
  bool isSubscribedToTopic(String topic) {
    return topicSubscriptions[topic] ?? false;
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
  }

  /// Clear notification history
  void clearNotificationHistory() {
    notificationHistory.clear();
    _storage.remove(_historyKey);
  }

  /// Get stored token
  String? getStoredToken() {
    return _storage.read(_tokenKey);
  }

  /// Check if notifications are enabled
  bool get areNotificationsEnabled => isNotificationEnabled.value;

  /// Refresh token
  Future<void> refreshToken() async {
    await _getAndStoreFirebaseToken();
  }

  @override
  void onClose() {
    _notificationService.dispose();
    super.onClose();
  }
}

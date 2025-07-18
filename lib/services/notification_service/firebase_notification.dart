// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:permission_handler/permission_handler.dart';
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();
//
//   final FlutterLocalNotificationsPlugin _localNotifications =
//   FlutterLocalNotificationsPlugin();
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//   // Notification channels
//   static const String _defaultChannelId = 'default_channel';
//   static const String _highPriorityChannelId = 'high_priority_channel';
//   static const String _reminderChannelId = 'reminder_channel';
//   static const String _newsChannelId = 'news_channel';
//
//   // Callbacks
//   Function(String)? onNotificationTap;
//   Function(RemoteMessage)? onBackgroundMessage;
//   Function(RemoteMessage)? onForegroundMessage;
//
//   /// Initialize the notification service
//   Future<void> initialize() async {
//     await _initializeLocalNotifications();
//     await _initializePushNotifications();
//     await _initializeTimezone();
//   }
//
//   /// Initialize local notifications
//   Future<void> _initializeLocalNotifications() async {
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//     );
//
//     const initializationSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     await _localNotifications.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _onNotificationResponse,
//     );
//
//     await _createNotificationChannels();
//   }
//
//   /// Initialize Firebase push notifications
//   Future<void> _initializePushNotifications() async {
//     // Request permissions
//     await _requestNotificationPermissions();
//
//     // Configure Firebase messaging
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
//     FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
//
//     // Handle notification when app is opened from terminated state
//     final initialMessage = await _firebaseMessaging.getInitialMessage();
//     if (initialMessage != null) {
//       _handleNotificationTap(initialMessage);
//     }
//   }
//
//   /// Initialize timezone for scheduled notifications
//   Future<void> _initializeTimezone() async {
//     tz.initializeTimeZones();
//   }
//
//   /// Create notification channels for Android
//   Future<void> _createNotificationChannels() async {
//     final channels = [
//       const AndroidNotificationChannel(
//         _defaultChannelId,
//         'Default Notifications',
//         description: 'General notifications',
//         importance: Importance.defaultImportance,
//       ),
//       const AndroidNotificationChannel(
//         _highPriorityChannelId,
//         'High Priority',
//         description: 'Important notifications that require immediate attention',
//         importance: Importance.high,
//         enableVibration: true,
//         playSound: true,
//       ),
//       const AndroidNotificationChannel(
//         _reminderChannelId,
//         'Reminders',
//         description: 'Reminder notifications',
//         importance: Importance.high,
//         enableVibration: true,
//       ),
//       const AndroidNotificationChannel(
//         _newsChannelId,
//         'News & Updates',
//         description: 'News and app updates',
//         importance: Importance.defaultImportance,
//       ),
//     ];
//
//     for (final channel in channels) {
//       await _localNotifications
//           .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);
//     }
//   }
//
//   /// Request notification permissions
//   Future<bool> _requestNotificationPermissions() async {
//     if (Platform.isIOS) {
//       final settings = await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         provisional: false,
//       );
//       return settings.authorizationStatus == AuthorizationStatus.authorized;
//     } else {
//       final status = await Permission.notification.request();
//       return status.isGranted;
//     }
//   }
//
//   /// Check if notifications are enabled
//   Future<bool> areNotificationsEnabled() async {
//     if (Platform.isIOS) {
//       final settings = await _firebaseMessaging.getNotificationSettings();
//       return settings.authorizationStatus == AuthorizationStatus.authorized;
//     } else {
//       return await Permission.notification.isGranted;
//     }
//   }
//
//   /// Get FCM token for push notifications
//   Future<String?> getToken() async {
//     return await _firebaseMessaging.getToken();
//   }
//
//   /// Subscribe to FCM topic
//   Future<void> subscribeToTopic(String topic) async {
//     await _firebaseMessaging.subscribeToTopic(topic);
//   }
//
//   /// Unsubscribe from FCM topic
//   Future<void> unsubscribeFromTopic(String topic) async {
//     await _firebaseMessaging.unsubscribeFromTopic(topic);
//   }
//
//   /// Show instant notification
//   Future<void> showInstantNotification({
//     required String title,
//     required String body,
//     String? payload,
//     NotificationPriority priority = NotificationPriority.normal,
//     String? largeIcon,
//     String? bigPicture,
//     List<NotificationAction>? actions,
//   }) async {
//     final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
//
//     final androidDetails = AndroidNotificationDetails(
//       _getChannelId(priority),
//       _getChannelName(priority),
//       channelDescription: _getChannelDescription(priority),
//       importance: _getImportance(priority),
//       priority: _getPriority(priority),
//       largeIcon: largeIcon != null ? DrawableResourceAndroidBitmap(largeIcon) : null,
//
//     );
//
//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     final notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await _localNotifications.show(
//       id,
//       title,
//       body,
//       notificationDetails,
//       payload: payload,
//     );
//   }
//
//   /// Schedule notification
//   Future<void> scheduleNotification({
//     required String title,
//     required String body,
//     required DateTime scheduledTime,
//     String? payload,
//     NotificationPriority priority = NotificationPriority.normal,
//     bool repeatDaily = false,
//     bool repeatWeekly = false,
//   }) async {
//     final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
//
//     final androidDetails = AndroidNotificationDetails(
//       _getChannelId(priority),
//       _getChannelName(priority),
//       channelDescription: _getChannelDescription(priority),
//       importance: _getImportance(priority),
//       priority: _getPriority(priority),
//     );
//
//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     final notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     final scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);
//
//     if (repeatDaily) {
//       await _localNotifications.zonedSchedule(
//         id,
//         title,
//         body,
//         scheduledDate,
//         notificationDetails,
//         payload: payload,
//         uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time,
//       );
//     } else if (repeatWeekly) {
//       await _localNotifications.zonedSchedule(
//         id,
//         title,
//         body,
//         scheduledDate,
//         notificationDetails,
//         payload: payload,
//         uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
//       );
//     } else {
//       await _localNotifications.zonedSchedule(
//         id,
//         title,
//         body,
//         scheduledDate,
//         notificationDetails,
//         payload: payload,
//         uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//       );
//     }
//   }
//
//   /// Show progress notification
//   Future<void> showProgressNotification({
//     required String title,
//     required String body,
//     required int progress,
//     required int maxProgress,
//     bool indeterminate = false,
//   }) async {
//     const id = 1001; // Fixed ID for progress notifications
//
//     final androidDetails = AndroidNotificationDetails(
//       _defaultChannelId,
//       'Default Notifications',
//       channelDescription: 'General notifications',
//       importance: Importance.low,
//       priority: Priority.low,
//       onlyAlertOnce: true,
//       showProgress: true,
//       maxProgress: maxProgress,
//       progress: progress,
//       indeterminate: indeterminate,
//     );
//
//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: false,
//       presentSound: false,
//     );
//
//     final notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await _localNotifications.show(
//       id,
//       title,
//       body,
//       notificationDetails,
//     );
//   }
//
//   /// Show big text notification
//   Future<void> showBigTextNotification({
//     required String title,
//     required String body,
//     required String bigText,
//     String? payload,
//   }) async {
//     final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
//
//     final androidDetails = AndroidNotificationDetails(
//       _defaultChannelId,
//       'Default Notifications',
//       channelDescription: 'General notifications',
//       importance: Importance.defaultImportance,
//       priority: Priority.defaultPriority,
//       styleInformation: BigTextStyleInformation(
//         bigText,
//         htmlFormatBigText: true,
//         contentTitle: title,
//         htmlFormatContentTitle: true,
//         summaryText: body,
//         htmlFormatSummaryText: true,
//       ),
//     );
//
//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     final notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await _localNotifications.show(
//       id,
//       title,
//       body,
//       notificationDetails,
//       payload: payload,
//     );
//   }
//
//   /// Show inbox style notification
//   Future<void> showInboxNotification({
//     required String title,
//     required String body,
//     required List<String> messages,
//     String? payload,
//   }) async {
//     final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
//
//     final androidDetails = AndroidNotificationDetails(
//       _defaultChannelId,
//       'Default Notifications',
//       channelDescription: 'General notifications',
//       importance: Importance.defaultImportance,
//       priority: Priority.defaultPriority,
//       styleInformation: InboxStyleInformation(
//         messages,
//         htmlFormatLines: true,
//         contentTitle: title,
//         htmlFormatContentTitle: true,
//         summaryText: body,
//         htmlFormatSummaryText: true,
//       ),
//     );
//
//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     final notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await _localNotifications.show(
//       id,
//       title,
//       body,
//       notificationDetails,
//       payload: payload,
//     );
//   }
//
//   /// Cancel notification by ID
//   Future<void> cancelNotification(int id) async {
//     await _localNotifications.cancel(id);
//   }
//
//   /// Cancel all notifications
//   Future<void> cancelAllNotifications() async {
//     await _localNotifications.cancelAll();
//   }
//
//   /// Get pending notifications
//   Future<List<PendingNotificationRequest>> getPendingNotifications() async {
//     return await _localNotifications.pendingNotificationRequests();
//   }
//
//   /// Get active notifications
//   Future<List<ActiveNotification>> getActiveNotifications() async {
//     return await _localNotifications.getActiveNotifications();
//   }
//
//
//
//
//
//   // Helper methods
//   String _getChannelId(NotificationPriority priority) {
//     switch (priority) {
//       case NotificationPriority.high:
//         return _highPriorityChannelId;
//       case NotificationPriority.reminder:
//         return _reminderChannelId;
//       case NotificationPriority.news:
//         return _newsChannelId;
//       default:
//         return _defaultChannelId;
//     }
//   }
//
//   String _getChannelName(NotificationPriority priority) {
//     switch (priority) {
//       case NotificationPriority.high:
//         return 'High Priority';
//       case NotificationPriority.reminder:
//         return 'Reminders';
//       case NotificationPriority.news:
//         return 'News & Updates';
//       default:
//         return 'Default Notifications';
//     }
//   }
//
//   String _getChannelDescription(NotificationPriority priority) {
//     switch (priority) {
//       case NotificationPriority.high:
//         return 'Important notifications that require immediate attention';
//       case NotificationPriority.reminder:
//         return 'Reminder notifications';
//       case NotificationPriority.news:
//         return 'News and app updates';
//       default:
//         return 'General notifications';
//     }
//   }
//
//   Importance _getImportance(NotificationPriority priority) {
//     switch (priority) {
//       case NotificationPriority.high:
//       case NotificationPriority.reminder:
//         return Importance.high;
//       case NotificationPriority.news:
//       case NotificationPriority.normal:
//         return Importance.defaultImportance;
//       default:
//         return Importance.low;
//     }
//   }
//
//   Priority _getPriority(NotificationPriority priority) {
//     switch (priority) {
//       case NotificationPriority.high:
//       case NotificationPriority.reminder:
//         return Priority.high;
//       case NotificationPriority.news:
//       case NotificationPriority.normal:
//         return Priority.defaultPriority;
//       default:
//         return Priority.low;
//     }
//   }
//
//   // Event handlers
//   void _onNotificationResponse(NotificationResponse response) {
//     if (response.payload != null && onNotificationTap != null) {
//       onNotificationTap!(response.payload!);
//     }
//   }
//
//   void _handleForegroundMessage(RemoteMessage message) {
//     if (onForegroundMessage != null) {
//       onForegroundMessage!(message);
//     }
//
//     // Show local notification for foreground messages
//     showInstantNotification(
//       title: message.notification?.title ?? 'New Message',
//       body: message.notification?.body ?? 'You have a new message',
//       payload: jsonEncode(message.data),
//     );
//   }
//
//   void _handleNotificationTap(RemoteMessage message) {
//     if (onNotificationTap != null) {
//       onNotificationTap!(jsonEncode(message.data));
//     }
//   }
//
//   static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
//     // Handle background message
//     print('Background message: ${message.messageId}');
//   }
// }
//
// /// Notification priority levels
// enum NotificationPriority {
//   low,
//   normal,
//   high,
//   reminder,
//   news,
// }
//
// /// Notification action for interactive notifications
// class NotificationAction {
//   final String id;
//   final String title;
//   final bool showsUserInterface;
//   final bool destructive;
//
//   const NotificationAction({
//     required this.id,
//     required this.title,
//     this.showsUserInterface = false,
//     this.destructive = false,
//   });
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:padel_mobile/firebase_options.dart';
import 'package:padel_mobile/presentations/notification/notification_controller.dart';
import 'package:padel_mobile/services/notification_service/firebase_notification.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'configs/routes/routes.dart';
import 'configs/themes/app_themes.dart';
import 'core/network/dio_client.dart';

/// Background message handler - must be a top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().initialize();
  NotificationService().showNotification(
    id: message.hashCode,
    title: message.notification?.title ?? 'Background Message',
    body: message.notification?.body ?? '',
    payload: message.data.toString(),
    highPriority: true,
  );
}

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print('✅ Firebase initialized');

    // Initialize timezone data for scheduled notifications
    tz.initializeTimeZones();
    print('✅ Timezone initialized');

    // Initialize GetStorage
    await GetStorage.init();
    print('✅ GetStorage initialized');

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    if (kDebugMode) {
      print('✅ Background message handler set');
    }

    // Initialize core services
    Get.put(DioClient());

    // Initialize notification controller (will initialize NotificationService)
    Get.put(NotificationController());
    if (kDebugMode) {
      print('✅ Controllers initialized');
    }

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Run the app
    runApp(const MyApp());

  } catch (e) {
    if (kDebugMode) {
      print('❌ Error during app initialization: $e');
    }
    // You might want to show an error screen or handle this differently
    runApp(ErrorApp(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matchacha Padel',
      theme: AppThemes.appTheme,
      darkTheme: ThemeData.light(),
      themeMode: ThemeMode.light,
      getPages: Routes.route,
      initialRoute: Routes.initialRoute,

      // Global navigation key for notification navigation
      navigatorKey: Get.key,

      // Handle app lifecycle for notifications
      builder: (context, child) {
        return NotificationWrapper(child: child!);
      },
    );
  }
}

/// Wrapper to handle notification-related app lifecycle
class NotificationWrapper extends StatefulWidget {
  final Widget child;

  const NotificationWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<NotificationWrapper> createState() => _NotificationWrapperState();
}

class _NotificationWrapperState extends State<NotificationWrapper> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _handleAppLaunchFromNotification();
  }

  @override

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Handle app launch from notification when app was terminated
  Future<void> _handleAppLaunchFromNotification() async {
    // Check if app was opened from a terminated state via notification
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print('🔔 App launched from notification: ${initialMessage.messageId}');

      // Wait for app to be ready, then handle navigation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleMessageNavigation(initialMessage);
      });
    }
  }

  /// Handle navigation based on message data
  void _handleMessageNavigation(RemoteMessage message) {
    final data = message.data;

    try {
      if (data['route'] != null) {
        Get.toNamed(data['route']);
      } else if (data['type'] == 'creatematch') {
        Get.toNamed('/creatematch-details', arguments: data);
      } else if (data['type'] == 'booking') {
        Get.toNamed('/booking-details', arguments: data);
      } else {
        Get.toNamed('/notifications');
      }
    } catch (e) {
      print('❌ Error navigating from notification: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        print('📱 App resumed');
        // Refresh notification controller state if needed
        try {
          final controller = NotificationController.instance;
          controller.refreshToken();
        } catch (e) {
          print('❌ Error refreshing on resume: $e');
        }
        break;
      case AppLifecycleState.paused:
        print('📱 App paused');
        break;
      case AppLifecycleState.detached:
        print('📱 App detached');
        break;
      case AppLifecycleState.inactive:
        print('📱 App inactive');
        break;
      case AppLifecycleState.hidden:
        print('📱 App hidden');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Error app to show when initialization fails
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('App Initialization Error'),
              const SizedBox(height: 8),
              Text(error, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Restart the app
                  SystemNavigator.pop();
                },
                child: const Text('Restart App'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// screens/notification_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notification_controller.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController = Get.find();

    return Scaffold(

      appBar: AppBar(

        automaticallyImplyLeading: false,
        centerTitle: true,
        title:   Text('Notification',style: TextStyle(fontSize: 19),),
        backgroundColor: Colors.white,
         elevation: 1,
      ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Obx(() => Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          notificationController.areNotificationsEnabled
                              ? Icons.notifications_active
                              : Icons.notifications_off,
                          color: notificationController.areNotificationsEnabled
                              ? Colors.green
                              : Colors.red,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Notification Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      notificationController.areNotificationsEnabled
                          ? 'Notifications are enabled'
                          : 'Notifications are disabled',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (!notificationController.areNotificationsEnabled) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final granted = await notificationController.requestPermissions();
                            if (granted) {
                              Get.snackbar(
                                'Success!',
                                'Notifications enabled successfully',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Enable Notifications'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            )),

            const SizedBox(height: 20),

            // Firebase Token Card
            Obx(() => Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.token,
                          color: Colors.blue,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Firebase Token',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            await notificationController.refreshToken();
                            Get.snackbar(
                              'Token Refreshed',
                              'Firebase token has been refreshed',
                              snackPosition: SnackPosition.TOP,
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Refresh Token',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        notificationController.firebaseToken.value.isNotEmpty
                            ? notificationController.firebaseToken.value
                            : 'Token not available',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),

            const SizedBox(height: 20),

            // Test Notifications Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.bug_report,
                          color: Colors.orange,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Test Notifications',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Test buttons
                    _buildTestButton(
                      'Test Simple Notification',
                      Icons.notifications,
                          () => notificationController.showLocalNotification(
                        title: 'Test Notification',
                        body: 'This is a test notification from Matchacha Padel',
                        payload: '{"type": "test", "timestamp": "${DateTime.now()}"}',
                      ),
                    ),

                    const SizedBox(height: 8),

                    _buildTestButton(
                      'Test High Priority',
                      Icons.priority_high,
                          () => notificationController.showLocalNotification(
                        title: 'High Priority Alert',
                        body: 'This is a high priority test notification',
                        highPriority: true,
                      ),
                    ),

                    const SizedBox(height: 8),

                    _buildTestButton(
                      'Schedule Test (10s)',
                      Icons.schedule,
                          () {
                        final scheduledTime = DateTime.now().add(const Duration(seconds: 10));
                        notificationController.scheduleNotification(
                          title: 'Scheduled Notification',
                          body: 'This notification was scheduled 10 seconds ago',
                          scheduledTime: scheduledTime,
                        );
                        Get.snackbar(
                          'Scheduled',
                          'Notification will appear in 10 seconds',
                          snackPosition: SnackPosition.TOP,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Topic Subscriptions
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.topic,
                          color: Colors.green,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Topic Subscriptions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildTopicTile('general', 'General Notifications'),
                    _buildTopicTile('padel_updates', 'Padel Updates'),
                    _buildTopicTile('tournaments', 'Tournaments'),
                    _buildTopicTile('promotions', 'Promotions & Offers'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Actions
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.settings,
                          color: Colors.purple,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          await notificationController.cancelAllNotifications();
                          Get.snackbar(
                            'Cleared',
                            'All notifications have been cancelled',
                            snackPosition: SnackPosition.TOP,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancel All Notifications'),
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          _showNotificationHistoryDialog(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('View Notification History'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Debug Information
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Debug Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Obx(() => _buildDebugInfo('Permissions Granted',
                        notificationController.areNotificationsEnabled.toString())),
                    _buildDebugInfo('Platform', Theme.of(context).platform.name),
                    Obx(() => _buildDebugInfo('Token Length',
                        notificationController.firebaseToken.value.isNotEmpty
                            ? notificationController.firebaseToken.value.length.toString()
                            : '0')),
                    _buildDebugInfo('App Version', '1.0.0'), // You can make this dynamic
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40), // Extra space at bottom
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(String title, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildTopicTile(String topic, String displayName) {
    final NotificationController notificationController = Get.find();

    return  ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        _getTopicIcon(topic),
        color: Colors.green.shade600,
        size: 20,
      ),
      title: Text(
        displayName,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        // value: notificationController.isSubscribedToTopic(topic),
        value:true,
        onChanged: (value) async {
          if (value) {
            await notificationController.subscribeToTopic(topic);
            Get.snackbar(
              'Subscribed',
              'Subscribed to $displayName',
              snackPosition: SnackPosition.TOP,
            );
          } else {
            await notificationController.unsubscribeFromTopic(topic);
            Get.snackbar(
              'Unsubscribed',
              'Unsubscribed from $displayName',
              snackPosition: SnackPosition.TOP,
            );
          }
        },
        activeColor: Colors.green.shade600,
      ),
     );
  }

  IconData _getTopicIcon(String topic) {
    switch (topic) {
      case 'general':
        return Icons.notifications;
      case 'padel_updates':
        return Icons.sports_tennis;
      case 'tournaments':
        return Icons.emoji_events;
      case 'promotions':
        return Icons.local_offer;
      default:
        return Icons.topic;
    }
  }

  Widget _buildDebugInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationHistoryDialog(BuildContext context) {
    final NotificationController notificationController = Get.find();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification History'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child:  const Center(
                child: Text('No notification history available'),
          ),



        ),
        actions: [
          TextButton(
            onPressed: () {
              // notificationController.clearNotificationHistory();
              Navigator.of(context).pop();
            },
            child: const Text('Clear History'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
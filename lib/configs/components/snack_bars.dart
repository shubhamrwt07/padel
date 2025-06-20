import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarUtils {
  SnackBarUtils._internal();

  static final SnackBarUtils _instance = SnackBarUtils._internal();

  factory SnackBarUtils() {
    return _instance;
  }

  // Track the last shown error message and timestamp
  static String? _lastErrorMessage;
  static DateTime? _lastErrorTime;
  
  // Constants
  static const int _duplicateMessageCooldown = 3000; // milliseconds

  // Success
  static void showSuccessSnackBar(String message) {
    _showSnackBar(
      title: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  // Error with duplicate prevention
  static void showErrorSnackBar(String message) {
    final now = DateTime.now();
    
    // Check if the same message was recently shown
    if (_lastErrorMessage == message && 
        _lastErrorTime != null &&
        now.difference(_lastErrorTime!).inMilliseconds < _duplicateMessageCooldown) {
      // Skip showing duplicate message
      return;
    }
    
    // Update tracking info
    _lastErrorMessage = message;
    _lastErrorTime = now;
    
    _showSnackBar(
      title: message,
      backgroundColor: Colors.red,
      icon: Icons.error_outline,
    );
  }

  // Info
  static void showInfoSnackBar(String message) {
    _showSnackBar(
      title: message,
      backgroundColor: Colors.blue,
      icon: Icons.info_outline,
    );
  }

  // Warning
  static void showWarningSnackBar(String message) {
    _showSnackBar(
      title: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_amber_rounded,
    );
  }

  static void _showSnackBar({
    required String title,
    required Color backgroundColor,
    required IconData icon,
  }) {
    Future.delayed(Duration(milliseconds: 100), () {
      Get.snackbar(
        "",
        "",
        titleText: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ).paddingOnly(top: Get.height*.005),
        ),
        messageText: SizedBox.shrink(), // Hide the subtitle/message
        backgroundColor: backgroundColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(15),
        borderRadius: 8,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      );
    });
  }
}
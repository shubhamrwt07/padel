import 'package:get/get.dart';

import '../services/network/connectivity_service.dart';

/// Utility class for connectivity operations
class ConnectivityUtils {
  /// Check if the device is currently connected to the internet
  static Future<bool> isConnected() async {
    final connectivityService = Get.find<ConnectivityService>();
    return connectivityService.checkConnectivity();
  }
  
  /// Get the reactive connectivity status (observable)
  static RxBool getConnectivityStatus() {
    final connectivityService = Get.find<ConnectivityService>();
    return connectivityService.isConnected;
  }
} 
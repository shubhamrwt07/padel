import 'dart:async';
import 'package:get/get.dart';
import '../services/network/connectivity_service.dart';

/// A mixin for GetxController that provides connectivity awareness.
mixin ConnectivityAwareMixin<T> on GetxController {
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();
  
   RxBool get isConnected => _connectivityService.isConnected;
  
  /// Checks if the device is currently connected to the internet
  Future<bool> checkConnectivity() async {
    return _connectivityService.checkConnectivity();
  }
  
 
  /// Helper method to check connectivity and refresh if connected
  Future<bool> checkAndRefresh() async {
    final hasConnection = await checkConnectivity();
    if (hasConnection) {
       return true;
    }
    return false;
  }
} 
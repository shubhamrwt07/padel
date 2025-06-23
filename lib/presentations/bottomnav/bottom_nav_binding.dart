import 'package:get/get.dart';

import 'bottom_nav_controller.dart';

class BottomNavigationBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(BottomNavigationController());
  }
}
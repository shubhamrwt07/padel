import 'package:get/get.dart';

import 'notification_controller.dart';

class NotificationBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(NotificationController());
  }

}
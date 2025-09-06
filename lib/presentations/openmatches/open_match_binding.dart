import 'package:get/get.dart';

import 'open_match_controller.dart';

class OpenMatchBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(OpenMatchController());
  }
}
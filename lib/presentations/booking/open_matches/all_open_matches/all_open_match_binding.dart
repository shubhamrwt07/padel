import 'package:get/get.dart';

import 'all_open_match_controller.dart';

class AllOpenMatchBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(AllOpenMatchController());
  }
}
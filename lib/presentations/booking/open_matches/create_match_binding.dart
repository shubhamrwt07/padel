import 'package:get/get.dart';

import 'create_match_controller.dart';

class CreateOpenMatchBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(CreateOpenMatchesController());
  }
}
import 'package:get/get.dart';
import 'package:padel_mobile/presentations/home/home_controller.dart';

import 'create_match_controller.dart';

class CreateOpenMatchBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(CreateOpenMatchesController());
  }
}
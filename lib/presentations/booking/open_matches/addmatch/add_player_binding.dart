import 'package:get/get.dart';

import 'add_player_controller.dart';

class ManualBookingOpenMatchesBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(ManualBookingOpenMatchesController());
  }

}
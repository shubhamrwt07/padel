import 'package:get/get.dart';
import 'package:padel_mobile/presentations/rounds/rounds_controller.dart';

class RoundsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(RoundsController());
  }
}

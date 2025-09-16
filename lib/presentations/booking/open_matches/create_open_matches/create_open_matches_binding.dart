import 'package:get/get.dart';
import 'create_open_matches_controller.dart';

class CreateOpenMatchesBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(CreateOpenMatchesController());
  }
}
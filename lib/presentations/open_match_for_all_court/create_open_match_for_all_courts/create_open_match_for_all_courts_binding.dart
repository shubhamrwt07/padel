import 'package:get/get.dart';
import 'package:padel_mobile/presentations/open_match_for_all_court/create_open_match_for_all_courts/create_open_match_for_all_courts_controller.dart';

class CreateOpenMatchForAllCourtsBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(CreateOpenMatchForAllCourtsController());
  }

}
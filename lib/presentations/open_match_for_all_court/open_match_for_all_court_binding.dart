import 'package:get/get.dart';
import 'package:padel_mobile/presentations/open_match_for_all_court/open_match_for_all_court_controller.dart';

class OpenMatchForAllCourtBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(OpenMatchForAllCourtController());
  }

}
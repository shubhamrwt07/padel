import 'package:get/get.dart';
import 'package:padel_mobile/presentations/main_home_page/main_home_controller.dart';

class MainHomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(MainHomeController());
  }

}
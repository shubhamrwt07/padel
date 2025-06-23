import 'package:get/get.dart';
import 'package:padel_mobile/presentations/home/home_controller.dart';

class HomeBinding implements Bindings{
  @override
  void dependencies() {
   Get.put(HomeController());
  }
}
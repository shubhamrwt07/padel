import 'package:get/get.dart';
import 'package:padel_mobile/presentations/splash/splash_controller.dart';

class SplashBinding implements Bindings{
  @override
  void dependencies() {
   Get.put(SplashController());
  }

}
import 'package:padel_mobile/presentations/splash/widgets/splash_exports.dart';

class SplashBinding implements Bindings{
  @override
  void dependencies() {
   Get.put(SplashController());
  }

}
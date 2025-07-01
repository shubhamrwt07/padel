import 'package:padel_mobile/presentations/splash/widgets/splash_exports.dart';

class SplashController extends GetxController{
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 3)).then((v){
      Get.offAllNamed(RoutesName.login);
    });
  }
}
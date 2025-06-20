import 'package:get/get.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';

class SplashController extends GetxController{
@override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 3)).then((v){
      Get.offAllNamed(RoutesName.login);
    });
  }
}
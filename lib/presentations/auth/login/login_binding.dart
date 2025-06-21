import 'package:get/get.dart';
import 'package:padel_mobile/presentations/auth/login/login_controller.dart';

class LoginBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}
import 'package:get/get.dart';
import 'package:padel_mobile/presentations/auth/sign_up/sign_up_controller.dart';

class SignUpBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(SignUpController());
  }
}
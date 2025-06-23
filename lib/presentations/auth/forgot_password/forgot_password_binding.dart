import 'package:get/get.dart';
import 'package:padel_mobile/presentations/auth/forgot_password/forgot_password_controller.dart';

class ForgotPasswordBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(ForgotPasswordController());
  }

}
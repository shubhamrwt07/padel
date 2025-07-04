import 'package:padel_mobile/presentations/auth/forgot_password/widgets/forgot_password_exports.dart';

class ForgotPasswordController extends GetxController {

  RxBool isVisiblePassword = true.obs;
  RxBool isVisibleConfirmPassword = true.obs;

  void passwordToggle() {
    isVisiblePassword.value = !isVisiblePassword.value;
  } void confirmPasswordToggle() {
    isVisibleConfirmPassword.value = !isVisibleConfirmPassword.value;
  }
}

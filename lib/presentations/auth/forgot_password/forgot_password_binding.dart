import 'package:padel_mobile/presentations/auth/forgot_password/widgets/forgot_password_exports.dart';

class ForgotPasswordBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(ForgotPasswordController());
  }

}
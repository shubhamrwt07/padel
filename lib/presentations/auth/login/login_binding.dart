import 'package:padel_mobile/presentations/auth/login/widgets/login_exports.dart';

class LoginBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}
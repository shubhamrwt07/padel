import 'package:padel_mobile/presentations/auth/sign_up/widgets/sign_up_exports.dart';

class SignUpBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(SignUpController());
  }
}
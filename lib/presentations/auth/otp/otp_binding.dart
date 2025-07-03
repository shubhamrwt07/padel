import 'package:get/get.dart';
import 'package:padel_mobile/presentations/auth/otp/otp_controller.dart';

class OtpBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(OtpController());
  }

}
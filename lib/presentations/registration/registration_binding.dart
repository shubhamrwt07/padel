import 'package:get/get.dart';
import 'package:padel_mobile/presentations/registration/registration_americano_controller.dart';

class RegistrationBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(RegistrationController());
  }
}

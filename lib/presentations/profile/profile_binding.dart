import 'package:get/get.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';


class ProfileBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(ProfileController());
  }
}
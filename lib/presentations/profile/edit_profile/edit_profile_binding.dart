import 'package:get/get.dart';
import 'package:padel_mobile/presentations/profile/edit_profile/edit_profile_controller.dart';

class EditProfileBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(EditProfileController());
  }
}
import 'package:padel_mobile/presentations/profile/widgets/profile_exports.dart';

class ProfileBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(ProfileController());
  }
}
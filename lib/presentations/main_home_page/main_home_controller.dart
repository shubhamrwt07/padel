import 'package:get/get.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';

class MainHomeController extends GetxController{
  final ProfileController profileController = Get.put(ProfileController());
}
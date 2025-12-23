import 'package:get/get.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';
import 'package:padel_mobile/presentations/home/home_controller.dart';

class MainHomeController extends GetxController{
  final ProfileController profileController = Get.put(ProfileController());
  final HomeController homeController = Get.put(HomeController());
  
  @override
  void onInit() {
    super.onInit();
    homeController.fetchBookings();
  }
}
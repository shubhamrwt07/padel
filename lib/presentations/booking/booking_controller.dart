import 'dart:developer';
import 'package:padel_mobile/data/request_models/home_models/get_club_name_model.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';

class BookingController extends GetxController with GetSingleTickerProviderStateMixin {
  DetailsController detailsController = Get.put(DetailsController());
  ProfileController profileController = Get.put(ProfileController());
  late TabController tabController;

  Rx<Courts> courtsData = Courts().obs;

  /// 🔹 Reactive variable to track cart count
  RxInt cartCount = 0.obs;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 1,
    );

    WidgetsBinding.instance.addPostFrameCallback((callback) {
      courtsData.value = Get.arguments["data"];
      detailsController.localMatchData.update(
        "address",
            (v) => "${courtsData.value.city},${courtsData.value.address}",
      );

      log("Data Fetch Successfully -> ${courtsData.value}");
      profileController.fetchUserProfile();
    });
  }

  // /// Optional helper methods to modify cart count
  // void addToCart() {
  //   cartCount.value++;
  // }

  // void removeFromCart() {
  //   if (cartCount.value > 0) cartCount.value--;
  // }

  // void setCartCount(int count) {
  //   cartCount.value = count;
  // }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}

import 'dart:developer';

import 'package:padel_mobile/data/request_models/home_models/get_club_name_model.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class BookingController extends GetxController
    with GetSingleTickerProviderStateMixin {

  late TabController tabController;
Rx<Courts> courtsData=Courts().obs;

  @override
  void onInit() {
    super.onInit();
    courtsData.value = Get.arguments["data"];
    tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 1,

    );
    WidgetsBinding.instance.addPostFrameCallback((callback){
      log("Data Fetch Successfully-> ${courtsData.value}");
    });
  }

  @override
  void onClose() {
    tabController.dispose();
  }

}

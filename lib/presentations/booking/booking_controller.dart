import 'dart:developer';

import 'package:padel_mobile/data/request_models/home_models/get_club_name_model.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class BookingController extends GetxController
    with GetSingleTickerProviderStateMixin {

  late TabController tabController;
  final List<Tab> tabs = const [
    Tab(text: 'Tab 1'),
    Tab(text: 'Tab 2'),
    Tab(text: 'Tab 3'),
    Tab(text: 'Tab 4'),
  ];
Rx<Courts> courtsData=Courts().obs;
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: 1,

    );
    WidgetsBinding.instance.addPostFrameCallback((callback){
      log("Data Fetch Sucssfully${courtsData.value.courtImage}");
    });
  }

  @override
  void onClose() {
    tabController.dispose();
  }

}

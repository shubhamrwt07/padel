import 'package:padel_mobile/presentations/bookinghistory/booking_history_controller.dart';
import 'package:padel_mobile/presentations/bookinghistory/booking_history_screen.dart';
import 'package:padel_mobile/presentations/cart/cart_controller.dart';
import 'package:padel_mobile/presentations/cart/cart_screen.dart';
import 'package:padel_mobile/presentations/home/home_screen.dart';
import 'package:padel_mobile/presentations/openmatchbooking/openmatch_booking_controller.dart';
import 'package:padel_mobile/presentations/openmatchbooking/openmatch_booking_screen.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';
import 'package:padel_mobile/presentations/profile/profile_screen.dart';

import '../auth/forgot_password/widgets/forgot_password_exports.dart';
import '../home/home_controller.dart';

class BottomNavigationController extends GetxController {
  HomeController homeController = Get.put(HomeController());
  BookingHistoryController bookingHistoryController= Get.put(BookingHistoryController());
  OpenMatchBookingController openMatchBookingController= Get.put(OpenMatchBookingController());
  final List<Map<String, dynamic>> tabs = [
    {'icon': Assets.imagesIcHomeBottomBar, 'label': 'Home','isSvg': true, 'size': 21.0},
    {'icon': Icons.calendar_month_outlined, 'label': 'Bookings', 'size': 30.0},
    {'icon':  Assets.imagesIcProfile, 'label': 'Open Matches', 'isSvg': true, 'size': 22.0},
    {'icon': Assets.imagesIcCap, 'label': 'Coach', 'isSvg': true, 'size': 20.0},

  ];


  // Reactive variable to hold selected index
  final selectedIndex = 0.obs;

  // List of pages (you can expand this as needed)
  final List<Widget> pages = [
HomeScreen(),
BookingHistoryUi(),
    OpenMatchBookingScreen(),
    SizedBox(
      height: Get.height,
      width: Get.width,
      child: Center(child: Text("Coming Soon",style: TextStyle(fontSize: 15),)),
    ),
  ];

  // Function to update selected index
  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  // Get current page based on selected index
  Widget getCurrentPage() {
    return pages[selectedIndex.value];
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
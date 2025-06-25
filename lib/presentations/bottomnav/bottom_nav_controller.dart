import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/presentations/cart/cart_controller.dart';
import 'package:padel_mobile/presentations/cart/cart_screen.dart';
import 'package:padel_mobile/presentations/home/home_screen.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';
import 'package:padel_mobile/presentations/profile/profile_screen.dart';

import '../home/home_controller.dart';

class BottomNavigationController extends GetxController {
  HomeController homeController = Get.put(HomeController());
  CartController cartController = Get.put(CartController());
  ProfileController profileController = Get.put(ProfileController());



  // Reactive variable to hold selected index
  final selectedIndex = 0.obs;

  // List of pages (you can expand this as needed)
  final List<Widget> pages = [
HomeScreen(),
HomeScreen(),
    CartScreen(),
ProfileUi()
  ];

  // Function to update selected index
  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  // Get current page based on selected index
  Widget getCurrentPage() {
    return pages[selectedIndex.value];
  }
}
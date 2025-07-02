import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/presentations/cart/cart_controller.dart';
import 'package:padel_mobile/presentations/cart/cart_screen.dart';
import 'package:padel_mobile/presentations/home/home_screen.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';
import 'package:padel_mobile/presentations/profile/profile_screen.dart';

import '../auth/forgot_password/widgets/forgot_password_exports.dart';
import '../home/home_controller.dart';

class BottomNavigationController extends GetxController {
  HomeController homeController = Get.put(HomeController());
  CartController cartController = Get.put(CartController());
  ProfileController profileController = Get.put(ProfileController());
  final List<Map<String, dynamic>> tabs = [
    {'icon': Assets.imagesIcHomeBottomBar, 'label': 'Home','isSvg': true, 'size': 21.0},
    {'icon': Assets.imagesIcCap, 'label': 'Coach', 'isSvg': true, 'size': 20.0},
    {'icon': Icons.shopping_cart_outlined, 'label': 'Cart', 'size': 24.0},
    {'icon':  Assets.imagesIcProfile, 'label': 'Profile', 'isSvg': true, 'size': 22.0},
  ];


  // Reactive variable to hold selected index
  final selectedIndex = 0.obs;

  // List of pages (you can expand this as needed)
  final List<Widget> pages = [
HomeScreen(),
SizedBox(
height: Get.height,
  width: Get.width,
  child: Center(child: Text("Coming Soon",style: TextStyle(fontSize: 15),)),
),
    CartScreen(buttonType: '',),
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
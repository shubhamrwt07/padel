import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  // Reactive variable to hold selected index
  final selectedIndex = 0.obs;

  // List of pages (you can expand this as needed)
  final List<Widget> pages = [
    Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    Center(child: Text('coach', style: TextStyle(fontSize: 24))),
    Center(child: Text('cart', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profile', style: TextStyle(fontSize: 24))),
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final List<Tab> tabs = const [
    Tab(text: 'Tab 1'),
    Tab(text: 'Tab 2'),
    Tab(text: 'Tab 3'),
    Tab(text: 'Tab 4'),
  ];

  @override
  void onInit() {
    super.onInit();
    tabController =
        TabController(length: tabs.length, vsync: this, initialIndex: 1);
  }

  @override
  void onClose() {
    tabController.dispose();
  }

  //Home Option------------------------------------------------------------------

  var selectedIndex = 0.obs;
  final List<Map<String, dynamic>> homeOptionsList = [
    {'icon': Icons.directions, 'label': 'Direction'},
    {'icon': Icons.call, 'label': 'Call'},
    {'icon': Icons.reviews, 'label': 'Reviews'},
    {'icon': Icons.photo, 'label': 'Photos'},

  ];
  final isShowAllReviews = false.obs;
  final isShowAllPhotos = false.obs;
}
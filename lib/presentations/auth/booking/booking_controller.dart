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


  //OPEN MATCHES-----------------------------------------------------------------
  String? selectedTime;
  Rx<DateTime> selectedDate=DateTime.now().obs;
  final List<String> timeSlots = [
    "8:00am", "8:10am", "8:30am",
    "8:40am", "9:00am", "9:20am",
    "9:40am", "10:00am", "10:20am",
  ];


}
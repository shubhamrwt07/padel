import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingController extends GetxController
    with GetSingleTickerProviderStateMixin {
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
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: 1,
    );
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
  Rx<DateTime> selectedDate = DateTime.now().obs;
  final List<String> timeSlots = [
    "8:00am",
    "8:10am",
    "8:30am",
    "8:40am",
    "9:00am",
    "9:20am",
    "9:40am",
    "10:00am",
    "10:20am",
  ];

  //FILTERS----------------------------------------------------------------------
  RxString selectedLocation = ''.obs;
  RxBool isAmPm = false.obs;

  List<String> locations = ["New Delhi", "Mumbai", "Bangalore"];

  var startDate = ''.obs;
  var endDate = ''.obs;
  var startTime = ''.obs;
  var endTime = ''.obs;
  var selectedOption = 'Relevance'.obs;
  final List<String> sortOptions = [
    'Relevance',
    'Number of players',
    'Most relevant',
    'Nearest',
  ];
  var playWithOptions = ['Men only', 'Women only', 'Mixed'];
  var selectedPlayWith = ''.obs;
  var amenitiesFilters = [
    'Parking',
    'Washrooms',
    'Floodlights (for night matches)',
    'Changing Room',
    'Spectator Area',
    'Refreshments or water available',
    'Racket or gear rental',
  ];
  var selectedAmenities = ''.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 20000.0.obs;
  final Rx<RangeValues> selectedRange = const RangeValues(0, 20000).obs;
  final RxDouble selectedPrice = 250.0.obs;
  void clearAllFilters() {
    selectedLocation.value = '';
    startDate.value = '';
    endDate.value = '';
    startTime.value = '';
    endTime.value = '';
    isAmPm.value = false;
    selectedOption.value = '';
    selectedPlayWith.value = '';
    selectedAmenities.value = '';
    selectedPrice.value = minPrice.value;
    selectedRange.value = RangeValues(minPrice.value, maxPrice.value);
  }



  final isShowAllReviews = false.obs;
  final isShowAllPhotos = false.obs;

  Rx<bool> viewUnavailableSlots = false.obs;
}

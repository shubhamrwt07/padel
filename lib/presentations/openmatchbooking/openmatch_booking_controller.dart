
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/response_models/openmatch_model/open_match_booking_model.dart';
import '../../handler/logger.dart';
import '../../repositories/openmatches/open_match_repository.dart';

class OpenMatchBookingController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  RxString selectedSlot = 'Morning'.obs;

  RxBool showFilter = false.obs;
  final List<String> slots = ['Morning', 'Afternoon', 'Evening'];
  final RxString selectedCategory = 'Select Category'.obs;
  final List<String> categories = ['Level A', 'Level B', 'Level C'];
  final GlobalKey dropdownKey = GlobalKey();
  var selectedDate = DateTime.now().obs;

  RxList<String> selectedTimings = <String>[].obs;
  RxString selectedLevel = ''.obs;

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var openMatchesList = <OpenMatchBookingData>[].obs;
  var showNoInternetScreen = false.obs;
  
  // Pagination variables
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  final int pageSize = 10;

  OpenMatchRepository repository = Get.put(OpenMatchRepository());

  var argument = "".obs;
  @override
  @override
  void onInit() {
    super.onInit();

    // Safely read arguments
    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey("type")) {
      argument.value = args["type"];
    } else {
      argument.value = "upcoming"; // or any sensible default
    }

    tabController = TabController(length: 2, vsync: this);

    tabController.animation!.addListener(() {
      final value = tabController.animation!.value;
      if (value == value.roundToDouble()) {
        final index = value.round();
        if (index != tabController.previousIndex) {
          _onTabChanged(index);
        }
      }
    });

    fetchOpenMatchesBooking(type: 'upcoming');
  }

  void _onTabChanged(int newIndex) {
    // Reset pagination and clear data
    resetPagination();
    String type = newIndex == 0 ? 'upcoming' : 'completed';
    fetchOpenMatchesBooking(type: type);
  }
  
  void resetPagination() {
    currentPage.value = 1;
    hasMoreData.value = true;
    openMatchesList.value = <OpenMatchBookingData>[];
    isLoading.value = true;
  }
  void selectSlot(String slot) {
    selectedSlot.value = slot;
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: now,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              bodyLarge: TextStyle(fontSize: 14),
              bodyMedium: TextStyle(fontSize: 12),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      selectedDate.value = pickedDate;
    }
  }

  void clearAll() {
    selectedDate.value = DateTime.now();
    selectedTimings.clear();
    selectedLevel.value = '';
  }

  Future<void> fetchOpenMatchesBooking({required String type, bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
      }

      final response = await repository.getOpenMatchBookings(
        type: type,
        page: currentPage.value,
        limit: pageSize,
      );

      if ((response?.data ?? []).isNotEmpty) {
        final newData = response!.data!.toList();
        
        if (isLoadMore) {
          // Append new data to existing list
          openMatchesList.addAll(newData);
        } else {
          // Replace existing data
          openMatchesList.value = newData;
        }
        
        // Check if we have more data
        hasMoreData.value = newData.length >= pageSize;
      } else {
        if (!isLoadMore) {
          openMatchesList.value = [];
        }
        hasMoreData.value = false;
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "Error :-> $e", level: LogLevel.error);
      if (!isLoadMore) {
        openMatchesList.value = [];
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
  
  Future<void> loadMoreData() async {
    if (!hasMoreData.value || isLoadingMore.value) return;
    
    currentPage.value++;
    String type = tabController.index == 0 ? 'upcoming' : 'completed';
    await fetchOpenMatchesBooking(type: type, isLoadMore: true);
  }

  Future<void> retryFetch() async {
    showNoInternetScreen.value = false;
    resetPagination();
    String type = tabController.index == 0 ? 'upcoming' : 'completed';
    await fetchOpenMatchesBooking(type: type);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
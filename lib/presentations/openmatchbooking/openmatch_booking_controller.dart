
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
  var openMatchesList = <OpenMatchBookingData>[].obs;
  var showNoInternetScreen = false.obs;

  OpenMatchRepository repository = Get.put(OpenMatchRepository());

  var argument = "".obs;
  @override
  void onInit() {
    super.onInit();
    argument.value = Get.arguments["type"];
    tabController = TabController(length: 2, vsync: this);

    // Use animation listener instead of regular listener
    tabController.animation!.addListener(() {
      final value = tabController.animation!.value;
      // Only trigger when animation completes
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
    // Immediately clear and show loading
    openMatchesList.value = <OpenMatchBookingData>[];
    isLoading.value = true;
    String type = newIndex == 0 ? 'upcoming' : 'completed';
    fetchOpenMatchesBooking(type: type);
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

  Future<void> fetchOpenMatchesBooking({required String type}) async {
    try {
      final response = await repository.getOpenMatchBookings(type: type);

      if ((response?.data ?? []).isNotEmpty) {
        openMatchesList.value = response!.data!.toList();
      } else {
        openMatchesList.value = [];
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "Error :-> $e", level: LogLevel.error);
      openMatchesList.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retryFetch() async {
    showNoInternetScreen.value = false;
    String type = tabController.index == 0 ? 'upcoming' : 'completed';
    await fetchOpenMatchesBooking(type: type);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
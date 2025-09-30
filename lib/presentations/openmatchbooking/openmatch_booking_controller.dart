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

  @override
  void onInit() {
    super.onInit();

    // 1️⃣ Initialize TabController first
    tabController = TabController(length: 2, vsync: this);

    // 2️⃣ Add listener for tab changes
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        String type = tabController.index == 0 ? 'upcoming' : 'completed';
        fetchOpenMatchesBooking(type: type);
      }
    });

    // 3️⃣ Call the initial API after setting up TabController
    fetchOpenMatchesBooking(type: 'upcoming');
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
    isLoading.value = true;
    try {
      final response = await repository.getOpenMatchBookings(type: type);
      if ((response?.data ?? []).isNotEmpty) {
        openMatchesList.assignAll(response!.data!.toList());
      } else {
        openMatchesList.clear();
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "Error :-> $e", level: LogLevel.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retryFetch() async {
    showNoInternetScreen.value = false;
    String type = tabController.index == 0 ? 'upcoming' : 'completed';
    await fetchOpenMatchesBooking(type: type);
  }
}

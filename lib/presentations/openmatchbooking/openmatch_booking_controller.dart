import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/response_models/openmatch_model/open_match_booking_model.dart';
import '../../handler/logger.dart';
import '../../repositories/openmatches/open_match_repository.dart';

class OpenMatchBookingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;

  // Reactive variables
  RxString selectedSlot = 'Morning'.obs;
  RxBool showFilter = false.obs;

  final List<String> slots = ['Morning', 'Afternoon', 'Evening'];
  final List<String> categories = ['Level A', 'Level B', 'Level C'];

  final RxString selectedCategory = 'Select Category'.obs;
  final RxString selectedLevel = ''.obs;
  final RxList<String> selectedTimings = <String>[].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final GlobalKey dropdownKey = GlobalKey();

  // Loading and data state
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool showNoInternetScreen = false.obs;
  RxList<OpenMatchBookingData> openMatchesList = <OpenMatchBookingData>[].obs;

  // Pagination
  RxInt currentPage = 1.obs;
  RxBool hasMoreData = true.obs;
  final int pageSize = 10;

  // Misc
  final OpenMatchRepository repository = Get.put(OpenMatchRepository());
  RxString argument = "".obs;

  @override
  void onInit() {
    super.onInit();

    // Handle arguments safely
    final args = Get.arguments;
    if (args is Map && args.containsKey("type")) {
      argument.value = args["type"];
    } else {
      argument.value = "upcoming";
    }

    // Initialize TabController
    try {
      tabController = TabController(length: 2, vsync: this);
      tabController!.addListener(_handleTabChange);
    } catch (e) {
      CustomLogger.logMessage(
        msg: "TabController initialization failed: $e",
        level: LogLevel.error,
      );
    }

    // Initial data load
    fetchOpenMatchesBooking(type: 'upcoming');
  }

  void _handleTabChange() {
    if (tabController == null) return;

    // When tab index changes (and animation finishes)
    if (!tabController!.indexIsChanging) {
      resetPagination();
      String type = tabController!.index == 0 ? 'upcoming' : 'completed';
      fetchOpenMatchesBooking(type: type);
    }
  }

  // Reset pagination and clear list
  void resetPagination() {
    currentPage.value = 1;
    hasMoreData.value = true;
    openMatchesList.clear();
  }

  void selectSlot(String slot) => selectedSlot.value = slot;

  Future<void> selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: now,
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 14),
            bodyMedium: TextStyle(fontSize: 12),
          ),
        ),
        child: child!,
      ),
    );

    if (pickedDate != null) selectedDate.value = pickedDate;
  }

  void clearAll() {
    selectedDate.value = DateTime.now();
    selectedTimings.clear();
    selectedLevel.value = '';
  }

  Future<void> fetchOpenMatchesBooking({
    required String type,
    bool isLoadMore = false,
  }) async {
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

      if (response != null && response.data != null && response.data!.isNotEmpty) {
        final newData = response.data!;

        if (isLoadMore) {
          openMatchesList.addAll(newData);
        } else {
          openMatchesList.value = newData;
        }

        hasMoreData.value = newData.length >= pageSize;
      } else {
        if (!isLoadMore) openMatchesList.clear();
        hasMoreData.value = false;
      }
    } catch (e) {
      CustomLogger.logMessage(msg: "Error fetching matches: $e", level: LogLevel.error);
      if (!isLoadMore) openMatchesList.clear();
      hasMoreData.value = false;
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreData() async {
    if (!hasMoreData.value || isLoadingMore.value) return;
    currentPage.value++;
    final type = tabController?.index == 0 ? 'upcoming' : 'completed';
    await fetchOpenMatchesBooking(type: type ?? 'upcoming', isLoadMore: true);
  }
  Future<void> retryFetch() async {
    showNoInternetScreen.value = false;
    resetPagination();
    final type = tabController?.index == 0 ? 'upcoming' : 'completed';
    await fetchOpenMatchesBooking(type: type ?? 'upcoming');
  }

  @override
  void onClose() {
    tabController?.removeListener(_handleTabChange);
    tabController?.dispose();
    super.onClose();
  }
}

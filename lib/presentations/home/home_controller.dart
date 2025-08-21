import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/data/request_models/booking/boking_history_model.dart';
import 'package:padel_mobile/handler/logger.dart';
import 'package:padel_mobile/presentations/booking/booking_controller.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';
import 'package:padel_mobile/repositories/bookinghisory/booking_history_repository.dart';
import 'package:padel_mobile/services/notification_service/firebase_notification.dart';
import '../../data/request_models/home_models/get_club_name_model.dart';
import '../../repositories/home_repository/home_repository.dart';

class HomeController extends GetxController {
  ProfileController profileController = Get.put(ProfileController());
  // LOCATION ------------------------------------------------------------------
  final RxString selectedLocation = ''.obs;
  RxBool showLocationAndDate = false.obs;
  ScrollController scrollController = ScrollController();
  BookingController bookingController = Get.put(BookingController());

  // NotificationService notificationService = NotificationService();
  final List<String> dummyLocations = [    'Delhi',
    'Mumbai',
    'Bangalore',
    'Hyderabad',
    'Chennai',
    'Pune',
    'Kolkata',
    'Jaipur',
    'Ahmedabad',
    'Chandigarh',
  ];

  // DATE -------------------------
  var selectedDate = DateTime.now().obs;

  Future<void> selectDate(BuildContext context) async {
    try {
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
                titleLarge: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
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
    } catch (e) {
      log("Error selecting date: $e");
      // Handle date selection error gracefully
    }
  }

  // CLUB DATA -----------------------------------------------------------------
  final HomeRepository clubRepository = HomeRepository();

  // Using nullable type for proper null handling
  Rx<CourtsModel?> courtsData = Rx<CourtsModel?>(null);
  RxBool isLoadingClub = false.obs;
  RxBool isLoadingMore = false.obs;
  RxString clubError = ''.obs;
  RxInt currentPage = 1.obs;
  final int limit = 20;
  RxString searchQuery = ''.obs;
  RxBool hasMoreData = true.obs;

  RxBool isInitialized = false.obs;
  RxInt totalCourts = 0.obs;

  /// Fetch clubs with pagination and comprehensive error handling
  Future<void> fetchClubs({bool isRefresh = false}) async {
    try {
      log(
        "Fetching clubs - Page: ${currentPage.value}, Search: ${searchQuery.value}",
      );
      if (isRefresh || currentPage.value == 1) {
        isLoadingClub.value = true;
        clubError.value = '';
      } else {
        isLoadingMore.value = true;
      }

      // Make API call
      final result = await clubRepository.fetchClubData(
        limit: limit.toString(),
        page: currentPage.value.toString(),
        search: searchQuery.value,
      );

      log("Courts length ${result.data!.courts!.length}");

      // Handle successful response
      if (isRefresh || currentPage.value == 1) {
        courtsData.value = result;
      } else {
        if (courtsData.value != null &&
            courtsData.value!.data != null &&
            courtsData.value!.data!.courts != null &&
            result.data != null &&
            result.data!.courts != null) {
          final existingCourts = courtsData.value!.data!.courts!;
          final newCourts = result.data!.courts!;

          // Merge courts data
          existingCourts.addAll(newCourts);

          // Update total count
          totalCourts.value = existingCourts.length;

          // Check if more data is available
          hasMoreData.value = newCourts.length >= limit;
        }
      }

      // Update total count
      if (courtsData.value?.data?.courts != null) {
        totalCourts.value = courtsData.value!.data!.courts!.length;
      }

      // Clear any existing errors
      clubError.value = '';
      isInitialized.value = true;

      log(
        "Successfully fetched ${courtsData.value?.data?.courts?.length ?? 0} courts",
      );
    } catch (e) {
      log("Error fetching clubs: $e");

      // Set appropriate error message
      if (e.toString().contains('network') ||
          e.toString().contains('connection')) {
        clubError.value =
            'Network error. Please check your connection and try again.';
      } else if (e.toString().contains('timeout')) {
        clubError.value = 'Request timeout. Please try again.';
      } else if (e.toString().contains('server')) {
        clubError.value = 'Server error. Please try again later.';
      } else {
        clubError.value = 'Failed to load courts. Please try again.';
      }

      // If this is the first load, set courtsData to null
      if (!isInitialized.value) {
        courtsData.value = null;
      }
    } finally {
      // Reset loading states
      isLoadingClub.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Load more data for pagination
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    currentPage.value++;
    await fetchClubs();
  }

  /// Search clubs with debouncing
  void searchClubs(String query) {
    searchQuery.value = query.trim();
    currentPage.value = 1;
    hasMoreData.value = true;
    fetchClubs(isRefresh: true);
  }

  /// Retry fetching data
  Future<void> retryFetch() async {
    clubError.value = '';
    currentPage.value = 1;
    hasMoreData.value = true;
    await fetchClubs(isRefresh: true);
    await fetchBookings();
  }

  /// Check if courts data is available
  bool get hasCourtsData {
    return courtsData.value != null &&
        courtsData.value!.data != null &&
        courtsData.value!.data!.courts != null &&
        courtsData.value!.data!.courts!.isNotEmpty;
  }

  /// Get courts list safely
  List<dynamic> get courtsList {
    if (hasCourtsData) {
      return courtsData.value!.data!.courts!;
    }
    return [];
  }

  /// Get courts count safely
  int get courtsCount {
    return courtsList.length;
  }

  @override
  void onInit() {
    super.onInit();
  //   notificationService.initialize();
  //   var token = notificationService.getToken();
  // log("Firebase Token $token");

    // Initialize scroll controller listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMore();
      }
    });

    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchClubs(isRefresh: true);
      await fetchBookings();
    });
  }

  // @override
  // void onClose() {
  //   scrollController.dispose();
  //   super.onClose();
  // }

  /// Clear search and reset data
  void clearSearch() {
    searchQuery.value = '';
    currentPage.value = 1;
    hasMoreData.value = true;
    fetchClubs(isRefresh: true);
  }

  /// Update selected location
  void updateLocation(String location) {
    selectedLocation.value = location;
    // Optionally refresh data based on location
  }

  ///Your Bookings--------------------------------------------------------------
  var bookings = Rxn<BookingHistoryModel>();
  BookingHistoryRepository bookingHistoryRepository = Get.put(BookingHistoryRepository());
  Future<void> fetchBookings()async{
    isLoadingClub.value = true;
    try{
      final response = await bookingHistoryRepository.getBookingHistory(type: "upcoming");
      bookings.value = response;
      if(response.success== true){
        isLoadingClub.value = false;
        CustomLogger.logMessage(msg: "Booking fetched", level: LogLevel.debug);
      }

    }catch(e){
      CustomLogger.logMessage(msg: e, level: LogLevel.error);
    }finally{
      isLoadingClub.value = false;
    }
  }
}

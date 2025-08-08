import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../data/request_models/booking/boking_history_model.dart';
import '../../repositories/bookinghisory/booking_history_repository.dart';
import '../auth/forgot_password/widgets/forgot_password_exports.dart';

class BookingHistoryController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final BookingHistoryRepository bookingRepo = BookingHistoryRepository();

  Rx<BookingHistoryModel?> upcomingBookings = Rx<BookingHistoryModel?>(null);
  Rx<BookingHistoryModel?> completedBookings = Rx<BookingHistoryModel?>(null);

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);

    // Add listener to tab changes for debugging
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        print("Current tab: ${tabController.index}");
        print("Upcoming bookings: ${upcomingBookings.value?.bookings?.length ?? 0}");
        print("Completed bookings: ${completedBookings.value?.bookings?.length ?? 0}");
      }
    });

    fetchBookings();
    super.onInit();
  }

  void fetchBookings() async {
    try {
      print("Starting to fetch booking data...");
      isLoading.value = true;
      errorMessage.value = '';

      // Fetch upcoming bookings
      print("Fetching upcoming bookings...");
      final upcoming = await bookingRepo.getBookingHistory(type: "upcoming");
      print("Upcoming response received");
      upcomingBookings.value = upcoming;
      print("Upcoming bookings count: ${upcoming.bookings?.length ?? 0}");

      // Fetch completed bookings
      print("Fetching completed bookings...");
      final completed = await bookingRepo.getBookingHistory(type: "completed");
      print("Completed response received");
      completedBookings.value = completed;
      print("Completed bookings count: ${completed.bookings?.length ?? 0}");

      // Trigger UI update
      update();

    } catch (e) {
      print("Error fetching bookings: $e");
      errorMessage.value = "Failed to fetch bookings: $e";
    } finally {
      isLoading.value = false;
      print("Finished fetching bookings. Loading: ${isLoading.value}");
    }
  }

  // Method to refresh bookings
  void refreshBookings() {
    fetchBookings();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
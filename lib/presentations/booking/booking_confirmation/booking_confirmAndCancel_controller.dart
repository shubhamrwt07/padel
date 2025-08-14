import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/components/snack_bars.dart';
import '../../../data/request_models/booking/booking_confermation_model.dart';
import '../../../data/request_models/booking/cancel_booking_model.dart';
import '../../../handler/logger.dart';
import '../../../repositories/bookinghisory/booking_history_repository.dart';

class BookingConfirmAndCancelController extends GetxController {
  RxBool cancelBooking = false.obs;
  RxString selectedReason = ''.obs;
  var updateBookingStatusResponse = Rxn<CancelUserBooking>();
  TextEditingController otherReasonController = TextEditingController();

  // Booking details state
  Rx<BookingConfirmationModel?> bookingDetails = Rx<BookingConfirmationModel?>(null);
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  List<String> cancellationReasons = [
    "Change of plans",
    "Found better timing",
    "Other"
  ];

  final BookingHistoryRepository _bookingRepo = BookingHistoryRepository();

  @override
  void onInit() async {
    super.onInit();

    // Get bookingId from arguments
    final String? bookingId = Get.arguments?['id'];

    if (bookingId != null && bookingId.isNotEmpty) {
      await fetchBookingDetails(bookingId);
    } else {
      error.value = "No booking ID provided";
    }
  }

  /// Fetch booking details using bookingId (_id in API)
  /// Fetch booking details using bookingId (_id in API)
  Future<void> fetchBookingDetails(String bookingId) async {
    try {
      isLoading.value = true;
      error.value = '';

      if (kDebugMode) {
        print("Fetching booking details for bookingId: $bookingId");
      }

      // Call the repo function using correct parameter name
      final booking = await _bookingRepo.getBookingConfirmation(
        id: bookingId, // matches repo function parameter
      );

      bookingDetails.value = booking;

      if (booking.booking != null) {
        log("Booking details fetched! Status: ${booking.booking!.bookingStatus}");
      } else {
        log("No booking found for this ID");
      }
    } catch (e) {
      error.value = e.toString();
      if (kDebugMode) {
        print("Error fetching booking details: $e");
      }
      Get.snackbar(
        "Error",
        "Failed to fetch booking details. Please try again.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update booking status
  Future<void> updateBookingStatus() async {
    if (isLoading.value || Get.isSnackbarOpen) return;

    // Ensure booking details are available
    if (bookingDetails.value == null || bookingDetails.value!.booking == null) {
      SnackBarUtils.showInfoSnackBar("Booking details not available");
      return;
    }

    if (otherReasonController.text.trim().isEmpty) {
      SnackBarUtils.showInfoSnackBar("Please enter the reason");
      return;
    }

    isLoading.value = true;

    try {
      final body = {
        "id": bookingDetails.value!.booking!.sId, // single booking object
        "status": "in-progress",
        "cancellationReason": otherReasonController.text.trim()
      };

      final result = await _bookingRepo.updateBookingStatus(body: body);
      updateBookingStatusResponse.value = result;

      if (result?.status == "200") {
        // Allow getBookingHistory to run by resetting isLoading
        isLoading.value = false;

        // Close dialogs/pages after refresh
        Get.close(2);

        CustomLogger.logMessage(
          msg: result?.message ?? "Updated",
          level: LogLevel.debug,
        );
        SnackBarUtils.showSuccessSnackBar(result?.message ?? "Updated");
        otherReasonController.clear();
      } else {
        print("Booking Update Failed");
      }
    } catch (e) {
      CustomLogger.logMessage(msg: e, level: LogLevel.error);
    } finally {
      // Ensure isLoading is reset in case of errors
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otherReasonController.dispose();
    super.onClose();
  }
}

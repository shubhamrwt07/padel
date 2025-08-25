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

  // Track which slot is being cancelled
  RxnString slotToCancel = RxnString();

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

    final String? bookingId = Get.arguments?['id'];
    if (bookingId != null && bookingId.isNotEmpty) {
      await fetchBookingDetails(bookingId);
    } else {
      error.value = "No booking ID provided";
    }
  }

  /// Fetch booking details
  Future<void> fetchBookingDetails(String bookingId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final booking = await _bookingRepo.getBookingConfirmation(id: bookingId);
      bookingDetails.value = booking;

      if (booking.booking != null) {
        log("Booking details fetched! Status: ${booking.booking!.bookingStatus}");
      } else {
        log("No booking found for this ID");
      }
    } catch (e) {
      error.value = e.toString();
      if (kDebugMode) print("Error fetching booking details: $e");
      Get.snackbar("Error", "Failed to fetch booking details. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update booking status
  Future<void> updateBookingStatus() async {
    if (isLoading.value || Get.isSnackbarOpen) return;

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
      final bookingId = bookingDetails.value!.booking!.sId;
      final slotId = slotToCancel.value;

      final body = {
        "id": bookingId,
        "status": "in-progress",
        "cancellationReason": otherReasonController.text.trim(),
        if (slotId != null) "slotId": slotId, // ✅ only send slotId when needed
      };

      final result = await _bookingRepo.updateBookingStatus(body: body);
      updateBookingStatusResponse.value = result;

      if (result?.status == "200") {
        isLoading.value = false;

        // Refresh booking details
        await fetchBookingDetails(bookingId!);

        // Reset state
        cancelBooking.value = false;
        slotToCancel.value = null;

        CustomLogger.logMessage(
          msg: result?.message ?? "Updated",
          level: LogLevel.debug,
        );
        SnackBarUtils.showSuccessSnackBar(result?.message ?? "Updated");
        otherReasonController.clear();
      } else {
        SnackBarUtils.showErrorSnackBar("Booking update failed");
      }
    } catch (e) {
      CustomLogger.logMessage(msg: e, level: LogLevel.error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otherReasonController.dispose();
    super.onClose();
  }
}

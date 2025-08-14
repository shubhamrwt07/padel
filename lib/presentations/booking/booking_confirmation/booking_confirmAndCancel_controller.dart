import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../configs/components/snack_bars.dart';
import '../../../data/request_models/booking/booking_confermation_model.dart';
import '../../../data/request_models/booking/cancel_booking_model.dart';
import '../../../handler/logger.dart';
import '../../../repositories/bookinghisory/booking_history_repository.dart';
import '../../auth/forgot_password/widgets/forgot_password_exports.dart';

class BookingConfirmAndCancelController extends GetxController {
  RxBool cancelBooking = false.obs;
  RxString selectedReason = ''.obs;
  var  updateBookingStatusResponse=Rxn<CancelUserBooking>();
  TextEditingController otherReasonController = TextEditingController();

  // Add reactive variables for booking data
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

    // Get the ownerId (and optionally bookingId) from arguments
    final String? ownerId = Get.arguments?['ownerId'];
    final String? bookingId = Get.arguments?['bookingId'];

    if (ownerId != null && ownerId.isNotEmpty) {
      await fetchBookingDetails(ownerId, bookingId: bookingId);
    }
  }

  /// Fetch booking details by bookingId
  Future<void> fetchBookingDetails(String ownerId, {String? bookingId}) async {
    try {
      isLoading.value = true;
      error.value = '';

      if (kDebugMode) {
        print("Fetching booking details for Owner ID: $ownerId"
            "${bookingId != null ? ' with Booking ID: $bookingId' : ''}");
      }

      final booking = await _bookingRepo.getBookingConfirmation(
        ownerId: ownerId,
        bookingId: bookingId, // optional
      );

      bookingDetails.value = booking;

      log("Booking details fetched! Status: ${booking.status}");
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
  Future<void> updateBookingStatus() async {
    if (isLoading.value || Get.isSnackbarOpen) return;

    // Check if booking details are available
    if (bookingDetails.value == null ||
        bookingDetails.value!.bookings == null ||
        bookingDetails.value!.bookings!.isEmpty) {
      SnackBarUtils.showInfoSnackBar("Booking details not available");
      return;
    }

    if(otherReasonController.text.trim().isEmpty){
      SnackBarUtils.showInfoSnackBar("Please enter the reason");
      return;
    }

    isLoading.value = true;

    try {
      final body = {
        "id": bookingDetails.value!.bookings!.first.sId, // Access sId from the first booking
        "status": "in-progress",
        "cancellationReason": otherReasonController.text.trim()
      };

      final result = await _bookingRepo.updateBookingStatus(body: body);
      updateBookingStatusResponse.value = result;

      if (result?.status == "200") {
        // Allow getBookingHistory to run by resetting isLoading
        isLoading.value = false;

        // Hit API before closing the screen

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
  }  @override
  void onClose() {
    otherReasonController.dispose();
    super.onClose();
  }
}
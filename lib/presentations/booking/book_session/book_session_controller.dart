import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import '../../../data/request_models/home_models/get_available_court.dart';
import '../../../data/request_models/home_models/get_club_name_model.dart';
import '../../../repositories/cart/cart_repository.dart';
import '../../../repositories/home_repository/home_repository.dart';

class BookSessionController extends GetxController {
  RxBool viewUnavailableSlots = false.obs;
  RxList<String> selectedTimes = <String>[].obs;
  RxMap<String, int> selectedSlotAmounts = <String, int>{}.obs;
  RxBool isLoading = false.obs;
  List<Map<String, dynamic>> addedCartSlots = [];
  double get totalAmount =>
      selectedSlotAmounts.values.fold(0, (sum, amt) => sum + amt);

  final selectedDate = Rxn<DateTime>();
  Courts argument = Courts();

  final List<String> timeSlots = List.generate(18, (index) {
    final hour = 6 + index;
    final period = hour >= 12 ? 'pm' : 'am';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    return '${formattedHour == 0 ? 12 : formattedHour}:00$period';
  });

  final HomeRepository repository = HomeRepository();
  final CartRepository cartRepository = CartRepository(); // ✅ Inject cart repo

  Rx<AvailableCourtModel?> availableCourtData = Rx<AvailableCourtModel?>(null);
  RxBool isLoadingCourts = false.obs;
  RxString courtErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    argument = Get.arguments['data'];
    selectedDate.value = DateTime.now(); // ✅ Ensure it's initialized

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final nextSlot = timeSlots.firstWhere(
            (time) => !isPastTimeSlot(time),
        orElse: () => timeSlots.last,
      );

      await getAvailableCourtsById(argument.id!, nextSlot);
      autoSelectFirstAvailableSlot();
    });
  }

  void autoSelectFirstAvailableSlot() {
    final courts = availableCourtData.value?.data;
    if (courts == null || courts.isEmpty) return;

    final slotTimes = courts[0].slot?.first.slotTimes;
    if (slotTimes == null || slotTimes.isEmpty) return;

    if (selectedTimes.isEmpty) {
      final firstAvailable = slotTimes.firstWhereOrNull(
            (s) => !isPastTimeSlot(s.time!),
      );

      if (firstAvailable != null && firstAvailable.amount != null) {
        selectedTimes.add(firstAvailable.time!);
        selectedSlotAmounts[firstAvailable.time!] = firstAvailable.amount!;
        update();
      }
    }
  }

  void toggleTimeSlot(String time) {
    final courts = availableCourtData.value?.data;
    final slotTimes = courts?[0].slot?[0].slotTimes;
    final slot = slotTimes?.firstWhereOrNull((s) => s.time == time);

    if (selectedTimes.contains(time)) {
      selectedTimes.remove(time);
      selectedSlotAmounts.remove(time);
    } else {
      selectedTimes.add(time);
      if (slot != null && slot.amount != null) {
        selectedSlotAmounts[time] = slot.amount!;
      }
    }

    update();
  }

  bool isPastTimeSlot(String timeLabel) {
    final now = DateTime.now();
    final selected = selectedDate.value ?? now;

    final match = RegExp(r'(\d+):00(am|pm)', caseSensitive: false).firstMatch(timeLabel);
    if (match == null) return false;

    int hour = int.parse(match.group(1)!);
    String period = match.group(2)!;

    if (period.toLowerCase() == 'pm' && hour != 12) hour += 12;
    if (period.toLowerCase() == 'am' && hour == 12) hour = 0;

    final slotDateTime = DateTime(
      selected.year,
      selected.month,
      selected.day,
      hour,
    );

    // Compare only if selected date is today
    final isToday = selected.year == now.year &&
        selected.month == now.month &&
        selected.day == now.day;

    return isToday && slotDateTime.isBefore(now);
  }

  Future<void> getAvailableCourtsById(String registerClubId, [String searchTime = '']) async {
    log("Fetching courts for time: $searchTime");
    isLoadingCourts.value = true;
    courtErrorMessage.value = '';
    availableCourtData.value = null;

    try {
      final date = selectedDate.value ?? DateTime.now();
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final formattedDay = _getWeekday(date.weekday);

      final result = await repository.fetchAvailableCourtsById(
        id: registerClubId,
        time: searchTime,
        date: formattedDate, // ✅ FIXED: pass correct date here
        day: formattedDay,
      );

      availableCourtData.value = result;
      log("Available courts fetched: ${result.data?[0].slot?.length ?? 0}");
    } catch (e) {
      courtErrorMessage.value = "Something went wrong";
      selectedSlotAmounts[searchTime] = 0;
      log("Error: $e");
    } finally {
      isLoadingCourts.value = false;
    }
  }
  Future<void> addSelectedSlotsToCart() async {
    if (selectedTimes.isEmpty || selectedDate.value == null) {
      Get.snackbar("Error", "Please select at least one time slot.");
      return;
    }
    final formattedDate = selectedDate.value!.toIso8601String();
    final courts = availableCourtData.value?.data;
    if (courts == null || courts.isEmpty || courts[0].slot == null || courts[0].slot!.isEmpty) {
      Get.snackbar("Error", "Slot ID not found.");
      return;
    }
    final slot = courts[0].slot![0];
    final slotId = slot.sId;
    if (slotId == null) {
      Get.snackbar("Error", "Invalid slot ID.");
      return;
    }
    // 🔍 Check if same slotId and any of the times already exist in cart
    final existingMatch = addedCartSlots.any((cartSlot) {
      final isSameSlot = cartSlot["slotId"] == slotId;
      final isSameDate = cartSlot["bookingDate"] == formattedDate;
      final existingTimes = (cartSlot["slotTimes"] as List).cast<String>().toSet();
      final overlap = existingTimes.intersection(selectedTimes.toSet());
      return isSameSlot && isSameDate && overlap.isNotEmpty;
    });

    if (existingMatch) {
      Get.snackbar("Info", "This slot already exists in your cart.");
      return;
    }

    // ✅ Convert selected times to payload format (avoid duplicates)
    final slotTimes = selectedTimes.toSet().map((time) {
      final amount = selectedSlotAmounts[time] ?? 0;
      return {
        "time": time,
        "amount": amount,
      };
    }).toList();

    final slotData = {
      "slot": [
        {
          "slotId": slotId,
          "businessHours": slot.businessHours ?? [],
          "slotTimes": slotTimes,
        }
      ],
      "register_club_id": argument.id,
      "bookingDate": formattedDate,
    };

    log("Slot Data to Add to Cart: ${jsonEncode(slotData)}");

    isLoading.value = true;
    try {
      await cartRepository.addCartItems(data: slotData);

      // ✅ Save this to local memory to prevent re-adding
      addedCartSlots.add({
        "slotId": slotId,
        "bookingDate": formattedDate,
        "slotTimes": selectedTimes.toList(), // Defensive copy
      });

      // ✅ Clear selections after successful add
      selectedTimes.clear();
      selectedSlotAmounts.clear();
      update();

      Get.snackbar("Success", "Selected slots added to cart.");
    } catch (e) {
      if (e is DioException) {
        log("Dio error: ${e.message}");
        log("Dio response data: ${e.response?.data}");
      } else {
        log("Unexpected error: $e");
      }

      Get.snackbar("Error", "Failed to add items to cart.");
    } finally {
      isLoading.value = false;
    }
  }


  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}

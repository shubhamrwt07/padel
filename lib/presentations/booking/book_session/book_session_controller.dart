import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

import '../../../data/request_models/home_models/get_available_court.dart' hide Courts;
import '../../../data/request_models/home_models/get_club_name_model.dart';
import '../../../data/response_models/cart/add_to_cart_items_model.dart' hide SlotTimes;
import '../../../repositories/cart/cart_repository.dart';
import '../../../repositories/home_repository/home_repository.dart';

class BookSessionController extends GetxController {
  final selectedDate = Rxn<DateTime>();
  Courts argument = Courts();

  RxList<SlotTimes> selectedSlots = <SlotTimes>[].obs;
  RxInt totalAmount = 0.obs;
  final HomeRepository repository = HomeRepository();
  Rx<AvailableCourtModel?> slots = Rx<AvailableCourtModel?>(null);
  RxBool isLoadingCourts = false.obs;
  CartRepository cartRepository = CartRepository();

  @override
  void onInit() {
    super.onInit();
    argument = Get.arguments['data'];
    selectedDate.value = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAvailableCourtsById(argument.id!);
    });
  }
  Future<void> getAvailableCourtsById(String registerClubId) async {
    log("Fetching courts for club: $registerClubId");
    isLoadingCourts.value = true;
    slots.value = null;
    selectedSlots.clear(); // Clear previous selection

    try {
      final date = selectedDate.value ?? DateTime.now();
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final formattedDay = _getWeekday(date.weekday);

      final result = await repository.fetchAvailableCourtsById(
        id: registerClubId,
        time: '',
        date: formattedDate,
        day: formattedDay,
      );

      slots.value = result;
      log("Available courts fetched: ${result.data?[0].slot?.length ?? 0}");

      // Auto-select first available slot
      final slotTimes = result.data?[0].slot?[0].slotTimes;
      if (slotTimes != null && slotTimes.isNotEmpty) {
        final firstSlot = slotTimes.firstWhereOrNull((slot) => !isPastAndUnavailable(slot));
        if (firstSlot != null) {
          selectedSlots.add(firstSlot);
          // Update total amount
          totalAmount.value = firstSlot.amount ?? 0;

          log("Auto-selected first slot: ${firstSlot.time}");
        }
      }

    } catch (e) {
      log("Error: $e");
    } finally {
      isLoadingCourts.value = false;
    }
  }



  void toggleSlotSelection(SlotTimes slot) {
    if (selectedSlots.contains(slot)) {
      selectedSlots.remove(slot);
    } else {
      selectedSlots.add(slot);
    }

    // Recalculate total amount
    totalAmount.value = selectedSlots.fold(
      0,
          (sum, slot) => sum + (slot.amount ?? 0),
    );

    log("ID ${slot.sId!} LEN ${selectedSlots.length} TOTAL ₹${totalAmount.value}");
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

  bool isPastAndUnavailable(SlotTimes slot) {
    if (slot.status != "available") return true;

    final now = DateTime.now();
    final selected = selectedDate.value ?? now;

    // Parse slot time like "8 am" or "9 pm"
    final slotTimeParts = slot.time!.toLowerCase().split(" ");
    int hour = int.parse(slotTimeParts[0]);
    if (slotTimeParts[1] == "pm" && hour != 12) hour += 12;
    if (slotTimeParts[1] == "am" && hour == 12) hour = 0;

    final slotDateTime = DateTime(selected.year, selected.month, selected.day, hour);

    // If selected day is today, compare with current time
    final isToday = selected.year == now.year &&
        selected.month == now.month &&
        selected.day == now.day;

    if (isToday && slotDateTime.isBefore(DateTime(now.year, now.month, now.day, now.hour))) {
      return true;
    }

    return false;
  }

  void addToCart() async {
    try {
      if (isLoadingCourts.value) return;
      isLoadingCourts.value = true;

      // Group selected slots by selectedDate
      final Map<String, List<SlotTimes>> groupedSlots = {};
      final selectedDateStr = "${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}";


      groupedSlots[selectedDateStr] = selectedSlots.toList();

      final List<Map<String, dynamic>> slotTimesList = [];

      // Build slotTimes list with date grouping
      groupedSlots.forEach((date, slots) {
        for (var slot in slots) {
          slotTimesList.add({
            "time": slot.time,
            "amount": slot.amount,
            "slotId": slot.sId,
          });
        }
        slotTimesList.add({
          "bookingDate": date,
        });
      });

      final data = {
        "slot": [
          {
            "businessHours": [
              {
                "time": slots.value!.data?[0].registerClubId!.businessHours?[0].time,
                "day": slots.value!.data?[0].registerClubId!.businessHours?[0].day
              }
            ],
            "slotTimes": slotTimesList
          }
        ],
        "register_club_id": argument.id!,
        "courtId": slots.value!.data?[0].courts?[0].sId,
      };

      log("Cart Data: $data");

      await cartRepository.addCartItems(data: data).then((v) {
        Get.to(() => CartScreen(buttonType: "true"));
      });
    } finally {
      isLoadingCourts.value = false;
    }
  }

}

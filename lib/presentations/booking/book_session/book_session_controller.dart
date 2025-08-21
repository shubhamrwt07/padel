import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

import '../../../data/request_models/home_models/get_available_court.dart' hide Courts;
import '../../../data/request_models/home_models/get_club_name_model.dart';
import '../../../repositories/cart/cart_repository.dart';
import '../../../repositories/home_repository/home_repository.dart';
import '../../cart/cart_controller.dart';

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
  Future<void> getAvailableCourtsById(String registerClubId, {String? selectedCourtId}) async {
    log("Fetching courts for club: $registerClubId, court: $selectedCourtId");
    isLoadingCourts.value = true;
    slots.value = null;
    selectedSlots.clear();

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
        courtId: selectedCourtId ?? '',   // ✅ pass courtId to API
      );

      slots.value = result;
      log("Available courts fetched for courtId: ${selectedCourtId ?? 'first court'}");

      // ✅ If no court selected, pick first one from API
      if (courtId.value.isEmpty) {
        final firstCourt = result.data?.first.courts?.first;
        if (firstCourt != null) {
          courtId.value = firstCourt.sId ?? '';
          courtName.value = firstCourt.courtName ?? '';
        }
      }

      // ✅ Get slots for the selected court
      final selectedCourtSlots = getSlotsForCourt(courtId.value);
      if (selectedCourtSlots.isNotEmpty) {
        final firstSlot = selectedCourtSlots.firstWhereOrNull(
                (slot) => !isPastAndUnavailable(slot));
        if (firstSlot != null) {
          selectedSlots.add(firstSlot);
          totalAmount.value = firstSlot.amount ?? 0;
          log("Auto-selected first slot for court ${courtName.value}: ${firstSlot.time}");
        }
      }
    } catch (e) {
      log("Error: $e");
    } finally {
      isLoadingCourts.value = false;
    }
  }

  /// ✅ Helper: return slots for the selected court
  List<SlotTimes> getSlotsForCourt(String courtId) {
    final data = slots.value?.data ?? [];
    for (var slot in data) {
      final courts = slot.courts ?? [];
      for (var court in courts) {
        if (court.sId == courtId) {
          return slot.slot?.first.slotTimes ?? [];
        }
      }
    }
    return [];
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
    final slotTimeParts = slot.time!.toLowerCase().split(" ");
    int hour = int.parse(slotTimeParts[0]);
    if (slotTimeParts[1] == "pm" && hour != 12) hour += 12;
    if (slotTimeParts[1] == "am" && hour == 12) hour = 0;
    final slotDateTime = DateTime(selected.year, selected.month, selected.day, hour);
    final isToday = selected.year == now.year &&
        selected.month == now.month &&
        selected.day == now.day;
    if (isToday && slotDateTime.isBefore(DateTime(now.year, now.month, now.day, now.hour))) {
      return true;
    }
    return false;
  }
  var courtName = ''.obs;
  var courtId= ''.obs;
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
        "courtName": courtName.value,
        "courtId":courtId.value,

      };

      log("Cart Data: $data");

      await cartRepository.addCartItems(data: data).then((v) async {
        // Fetch cart items immediately after adding to cart
        final CartController controller = Get.find<CartController>();
        await controller.getCartItems();

        // Navigate to cart screen
        Get.to(() => CartScreen(buttonType: "true"))?.then((_) {
          // Optional: Refresh cart items again when returning from cart screen
          controller.getCartItems();
        });
      });
    } finally {
      isLoadingCourts.value = false;
    }
  }
}

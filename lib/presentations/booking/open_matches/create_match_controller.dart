import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import '../../../data/request_models/home_models/get_available_court.dart' hide Courts;
import '../../../data/request_models/home_models/get_club_name_model.dart';
import '../../../repositories/cart/cart_repository.dart';
import '../../../repositories/home_repository/home_repository.dart';
import '../../cart/cart_controller.dart';
class CreateOpenMatchesController extends GetxController {
  final selectedDate = Rxn<DateTime>();
  Courts argument = Courts();
  RxBool showUnavailableSlots = false.obs;

  RxList<SlotTimes> selectedSlots = <SlotTimes>[].obs;
  RxInt totalAmount = 0.obs;
  final HomeRepository repository = HomeRepository();
  Rx<AvailableCourtModel?> slots = Rx<AvailableCourtModel?>(null);
  RxBool isLoadingCourts = false.obs;
  CartRepository cartRepository = CartRepository();

  var courtName = ''.obs;
  var courtId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    argument = Get.arguments['data'];
    selectedDate.value = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadCourtsAndSetFirst();
      if (courtId.value.isNotEmpty) {
        await getAvailableCourtsById(argument.id!, selectedCourtId: courtId.value);
      }
    });
  }

  @override
  void onClose() {
    selectedSlots.clear();
    totalAmount.value = 0;
    super.onClose();
  }
  Future<void> loadCourtsAndSetFirst() async {
    isLoadingCourts.value = true;
    try {
      final date = selectedDate.value ?? DateTime.now();
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final formattedDay = _getWeekday(date.weekday);

      // Call the same repository method but without courtId filter
      final result = await repository.fetchAvailableCourtsById(
        id: argument.id!,
        time: '',
        date: formattedDate,
        day: formattedDay,
        courtId: '',
      );

      // Set slots (so UI can show courts list too if needed)
      slots.value = result;

      // Pick the first court
      final firstCourt = result.data?.first.courts?.first;
      if (firstCourt != null) {
        courtId.value = firstCourt.sId ?? '';
        courtName.value = firstCourt.courtName ?? '';
        log("First court selected: ${courtName.value} (${courtId.value})");
      }
    } catch (e) {
      log("Error loading courts: $e");
    }finally{
      isLoadingCourts.value  =false;
    }
  }


  Future<void> getAvailableCourtsById(String clubId, {String? selectedCourtId}) async {
    log("Fetching courts for club: $clubId, court: $selectedCourtId");
    isLoadingCourts.value = true;
    // slots.value = null;
    selectedSlots.clear();

    try {
      final date = selectedDate.value ?? DateTime.now();
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final formattedDay = _getWeekday(date.weekday);

      final result = await repository.fetchAvailableCourtsById(
        id: clubId,
        time: '',
        date: formattedDate,
        day: formattedDay,
        courtId: selectedCourtId ?? '',
      );

      slots.value = result;
      log("Available courts fetched for clubId: $clubId, courtId: ${selectedCourtId ?? 'first court'}");

      // ✅ If no court selected, pick first one
      if (courtId.value.isEmpty) {
        final firstCourt = result.data?.first.courts?.first;
        if (firstCourt != null) {
          courtId.value = firstCourt.sId ?? '';
          courtName.value = firstCourt.courtName ?? '';
        }
      }

      // ✅ Auto-select first available slot
      final availableSlots = getSlotsForCourt(courtId.value)
          .where((s) => !isPastAndUnavailable(s))
          .toList();

      if (availableSlots.isNotEmpty && selectedSlots.isEmpty) {
        toggleSlotSelection(availableSlots.first);
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

  /// Mark past OR booked slots as unavailable
  bool isPastAndUnavailable(SlotTimes slot) {
    if (slot.status == "booked") return true;
    if (slot.status != "available") return true;

    final now = DateTime.now();
    final selected = selectedDate.value ?? now;

    // Parse slot time like "10 am", "10:30 am"
    final timeString = slot.time!.toLowerCase().trim();
    final parts = timeString.split(" ");
    final timePart = parts[0];
    final amPm = parts.length > 1 ? parts[1] : "";

    int hour = 0;
    int minute = 0;

    if (timePart.contains(":")) {
      final timePieces = timePart.split(":");
      hour = int.parse(timePieces[0]);
      minute = int.parse(timePieces[1]);
    } else {
      hour = int.parse(timePart);
    }

    if (amPm == "pm" && hour != 12) hour += 12;
    if (amPm == "am" && hour == 12) hour = 0;

    final slotDateTime = DateTime(
      selected.year,
      selected.month,
      selected.day,
      hour,
      minute,
    );

    final isToday = selected.year == now.year &&
        selected.month == now.month &&
        selected.day == now.day;

    if (isToday && now.isAfter(slotDateTime)) {
      return true; // past slot
    }

    return false;
  }
  void addToCart() async {
    try {
      if (isLoadingCourts.value) return;
      isLoadingCourts.value = true;

      // Group selected slots by selectedDate
      final Map<String, List<SlotTimes>> groupedSlots = {};
      final selectedDateStr =
          "${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}";

      groupedSlots[selectedDateStr] = selectedSlots.toList();

      final List<Map<String, dynamic>> slotTimesList = [];

      groupedSlots.forEach((date, slots) {
        for (var slot in slots) {
          slotTimesList.add({
            "time": slot.time,
            "amount": slot.amount,
            "slotId": slot.sId,
          });
        }

        // ✅ Add date for this group
        slotTimesList.add({
          "bookingDate": date,
        });
      });

// then add court info
      slotTimesList.add({
        "courtId": courtId.value,
      });

      slotTimesList.add({
        "courtName": courtName.value,
      });

      final data = {
        "slot": [
          {
            "businessHours": [
              {
                "time": slots.value!.data?[0].registerClubId!.businessHours?[0].time ?? "",
                "day": slots.value!.data?[0].registerClubId!.businessHours?[0].day ?? "",
              }
            ],
            "slotTimes": slotTimesList
          }
        ],
        "register_club_id": argument.id!,
      };

      log("Cart Data: $data");

      await cartRepository.addCartItems(data: data).then((v) async {
        final CartController controller = Get.find<CartController>();
        await controller.getCartItems();

        Get.to(() => CartScreen(buttonType: "true"))?.then((_) async {
          // ✅ Clear slots when returning back
          selectedSlots.clear();
          totalAmount.value = 0;

          // ✅ Refresh slots from API (so booked slot turns red)
          await getAvailableCourtsById(argument.id!, selectedCourtId: courtId.value);
        });
      });
    } finally {
      isLoadingCourts.value = false;
    }
  }
}
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import '../../../data/request_models/home_models/get_available_court.dart';
import '../../../data/request_models/home_models/get_club_name_model.dart';
import '../../../repositories/home_repository/home_repository.dart';

class BookSessionController extends GetxController {
  // UI state
  RxBool viewUnavailableSlots = false.obs;
  RxList<String> selectedTimes = <String>[].obs;
  RxMap<String, int> selectedSlotAmounts = <String, int>{}.obs;

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
  Rx<AvailableCourtModel?> availableCourtData = Rx<AvailableCourtModel?>(null);
  RxBool isLoadingCourts = false.obs;
  RxString courtErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    argument = Get.arguments['data'];
    selectedDate.value = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final nextSlot = timeSlots.firstWhere(
            (time) => !isPastTimeSlot(time),
        orElse: () => timeSlots.last,
      );

      await getAvailableCourtsById(argument.id!, nextSlot);

      // Select first available slot and amount
      autoSelectFirstAvailableSlot();
    });
  }

  /// Automatically select the first available (non-past) slot
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
        update(); // Notify GetBuilder/UI to rebuild
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

    update(); // Ensure UI reflects the changes
  }

  /// ✅ Updated: Check if the given time is in the past
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

    // Only mark past for today's date
    final today = DateTime(now.year, now.month, now.day);
    final isToday = selected.year == today.year &&
        selected.month == today.month &&
        selected.day == today.day;

    return isToday && slotDateTime.isBefore(now);
  }

  /// Fetch available courts with proper time/date/day
  Future<void> getAvailableCourtsById(
      String registerClubId, [
        String searchTime = '',
      ]) async {
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
        date: formattedDate,
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

  /// Helper to convert int weekday to string
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

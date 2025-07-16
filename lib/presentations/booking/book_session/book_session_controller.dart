import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

import '../../../data/request_models/home_models/get_available_court.dart';
import '../../../data/request_models/home_models/get_club_name_model.dart';
import '../../../repositories/home_repository/home_repository.dart';

class BookSessionController extends GetxController {
  // Slot UI state
  RxBool viewUnavailableSlots = false.obs;
  RxString selectedAmount = '0'.obs;

  RxList<String> selectedTimes = <String>[].obs;
  final selectedDate = Rxn<DateTime>();
  Courts argument = Courts();
  final List<String> timeSlots = List.generate(19, (index) {
    final hour = 6 + index;
    if (hour == 24) return '12:00am';
    final period = hour >= 12 ? 'pm' : 'am';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    return '${formattedHour == 0 ? 12 : formattedHour}:00$period';
  });

  // Available courts logic
  final HomeRepository repository = HomeRepository();
  Rx<AvailableCourtModel?> availableCourtData = Rx<AvailableCourtModel?>(null);
  RxBool isLoadingCourts = false.obs;
  RxString courtErrorMessage = ''.obs;

  bool isPastTimeSlot(String timeLabel) {
    final selected = selectedDate.value ?? DateTime.now();

    final match = RegExp(
      r'(\d+):00(am|pm)',
    ).firstMatch(timeLabel.toLowerCase());
    if (match == null) return false;

    int hour = int.parse(match.group(1)!);
    String period = match.group(2)!;

    if (period == 'pm' && hour != 12) hour += 12;
    if (period == 'am' && hour == 12) hour = 0;

    final slotDateTime = DateTime(
      selected.year,
      selected.month,
      selected.day,
      hour,
    );

    return slotDateTime.isBefore(DateTime.now());
  }

  //Init
  @override
  void onInit() {
    super.onInit();
    argument = Get.arguments['data'];
    log("argument fetch ${argument.id}");
    selectedDate.value = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final nextSlot = timeSlots.firstWhere(
        (time) => !isPastTimeSlot(time),
        orElse: () => timeSlots.last,
      );

      selectedTimes.add(nextSlot);
      getAvailableCourtsById(argument.id!, nextSlot);
    });
  }

  /// Toggle slot selection
  void toggleTimeSlot(String time) {
    if (selectedTimes.contains(time)) {
      selectedTimes.remove(time);
    } else {
      selectedTimes.add(time);
    }
  }

  /// Fetch available courts by court ID
  Future<void> getAvailableCourtsById(
    String registerClubId, [
    String searchTime = '',
  ]) async {
    log("Fetching courts for time: $searchTime");
    isLoadingCourts.value = true;
    courtErrorMessage.value = '';
    try {
      final result = await repository.fetchAvailableCourtsById(
        id: registerClubId,
        time: searchTime,
      );
      availableCourtData.value = result;

      final courts = result.data;
      if (courts != null && courts.isNotEmpty) {
        final firstCourt = courts.first;
        final amount = firstCourt.slotTimes?.first.amount?.toString();
        selectedAmount.value = amount ?? '0';
      } else {
        selectedAmount.value = '0';
      }

      log("Available courts fetched for $searchTime");
    } catch (e) {
      courtErrorMessage.value = e.toString();
      selectedAmount.value = '0';
      log("Error: $e");
    } finally {
      isLoadingCourts.value = false;
    }
  }
}

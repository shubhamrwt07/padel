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
  RxList<String> selectedTimes = <String>[].obs;
  final selectedDate = Rxn<DateTime>();
  Courts argument=Courts();
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

  //Init
  @override
  void onInit() {
    super.onInit();
    argument=Get.arguments['data'];
    log("argument fetch${argument.id}");
    WidgetsBinding.instance.addPostFrameCallback((v){
        getAvailableCourtsById(argument.id!);
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
  Future<void> getAvailableCourtsById(String registerClubId, [String searchTime = '']) async {
    log("message details courts");
    isLoadingCourts.value = true;
    courtErrorMessage.value = '';
    try {
      final result = await repository.fetchAvailableCourtsById(id: registerClubId, time: searchTime);
      availableCourtData.value = result;
      log("message details courts 200");
    } catch (e) {
      courtErrorMessage.value = e.toString();
      debugPrint("Error fetching available courts: $e");
      log("message details courts 400");

    } finally {
      isLoadingCourts.value = false;
    }
  }

}


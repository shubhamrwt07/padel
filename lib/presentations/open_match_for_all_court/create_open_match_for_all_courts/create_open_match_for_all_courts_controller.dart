import 'package:get/get.dart';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../../../data/request_models/home_models/get_available_court.dart';
import '../../booking/open_matches/questions_bottomsheet/questions_bottomsheet_controller.dart';
import '../../booking/open_matches/questions_bottomsheet/questions_bottomsheet_screen.dart';
import '../../booking/details_page/details_page_controller.dart';

class CreateOpenMatchForAllCourtsController extends GetxController {
  ///Available Slots------------------------------------------------------------
  final selectedDuration = '90 min'.obs;
  void select(String value) {
    selectedDuration.value = value;
  }

  ///Available Clubs------------------------------------------------------------
  final expandedIndex = (-1).obs;
  void toggle(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  final selectedDate = Rxn<DateTime>();
  Rx<DateTime> focusedMonth = DateTime.now().obs;

  RxBool showUnavailableSlots = false.obs;

  // Cache base slot lists
  final Map<String, List<Slots>> _originalSlotsCache = {};

  RxList<Slots> selectedSlots = <Slots>[].obs;

  // Multi-date selections - key format: "date_courtId_slotId"
  RxMap<String, Map<String, dynamic>> multiDateSelections = <String, Map<String, dynamic>>{}.obs;

  RxInt totalAmount = 0.obs;
  Rx<GetAllActiveCourtsForSlotWiseModel?> slots = Rx<GetAllActiveCourtsForSlotWiseModel?>(null);
  RxBool isLoadingCourts = false.obs;
  @override
  void onInit() {
    super.onInit();
    selectedDate.value = DateTime.now();
    _initializeMockData();
  }

  void _initializeMockData() {
    slots.value = GetAllActiveCourtsForSlotWiseModel(
      data: [
        Data(
          sId: 'court1',
          courtName: '',
          clubName: 'Sample Club',
          slots: [
            Slots(sId: 'slot1', time: '6:00 AM', amount: 400, status: 'available'),
            Slots(sId: 'slot2', time: '7:00 AM', amount: 400, status: 'available'),
            Slots(sId: 'slot3', time: '8:00 AM', amount: 500, status: 'available'),
            Slots(sId: 'slot4', time: '9:00 AM', amount: 500, status: 'available'),
            Slots(sId: 'slot5', time: '10:00 AM', amount: 500, status: 'available'),
            Slots(sId: 'slot6', time: '11:00 AM', amount: 500, status: 'available'),
            Slots(sId: 'slot7', time: '12:00 PM', amount: 600, status: 'available'),
            Slots(sId: 'slot8', time: '1:00 PM', amount: 600, status: 'available'),
            Slots(sId: 'slot9', time: '2:00 PM', amount: 600, status: 'available'),
            Slots(sId: 'slot10', time: '3:00 PM', amount: 600, status: 'available'),
            Slots(sId: 'slot11', time: '4:00 PM', amount: 600, status: 'available'),
            Slots(sId: 'slot12', time: '5:00 PM', amount: 600, status: 'available'),
            Slots(sId: 'slot13', time: '6:00 PM', amount: 700, status: 'available'),
            Slots(sId: 'slot14', time: '7:00 PM', amount: 700, status: 'available'),
            Slots(sId: 'slot15', time: '8:00 PM', amount: 700, status: 'available'),
            Slots(sId: 'slot16', time: '9:00 PM', amount: 700, status: 'available'),
            Slots(sId: 'slot17', time: '10:00 PM', amount: 700, status: 'available'),
            Slots(sId: 'slot18', time: '11:00 PM', amount: 700, status: 'available'),
          ],
        ),
      ],
    );
    
    _originalSlotsCache.clear();
    final courts = slots.value?.data ?? [];
    for (final court in courts) {
      _originalSlotsCache[court.sId ?? ''] = List<Slots>.from(court.slots ?? []);
    }
  }

  @override
  void onClose() {
    selectedSlots.clear();
    multiDateSelections.clear();
    totalAmount.value = 0;
    super.onClose();
  }



  void onNext() {
    log("Slots -> $selectedSlots");

    if (multiDateSelections.isEmpty) {
      Get.snackbar(
        "No Selection",
        "Please select at least one slot to continue.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Collect all unique court IDs and names from selections
    Map<String, String> courtsMap = {}; // courtId -> courtName
    multiDateSelections.forEach((key, selection) {
      final courtId = selection['courtId'] as String?;
      final courtName = selection['courtName'] as String?;
      if (courtId != null && courtId.isNotEmpty) {
        courtsMap[courtId] = courtName ?? '';
      }
    });

    List<String> courtIds = courtsMap.keys.toList();
    List<String> courtNames = courtsMap.values.toList();

    // For backward compatibility, use the first court as primary
    String primaryCourtId = courtIds.first;
    String primaryCourtName = courtNames.first;

    // Clear existing controller and create fresh one
    if (Get.isRegistered<DetailsController>()) {
      Get.delete<DetailsController>();
    }
    final detailsController = Get.put(DetailsController());
    
    // Set flag to prevent profile initialization
    detailsController.isFromOpenMatch = true;

    // Set match data
    detailsController.localMatchData.update("clubName", (value) => slots.value!.data![0].clubName ?? "");
    detailsController.localMatchData.update("address", (value) => slots.value!.data![0].registerClubId?.address ?? "");
    detailsController.localMatchData.update("clubId", (v) => "1234456788990");
    detailsController.localMatchData["ownerId"] = slots.value!.data![0].registerClubId?.ownerId?.sId ?? "";
    detailsController.localMatchData.update("matchDate", (v) => selectedDate.value ?? "");
    detailsController.localMatchData.update("clubImage", (v)=> slots.value!.data![0].registerClubId?.courtImage ??[]);
    detailsController.localMatchData.update("matchTime", (v) => selectedSlots.map((s) => s.time).toList());
    detailsController.localMatchData.update("price", (v) => totalAmount.toString());
    detailsController.localMatchData.update("courtType", (v) => "Outdoor"); // Default court type
    detailsController.localMatchData.update("slot", (v) => selectedSlots);
    
    // Use direct assignment for new keys
    detailsController.localMatchData["courtId"] = primaryCourtId;
    detailsController.localMatchData["courtName"] = primaryCourtName;
    detailsController.localMatchData["courtIds"] = courtIds;
    detailsController.localMatchData["courtNames"] = courtNames;
    detailsController.localMatchData["courtsDetails"] = courtsMap;

    log("Selected Courts: ${courtIds.length}");
    log("Court IDs: $courtIds");
    log("Court Names: $courtNames");

    // Show QuestionsBottomsheetScreen as bottom sheet with match data
    Get.put(QuestionsBottomsheetController(), tag: 'questions');
    Get.find<QuestionsBottomsheetController>(tag: 'questions').localMatchData = detailsController.localMatchData;
    
    Get.bottomSheet(
      QuestionsBottomsheetScreen(),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
    );
  }

  void refreshSlots({bool showUnavailable = false}) {
    isLoadingCourts.value = true;
    
    Future.delayed(Duration(milliseconds: 500), () {
      final courts = slots.value?.data ?? [];
      for (var court in courts) {
        final base = _originalSlotsCache[court.sId ?? ''] ?? [];
        if (showUnavailable) {
          court.slots = base.where((s) => _isUnavailableSlot(s)).toList();
        } else {
          court.slots = base.where((s) => _isAvailableSlot(s)).toList();
        }
      }
      
      slots.refresh();
      isLoadingCourts.value = false;
    });
  }
  void toggleCourtRowSlotSelection(Slots slot, {String? courtId, String? courtName}) {
    final slotId = slot.sId ?? '';
    final resolvedCourtId = courtId ?? '';
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

    final multiDateKey = '${dateString}_${resolvedCourtId}_$slotId';

    if (multiDateSelections.containsKey(multiDateKey)) {
      multiDateSelections.remove(multiDateKey);
      selectedSlots.removeWhere((s) => s.sId == slotId);
    } else {
      if (multiDateSelections.length >= 3) {
        Get.snackbar(
          "Limit Reached",
          "You can only select up to 3 slots",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      multiDateSelections[multiDateKey] = {
        'slot': slot,
        'courtId': resolvedCourtId,
        'courtName': courtName ?? '',
        'date': dateString,
        'dateTime': currentDate,
      };

      if (!selectedSlots.any((s) => s.sId == slotId)) {
        selectedSlots.add(slot);
      }
    }

    _recalculateTotalAmount();
  }
  void toggleSlotSelection(Slots slot, {String? courtId, String? courtName}) {
    if(Get.isSnackbarOpen) return;
    
    final slotId = slot.sId ?? '';
    final resolvedCourtId = courtId ?? '';
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

    final multiDateKey = '${dateString}_${resolvedCourtId}_$slotId';

    if (multiDateSelections.containsKey(multiDateKey)) {
      multiDateSelections.remove(multiDateKey);
      selectedSlots.removeWhere((s) => s.sId == slotId);
    } else {
      if (multiDateSelections.length >= 3) {
        Get.snackbar(
          "Limit Reached",
          "You can only select up to 3 slots",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final isAllowed = _isConsecutiveSelectionAllowed(
        resolvedCourtId,
        slotId,
        dateString,
      );
      if (!isAllowed) {
        Get.snackbar(
          "Non-consecutive Selection",
          "Please Select Consecutive Slots",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      multiDateSelections[multiDateKey] = {
        'slot': slot,
        'courtId': resolvedCourtId,
        'courtName': courtName ?? '',
        'date': dateString,
        'dateTime': currentDate,
      };

      if (!selectedSlots.any((s) => s.sId == slotId)) {
        selectedSlots.add(slot);
      }
    }

    _recalculateTotalAmount();
    log("Selected ${multiDateSelections.length} slots for date: $dateString, Total: ₹${totalAmount.value}");
  }
  bool _isConsecutiveSelectionAllowed(String courtId, String slotId, String dateString) {
    final List<Map<String, dynamic>> existingSelections = [];
    multiDateSelections.forEach((key, selection) {
      if (selection['date'] == dateString) {
        existingSelections.add(selection);
      }
    });

    if (existingSelections.isEmpty) return true;

    final candidateSlot = _getSlotById(courtId, slotId);
    if (candidateSlot == null) return false;

    final List<String> allTimes = [];
    for (final selection in existingSelections) {
      final slot = selection['slot'] as Slots;
      if (slot.time != null) allTimes.add(slot.time!);
    }
    if (candidateSlot.time != null) allTimes.add(candidateSlot.time!);

    final List<int> timeMinutes = [];
    for (final timeStr in allTimes) {
      final minutes = _convertTimeToMinutes(timeStr);
      if (minutes != null) timeMinutes.add(minutes);
    }

    if (timeMinutes.length != allTimes.length) return false;

    timeMinutes.sort();

    for (int i = 1; i < timeMinutes.length; i++) {
      if (timeMinutes[i] - timeMinutes[i - 1] != 60) {
        return false;
      }
    }

    return true;
  }

  Slots? _getSlotById(String courtId, String slotId) {
    final courts = slots.value?.data ?? [];
    for (final court in courts) {
      if (court.sId == courtId) {
        final courtSlots = _originalSlotsCache[courtId] ?? court.slots ?? [];
        for (final slot in courtSlots) {
          if (slot.sId == slotId) return slot;
        }
      }
    }
    return null;
  }

  int? _convertTimeToMinutes(String timeStr) {
    try {
      final cleanTime = timeStr.trim().toLowerCase();

      DateTime? parsed;
      for (final pattern in const ['h:mm a', 'h a', 'HH:mm', 'H:mm']) {
        try {
          parsed = DateFormat(pattern).parseStrict(cleanTime);
          break;
        } catch (_) {}
      }

      if (parsed != null) {
        return parsed.hour * 60 + parsed.minute;
      }

      final parts = cleanTime.split(' ');
      String timePart = parts[0];
      String? meridiem = parts.length > 1 ? parts[1] : null;

      final timePieces = timePart.split(':');
      int hour = int.tryParse(timePieces[0]) ?? 0;
      int minute = timePieces.length > 1 ? int.tryParse(timePieces[1]) ?? 0 : 0;

      if (meridiem == 'pm' && hour != 12) hour += 12;
      if (meridiem == 'am' && hour == 12) hour = 0;

      return hour * 60 + minute;
    } catch (_) {
      return null;
    }
  }
  void _recalculateTotalAmount() {
    int total = 0;
    multiDateSelections.forEach((key, selection) {
      final slot = selection['slot'] as Slots;
      total += slot.amount ?? 0;
    });
    totalAmount.value = total;
  }

  bool isPastAndUnavailable(Slots slot) {
    // Treat booked or explicitly unavailable statuses as unavailable
    final status = _normalizeStatus(slot.status);
    if (status == 'booked') return true;
    if (status.isNotEmpty && status != 'available') return true;

    // If time is missing or malformed, don't mark as past (avoid crashes)
    final rawTime = slot.time;
    if (rawTime == null || rawTime.trim().isEmpty) {
      return false;
    }

    final now = DateTime.now();
    final selected = selectedDate.value ?? now;

    try {
      final timeString = rawTime.toLowerCase().trim();

      // Try common formats first
      DateTime? parsed;
      for (final pattern in const ['h:mm a', 'h a', 'HH:mm', 'H:mm', 'HH']) {
        try {
          parsed = DateFormat(pattern).parseStrict(timeString);
          break;
        } catch (_) {}
      }

      int hour;
      int minute;
      if (parsed != null) {
        hour = parsed.hour;
        minute = parsed.minute;
      } else {
        // Fallback manual parse: supports "10", "10:30", with optional am/pm
        String t = timeString;
        String meridiem = '';
        final parts = t.split(' ');
        if (parts.length == 2) {
          t = parts[0];
          meridiem = parts[1];
        }
        final timePieces = t.split(':');
        hour = int.tryParse(timePieces[0]) ?? 0;
        minute = timePieces.length > 1 ? int.tryParse(timePieces[1]) ?? 0 : 0;
        if (meridiem == 'pm' && hour != 12) hour += 12;
        if (meridiem == 'am' && hour == 12) hour = 0;
      }

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
        return true;
      }
    } catch (_) {

      // On any parsing error, consider it not past to be safe

      return false;
    }
    return false;
  }

  bool _isUnavailableSlot(Slots slot) {
    final availability = _normalizeStatus(slot.availabilityStatus);
    final isBlocked = availability == "maintenance" ||
        availability == "weather conditions" ||
        availability == "staff unavailability";
    final isBooked = (_normalizeStatus(slot.status) == 'booked');
    final isPast = isPastAndUnavailable(slot);
    return isPast || isBlocked || isBooked;
  }

  bool _isAvailableSlot(Slots slot) {
    final status = _normalizeStatus(slot.status);
    return !_isUnavailableSlot(slot) && (status == 'available' || status.isEmpty);
  }

  String _normalizeStatus(String? value) {
    return (value ?? '').trim().toLowerCase();
  }

  bool isSlotSelected(Slots slot, String courtId) {
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
    final multiDateKey = '${dateString}_${courtId}_${slot.sId}';

    return multiDateSelections.containsKey(multiDateKey);
  }

  bool isSlotDisabled(Slots slot, String courtId) {
    if (isSlotSelected(slot, courtId)) return false;
    return multiDateSelections.length >= 3;
  }

  int getTotalSelectionsCount() {
    return multiDateSelections.length;
  }

  Map<String, List<Map<String, dynamic>>> getSelectionsByDate() {
    final Map<String, List<Map<String, dynamic>>> result = {};
    multiDateSelections.forEach((key, selection) {
      final dateString = selection['date'] as String;
      if (!result.containsKey(dateString)) {
        result[dateString] = [];
      }
      result[dateString]!.add(selection);
    });
    return result;
  }

  void clearAllSelections() {
    multiDateSelections.clear();
    selectedSlots.clear();
    totalAmount.value = 0;
  }

  List<Slots> getThreeConsecutiveSlots(Slots selectedSlot) {
    final courts = slots.value?.data ?? [];
    if (courts.isEmpty) return [];
    
    final court = courts.first;
    final allSlots = _originalSlotsCache[court.sId ?? ''] ?? court.slots ?? [];
    
    int selectedIndex = -1;
    for (int i = 0; i < allSlots.length; i++) {
      if (allSlots[i].sId == selectedSlot.sId) {
        selectedIndex = i;
        break;
      }
    }
    
    if (selectedIndex == -1) return [];
    
    List<Slots> result = [];
    
    if (selectedIndex > 0) {
      result.add(allSlots[selectedIndex - 1]);
    }
    
    result.add(allSlots[selectedIndex]);
    
    if (selectedIndex < allSlots.length - 1) {
      result.add(allSlots[selectedIndex + 1]);
    }
    
    while (result.length < 3) {
      if (result.length < 3 && selectedIndex > result.length - 1) {
        result.insert(0, allSlots[selectedIndex - result.length]);
      } else if (result.length < 3 && selectedIndex + result.length < allSlots.length) {
        result.add(allSlots[selectedIndex + result.length - 1]);
      } else {
        break;
      }
    }
    
    return result.take(3).toList();
  }

  bool isTimeSlotSelectedInOtherCourts(String? slotTime, String currentCourtId) {
    if (slotTime == null || slotTime.isEmpty) return false;
    
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
    
    for (final entry in multiDateSelections.entries) {
      final selection = entry.value;
      final existingDate = selection['date'] as String;
      final existingCourtId = selection['courtId'] as String;
      final existingSlot = selection['slot'] as Slots;
      
      if (existingDate == dateString &&
          existingCourtId != currentCourtId &&
          existingSlot.time == slotTime) {
        return true;
      }
    }
    return false;
  }
}
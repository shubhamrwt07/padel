// import 'package:get/get.dart';
// import 'dart:developer';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:padel_mobile/data/response_models/get_all_slot_prices_of_court_model.dart';
// import 'package:padel_mobile/data/response_models/get_courts_by_duration_model.dart';
// import 'package:padel_mobile/handler/logger.dart';
// import 'package:padel_mobile/presentations/booking/open_matches/questions_bottomsheet/questions_bottomsheet_controller.dart';
// import 'package:padel_mobile/presentations/booking/open_matches/questions_bottomsheet/questions_bottomsheet_screen.dart';
// import 'package:padel_mobile/repositories/home_repository/home_repository.dart';
// import '../../../../data/request_models/home_models/get_available_court.dart';
// import '../../booking/details_page/details_page_controller.dart';
//
// class CreateOpenMatchForAllCourtsController extends GetxController {
//   final HomeRepository _homeRepository = HomeRepository();
//   final HomeRepository repository = HomeRepository();
//
//   // Open match specific limits
//   static const int maxSlots = 3;
//   static const int maxDays = 1;
//
//   ///Available Slots------------------------------------------------------------
//   final selectedDuration = '60 min'.obs;
//   void select(String value) {
//     selectedDuration.value = value;
//     clearAllSelections(); // Clear all selections when duration changes
//     selectedTimeSlot.value = ''; // Clear selected time slot
//     // Don't fetch courts when duration changes - only when slot is selected
//   }
//
//   ///Available Clubs------------------------------------------------------------
//   final expandedIndex = (-1).obs;
//   void toggle(int index) {
//     expandedIndex.value = expandedIndex.value == index ? -1 : index;
//   }
//
//   ///Available Slots Collapse/Expand------------------------------------------------------------
//   RxBool isSlotsCollapsed = false.obs;
//   RxnString selectedSearchSlotId = RxnString();
//
//   void toggleSlotsCollapse() {
//     isSlotsCollapsed.value = !isSlotsCollapsed.value;
//   }
//
//   final selectedDate = Rxn<DateTime>();
//   Rx<DateTime> focusedMonth = DateTime.now().obs;
//
//   RxBool showUnavailableSlots = false.obs;
//
//   // Cache base slot lists
//   final Map<String, List<Slots>> _originalSlotsCache = {};
//
//   RxList<Slots> selectedSlots = <Slots>[].obs;
//
//   // Multi-date selections - key format: "date_courtId_slotId"
//   RxMap<String, Map<String, dynamic>> multiDateSelections = <String, Map<String, dynamic>>{}.obs;
//
//   // Real court selections from availableCourts (for payment panel)
//   RxMap<String, Map<String, dynamic>> realCourtSelections = <String, Map<String, dynamic>>{}.obs;
//
//   RxInt totalAmount = 0.obs;
//   Rx<GetAllActiveCourtsForSlotWiseModel?> slots = Rx<GetAllActiveCourtsForSlotWiseModel?>(null);
//   RxBool isLoadingCourts = false.obs;
//
//   // Courts by duration data
//   Rx<GetCourtsByDurationModel?> courtsByDuration = Rx<GetCourtsByDurationModel?>(null);
//   RxBool isLoadingCourtsByDuration = false.obs;
//   RxString selectedTimeSlot = ''.obs;
//
//   // Variables to store fetched slot prices
//   var allSlotPricesResponse = Rxn<GetAllSlotPricesOfCourtModel>();
//   var isSlotPricesLoading = false.obs;
//   final Map<String, Map<String, int>> slotPricesData = {}; // day -> {duration -> price}
//   final Map<String, Map<String, int>> originalSlotPricesData = {}; // Track original prices
//
//   @override
//   void onInit() {
//     super.onInit();
//     selectedDate.value = DateTime.now();
//     _initializeMockData();
//   }
//
//   void _initializeMockData() {
//     slots.value = GetAllActiveCourtsForSlotWiseModel(
//       data: [
//         Data(
//           sId: 'court1',
//           courtName: '',
//           clubName: 'Sample Club',
//           slots: [
//             Slots(sId: 'slot1', time: '6:00 AM', amount: 400, status: 'available'),
//             Slots(sId: 'slot2', time: '7:00 AM', amount: 400, status: 'available'),
//             Slots(sId: 'slot3', time: '8:00 AM', amount: 500, status: 'available'),
//             Slots(sId: 'slot4', time: '9:00 AM', amount: 500, status: 'available'),
//             Slots(sId: 'slot5', time: '10:00 AM', amount: 500, status: 'available'),
//             Slots(sId: 'slot6', time: '11:00 AM', amount: 500, status: 'available'),
//             Slots(sId: 'slot7', time: '12:00 PM', amount: 600, status: 'available'),
//             Slots(sId: 'slot8', time: '1:00 PM', amount: 600, status: 'available'),
//             Slots(sId: 'slot9', time: '2:00 PM', amount: 600, status: 'available'),
//             Slots(sId: 'slot10', time: '3:00 PM', amount: 600, status: 'available'),
//             Slots(sId: 'slot11', time: '4:00 PM', amount: 600, status: 'available'),
//             Slots(sId: 'slot12', time: '5:00 PM', amount: 600, status: 'available'),
//             Slots(sId: 'slot13', time: '6:00 PM', amount: 700, status: 'available'),
//             Slots(sId: 'slot14', time: '7:00 PM', amount: 700, status: 'available'),
//             Slots(sId: 'slot15', time: '8:00 PM', amount: 700, status: 'available'),
//             Slots(sId: 'slot16', time: '9:00 PM', amount: 700, status: 'available'),
//             Slots(sId: 'slot17', time: '10:00 PM', amount: 700, status: 'available'),
//             Slots(sId: 'slot18', time: '11:00 PM', amount: 700, status: 'available'),
//           ],
//         ),
//       ],
//     );
//
//     _originalSlotsCache.clear();
//     final courts = slots.value?.data ?? [];
//     for (final court in courts) {
//       _originalSlotsCache[court.sId ?? ''] = List<Slots>.from(court.slots ?? []);
//     }
//   }
//
//   @override
//   void onClose() {
//     selectedSlots.clear();
//     multiDateSelections.clear();
//     realCourtSelections.clear();
//     totalAmount.value = 0;
//     super.onClose();
//   }
//
//   void onNext() {
//     log("Slots -> $selectedSlots");
//
//     if (realCourtSelections.isEmpty) {
//       Get.snackbar(
//         "No Selection",
//         "Please select at least one slot to continue.",
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     // Get selected court info from realCourtSelections
//     String selectedCourtId = '';
//     String selectedCourtName = '';
//     String selectedClubId = '';
//
//     if (realCourtSelections.isNotEmpty) {
//       final firstSelection = realCourtSelections.values.first;
//       selectedCourtId = firstSelection['courtId'] ?? '';
//       selectedCourtName = firstSelection['courtName'] ?? '';
//       // Get club info from courtsByDuration if available
//       if (courtsByDuration.value?.data != null) {
//         for (var courtData in courtsByDuration.value!.data!) {
//           if (courtData.id == selectedCourtId) {
//             selectedClubId = courtData.registerClub?.id ?? '';
//             selectedCourtName = courtData.courtName ?? selectedCourtName;
//             break;
//           }
//         }
//       }
//     }
//
//     // Use only slots from realCourtSelections (availableCourts)
//     final selectedSlotsFromCourts = <Slots>[];
//     String matchTimeFromCourts = '';
//     realCourtSelections.forEach((key, value) {
//       final slot = value['slot'] as Slots;
//       selectedSlotsFromCourts.add(slot);
//       if (matchTimeFromCourts.isEmpty && slot.time != null) {
//         matchTimeFromCourts = slot.time!;
//       }
//     });
//
//     // Get business hours from courtsByDuration API response
//     List<dynamic> businessHours = [];
//     print("Debug - Extracting businessHours from API response");
//     if (courtsByDuration.value?.data != null) {
//       for (var courtData in courtsByDuration.value!.data!) {
//         if (courtData.id == selectedCourtId && courtData.registerClub?.businessHours != null) {
//           for (var bh in courtData.registerClub!.businessHours!) {
//             final bhJson = {
//               'day': bh.day,
//               'time': bh.time,
//               '_id': bh.id,
//             };
//             // Add businessHours from API (avoid duplicates)
//             bool exists = businessHours.any((existing) =>
//               existing['day'] == bhJson['day'] && existing['time'] == bhJson['time']);
//             if (!exists) {
//               businessHours.add(bhJson);
//             }
//           }
//         }
//       }
//     }
//     print("Debug - Extracted businessHours from API: $businessHours");
//
//     final matchData = {
//       "slot": selectedSlotsFromCourts,
//       "matchDate": selectedDate.value,
//       "courtName": selectedCourtName,
//       "clubId": selectedClubId,
//       "courtId": selectedCourtId,
//       "matchTime": matchTimeFromCourts,
//       "businessHours": businessHours.isNotEmpty ? businessHours : null, // Only include if not empty
//       "selectedDuration": selectedDuration.value, // Pass selected duration
//     };
//
//     // Debug: Print what we're sending
//     print("Debug - Final matchData businessHours: ${matchData['businessHours']}");
//     print("Debug - Sending ${selectedSlotsFromCourts.length} slots from available courts to bottomsheet");
//     for (var slot in selectedSlotsFromCourts) {
//       print("Sending slot: ${slot.sId} - ${slot.time} - ${slot.amount}");
//     }
//
//     // Show QuestionsBottomsheetScreen as bottom sheet with match data
//     final controller = Get.put(QuestionsBottomsheetController(), tag: 'questions');
//     controller.localMatchData = matchData;
//
//     Get.bottomSheet(
//       QuestionsBottomsheetScreen(),
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       isScrollControlled: true,
//     );
//   }
//
//   void refreshSlots({bool showUnavailable = false}) {
//     isLoadingCourts.value = true;
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       final courts = slots.value?.data ?? [];
//       for (var court in courts) {
//         final base = _originalSlotsCache[court.sId ?? ''] ?? [];
//         if (showUnavailable) {
//           court.slots = base.where((s) => _isUnavailableSlot(s)).toList();
//         } else {
//           court.slots = base.where((s) => _isAvailableSlot(s)).toList();
//         }
//       }
//
//       slots.refresh();
//       isLoadingCourts.value = false;
//     });
//   }
//
//   void toggleCourtRowSlotSelection(Slots slot, {String? courtId, String? courtName, bool? isLeftHalf}) {
//     final slotId = slot.sId ?? '';
//     final resolvedCourtId = courtId ?? '';
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//     final selectedDuration = this.selectedDuration.value;
//
//     if (selectedDuration == '30 min' && isLeftHalf != null) {
//       // Handle 30-minute half-slot selection for court rows
//       final halfKey = '${dateString}_${resolvedCourtId}_${slotId}_${isLeftHalf ? 'left' : 'right'}';
//       final otherHalfKey = '${dateString}_${resolvedCourtId}_${slotId}_${isLeftHalf ? 'right' : 'left'}';
//
//       if (realCourtSelections.containsKey(halfKey)) {
//         // If clicking the same half, deselect it
//         realCourtSelections.remove(halfKey);
//         selectedSlots.removeWhere((s) => s.sId == slotId);
//       } else {
//         // Check 3-slot limit before adding
//         if (realCourtSelections.length >= 3) {
//           Get.snackbar(
//             "Limit Reached",
//             "You can only select up to 3 slots",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//           return;
//         }
//
//         // Check if same time slot is already selected in other courts
//         if (_isTimeSlotSelectedInOtherCourtsForRealCourt(slot.time, resolvedCourtId)) {
//           Get.snackbar(
//             "Time Conflict",
//             "This time slot is already selected in another court",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//           return;
//         }
//
//         // Check consecutive selection for new selections
//         if (!_isConsecutiveSelectionAllowedForCourts(resolvedCourtId, slotId, dateString)) {
//           Get.snackbar(
//             "Non-consecutive Selection",
//             "Please select consecutive slots only",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//           return;
//         }
//
//         // Always remove other half when selecting a new half
//         realCourtSelections.remove(otherHalfKey);
//
//         // Add the selected half
//         realCourtSelections[halfKey] = {
//           'slot': slot,
//           'courtId': resolvedCourtId,
//           'courtName': courtName ?? '',
//           'date': dateString,
//           'dateTime': currentDate,
//           'isLeftHalf': isLeftHalf,
//           'amount': slot.amount ?? 0, // Full price for 30min
//         };
//
//         if (!selectedSlots.any((s) => s.sId == slotId)) {
//           selectedSlots.add(slot);
//         }
//       }
//     } else if (selectedDuration == '90 min') {
//       // Handle 90-minute selection (1.5 slots) - create entries for both slots
//       final realCourtKey = '${dateString}_${resolvedCourtId}_$slotId';
//
//       if (realCourtSelections.containsKey(realCourtKey)) {
//         // Remove both the main slot and the half slot
//         realCourtSelections.remove(realCourtKey);
//         final halfSlotKey = '${realCourtKey}_half';
//         realCourtSelections.remove(halfSlotKey);
//         selectedSlots.removeWhere((s) => s.sId == slotId);
//       } else {
//         // Check 3-slot limit before adding
//         if (realCourtSelections.length >= 2) { // 90min takes 2 entries
//           Get.snackbar(
//             "Limit Reached",
//             "You can only select up to 3 slots",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//           return;
//         }
//
//         // Check if same time slot is already selected in other courts
//         if (_isTimeSlotSelectedInOtherCourtsForRealCourt(slot.time, resolvedCourtId)) {
//           Get.snackbar(
//             "Time Conflict",
//             "This time slot is already selected in another court",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//           return;
//         }
//
//         // Check consecutive selection for new selections
//         if (!_isConsecutiveSelectionAllowedForCourts(resolvedCourtId, slotId, dateString)) {
//           Get.snackbar(
//             "Non-consecutive Selection",
//             "Please select consecutive slots only",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//           return;
//         }
//
//         // Get proper 90min pricing breakdown
//         final currentDate = selectedDate.value ?? DateTime.now();
//         final dayName = getWeekday(currentDate.weekday);
//         final price60 = findPriceForSlot(slot.time ?? '', dayName, 60) ?? (slot.amount ?? 0);
//         final price30 = findPriceForSlot(slot.time ?? '', dayName, 30) ?? ((slot.amount ?? 0) ~/ 2);
//
//         // Create entry for the full slot (60 minutes)
//         realCourtSelections[realCourtKey] = {
//           'slot': slot,
//           'courtId': resolvedCourtId,
//           'courtName': courtName ?? '',
//           'date': dateString,
//           'dateTime': currentDate,
//           'amount': price60,
//           'duration': '60 min',
//           'slotType': 'full',
//         };
//
//         // Create entry for the half slot (30 minutes) - next hour
//         final nextHourTime = _getNextHourTime(slot.time ?? '');
//         final halfSlotKey = '${realCourtKey}_half';
//         realCourtSelections[halfSlotKey] = {
//           'slot': Slots(sId: '${slot.sId}_half', time: nextHourTime, amount: price30),
//           'courtId': resolvedCourtId,
//           'courtName': courtName ?? '',
//           'date': dateString,
//           'dateTime': currentDate,
//           'amount': price30,
//           'duration': '30 min',
//           'slotType': 'half',
//         };
//
//         if (!selectedSlots.any((s) => s.sId == slotId)) {
//           selectedSlots.add(slot);
//         }
//       }
//     } else if (selectedDuration == '120 min') {
//       // Handle 120-minute selection (2 full slots) for court rows
//       final realCourtKey = '${dateString}_${resolvedCourtId}_$slotId';
//
//       if (realCourtSelections.containsKey(realCourtKey)) {
//         // Remove both slots for 120min
//         realCourtSelections.remove(realCourtKey);
//         final secondSlotKey = '${realCourtKey}_second';
//         realCourtSelections.remove(secondSlotKey);
//         selectedSlots.removeWhere((s) => s.sId == slotId);
//       } else {
//         // Check 3-slot limit before adding
//         if (realCourtSelections.length >= 2) { // 120min takes 2 entries
//           Get.snackbar(
//             "Limit Reached",
//             "You can only select up to 3 slots",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//           return;
//         }
//
//         // Check if same time slot is already selected in other courts
//         if (_isTimeSlotSelectedInOtherCourtsForRealCourt(slot.time, resolvedCourtId)) {
//           Get.snackbar(
//             "Time Conflict",
//             "This time slot is already selected in another court",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//           return;
//         }
//
//         // Check consecutive selection for new selections
//         if (!_isConsecutiveSelectionAllowedForCourts(resolvedCourtId, slotId, dateString)) {
//           Get.snackbar(
//             "Non-consecutive Selection",
//             "Please select consecutive slots only",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//           return;
//         }
//
//         // Add both slots for 120min - need to find next slot
//         final currentDate = selectedDate.value ?? DateTime.now();
//         final dayName = getWeekday(currentDate.weekday);
//         final price60 = findPriceForSlot(slot.time ?? '', dayName, 60) ?? (slot.amount ?? 0);
//
//         // Create entry for the first slot (60 minutes)
//         realCourtSelections[realCourtKey] = {
//           'slot': slot,
//           'courtId': resolvedCourtId,
//           'courtName': courtName ?? '',
//           'date': dateString,
//           'dateTime': currentDate,
//           'amount': price60,
//           'duration': '60 min',
//           'slotType': 'first',
//         };
//
//         // Create entry for the second slot (60 minutes) - next hour
//         final nextHourTime = _getNextHourTime(slot.time ?? '');
//         final secondSlotKey = '${realCourtKey}_second';
//         realCourtSelections[secondSlotKey] = {
//           'slot': Slots(sId: '${slot.sId}_second', time: nextHourTime, amount: price60),
//           'courtId': resolvedCourtId,
//           'courtName': courtName ?? '',
//           'date': dateString,
//           'dateTime': currentDate,
//           'amount': price60,
//           'duration': '60 min',
//           'slotType': 'second',
//         };
//
//         if (!selectedSlots.any((s) => s.sId == slotId)) {
//           selectedSlots.add(slot);
//         }
//       }
//     } else {
//       // Handle full slot selection for 60-minute duration
//       final realCourtKey = '${dateString}_${resolvedCourtId}_$slotId';
//
//       if (realCourtSelections.containsKey(realCourtKey)) {
//         realCourtSelections.remove(realCourtKey);
//         selectedSlots.removeWhere((s) => s.sId == slotId);
//       } else {
//         // Check 3-slot limit before adding
//         if (realCourtSelections.length >= 3) {
//           Get.snackbar(
//             "Limit Reached",
//             "You can only select up to 3 slots",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//           return;
//         }
//
//         // Check if same time slot is already selected in other courts
//         if (_isTimeSlotSelectedInOtherCourtsForRealCourt(slot.time, resolvedCourtId)) {
//           Get.snackbar(
//             "Time Conflict",
//             "This time slot is already selected in another court",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//           return;
//         }
//
//         // Check consecutive selection for new selections
//         if (!_isConsecutiveSelectionAllowedForCourts(resolvedCourtId, slotId, dateString)) {
//           Get.snackbar(
//             "Non-consecutive Selection",
//             "Please select consecutive slots only",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//           return;
//         }
//
//         realCourtSelections[realCourtKey] = {
//           'slot': slot,
//           'courtId': resolvedCourtId,
//           'courtName': courtName ?? '',
//           'date': dateString,
//           'dateTime': currentDate,
//         };
//
//         if (!selectedSlots.any((s) => s.sId == slotId)) {
//           selectedSlots.add(slot);
//         }
//       }
//     }
//
//     recalculateRealCourtTotalAmount();
//   }
//
//   void toggleSlotSelection(Slots slot, {String? courtId, String? courtName, bool? isLeftHalf}) {
//     final slotId = slot.sId ?? '';
//     final resolvedCourtId = courtId ?? '';
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//     final selectedDuration = this.selectedDuration.value;
//
//     bool isDeselecting = false;
//
//     if (selectedDuration == '30 min' && isLeftHalf != null) {
//       // Handle 30-minute half-slot selection
//       final halfKey = '${dateString}_${resolvedCourtId}_${slotId}_${isLeftHalf ? 'left' : 'right'}';
//       final otherHalfKey = '${dateString}_${resolvedCourtId}_${slotId}_${isLeftHalf ? 'right' : 'left'}';
//
//       if (multiDateSelections.containsKey(halfKey)) {
//         multiDateSelections.remove(halfKey);
//         selectedSlots.removeWhere((s) => s.sId == slotId);
//         isDeselecting = true;
//       } else {
//         // Check limit before adding
//         if (multiDateSelections.length >= maxSlots) {
//           Get.snackbar(
//             "Limit Reached",
//             "You can only select up to $maxSlots slots",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//           return;
//         }
//
//         // Always remove other half when selecting a new half
//         multiDateSelections.remove(otherHalfKey);
//
//         multiDateSelections[halfKey] = {
//           'slot': slot,
//           'courtId': resolvedCourtId,
//           'courtName': courtName ?? '',
//           'date': dateString,
//           'dateTime': currentDate,
//           'isLeftHalf': isLeftHalf,
//           'amount': slot.amount ?? 0, // Full price for 30min
//         };
//
//         if (!selectedSlots.any((s) => s.sId == slotId)) {
//           selectedSlots.add(slot);
//         }
//       }
//     } else {
//       // Handle full slot selection for 60, 90, 120 minutes
//       final multiDateKey = '${dateString}_${resolvedCourtId}_$slotId';
//       final slotsNeeded = selectedDuration == '60 min' ? 1 : selectedDuration == '90 min' ? 2 : 2; // 120min also needs 2 slots
//
//       // Check if this is a second slot in 90min mode being clicked
//       bool isSecondSlotIn90Min = false;
//       if (selectedDuration == '90 min') {
//         final courtData = slots.value?.data?.first;
//         if (courtData?.slots != null) {
//           final allSlots = courtData!.slots!;
//           final currentSlotIndex = allSlots.indexWhere((s) => s.sId == slotId);
//           if (currentSlotIndex > 0) {
//             final previousSlot = allSlots[currentSlotIndex - 1];
//             final previousSlotKey = '${dateString}_${resolvedCourtId}_${previousSlot.sId}';
//             isSecondSlotIn90Min = multiDateSelections.containsKey(previousSlotKey);
//           }
//         }
//       }
//
//       if (multiDateSelections.containsKey(multiDateKey)) {
//         // Remove selection and consecutive slots
//         _removeConsecutiveSlots(resolvedCourtId, slotId, dateString, slotsNeeded);
//         isDeselecting = true;
//       } else if (isSecondSlotIn90Min) {
//         // Special case: clicking second slot in 90min - select next 1.5 slots from this position
//         _addConsecutiveSlots(resolvedCourtId, slotId, dateString, 2, courtName, is90MinFromSecond: true);
//       } else {
//         // Check consecutive selection requirement for open matches
//         if (!_isConsecutiveSelectionAllowed(resolvedCourtId, slotId, dateString)) {
//           Get.snackbar(
//             "Non-consecutive Selection",
//             "Please select consecutive slots only",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//           return;
//         }
//
//         // Add selection and consecutive slots
//         _addConsecutiveSlots(resolvedCourtId, slotId, dateString, slotsNeeded, courtName);
//       }
//     }
//
//     // Handle collapse/expand based on selection/deselection
//     if (isDeselecting) {
//       // Expand slots view when deselecting
//       selectedSearchSlotId.value = null;
//       isSlotsCollapsed.value = false;
//     } else {
//       // Collapse slots view when selecting
//       selectedSearchSlotId.value = slotId;
//       isSlotsCollapsed.value = true;
//     }
//
//     _recalculateTotalAmount();
//
//     // Only call API after successful selection/deselection
//     if (!isDeselecting) {
//       selectedTimeSlot.value = slot.time ?? '';
//       fetchCourtsIfReady();
//     }
//   }
//
//   void _addConsecutiveSlots(String courtId, String startSlotId, String dateString, int slotsNeeded, String? courtName, {bool is90MinFromSecond = false}) {
//     final courtData = slots.value?.data?.first;
//     if (courtData?.slots == null) return;
//
//     final allSlots = courtData!.slots!;
//     final startIndex = allSlots.indexWhere((s) => s.sId == startSlotId);
//     if (startIndex == -1 || startIndex + slotsNeeded > allSlots.length) return;
//
//     // Check 3-slot limit before adding
//     if (multiDateSelections.length + slotsNeeded > maxSlots) {
//       Get.snackbar(
//         "Limit Reached",
//         "You can only select up to $maxSlots slots",
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     // Check if all required slots are available
//     for (int i = 0; i < slotsNeeded; i++) {
//       final slot = allSlots[startIndex + i];
//       if (isPastAndUnavailable(slot) || slot.status?.toLowerCase() == 'booked') {
//         Get.snackbar(
//           "Slot Unavailable",
//           "Cannot select consecutive slots - some are unavailable.",
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.TOP,
//         );
//         return;
//       }
//     }
//
//     // For 90min, add the first slot with its individual price and create a second entry for the half slot
//     if (selectedDuration.value == '90 min' && !is90MinFromSecond) {
//       final slot = allSlots[startIndex];
//       final nextSlot = allSlots[startIndex + 1];
//
//       // Add first slot (60 minutes) with its individual price
//       final key = '${dateString}_${courtId}_${slot.sId}';
//       multiDateSelections[key] = {
//         'slot': slot,
//         'courtId': courtId,
//         'courtName': courtName ?? '',
//         'date': dateString,
//         'dateTime': selectedDate.value ?? DateTime.now(),
//         'amount': slot.amount ?? 0, // Individual price for first slot
//       };
//
//       if (!selectedSlots.any((s) => s.sId == slot.sId)) {
//         selectedSlots.add(slot);
//       }
//
//       // Add second slot (30 minutes) with half price
//       final halfKey = '${dateString}_${courtId}_${nextSlot.sId}_half';
//       multiDateSelections[halfKey] = {
//         'slot': Slots(sId: '${nextSlot.sId}_half', time: nextSlot.time, amount: (nextSlot.amount ?? 0) ~/ 2),
//         'courtId': courtId,
//         'courtName': courtName ?? '',
//         'date': dateString,
//         'dateTime': selectedDate.value ?? DateTime.now(),
//         'amount': (nextSlot.amount ?? 0) ~/ 2, // Half price for second slot
//       };
//     } else if (is90MinFromSecond) {
//       // Special case: 90min from second slot - add current slot with individual price and next slot with half price
//       final slot = allSlots[startIndex];
//       final nextSlot = allSlots[startIndex + 1];
//
//       final key = '${dateString}_${courtId}_${slot.sId}';
//       multiDateSelections[key] = {
//         'slot': slot,
//         'courtId': courtId,
//         'courtName': courtName ?? '',
//         'date': dateString,
//         'dateTime': selectedDate.value ?? DateTime.now(),
//         'amount': slot.amount ?? 0, // Individual price for first slot
//       };
//
//       if (!selectedSlots.any((s) => s.sId == slot.sId)) {
//         selectedSlots.add(slot);
//       }
//
//       // Add half slot
//       final halfKey = '${dateString}_${courtId}_${nextSlot.sId}_half';
//       multiDateSelections[halfKey] = {
//         'slot': Slots(sId: '${nextSlot.sId}_half', time: nextSlot.time, amount: (nextSlot.amount ?? 0) ~/ 2),
//         'courtId': courtId,
//         'courtName': courtName ?? '',
//         'date': dateString,
//         'dateTime': selectedDate.value ?? DateTime.now(),
//         'amount': (nextSlot.amount ?? 0) ~/ 2, // Half price for second slot
//       };
//     } else {
//       // Add all consecutive slots for 60min and 120min durations
//       for (int i = 0; i < slotsNeeded; i++) {
//         final slot = allSlots[startIndex + i];
//         final key = '${dateString}_${courtId}_${slot.sId}';
//         multiDateSelections[key] = {
//           'slot': slot,
//           'courtId': courtId,
//           'courtName': courtName ?? '',
//           'date': dateString,
//           'dateTime': selectedDate.value ?? DateTime.now(),
//           'amount': slot.amount ?? 0,
//         };
//
//         if (!selectedSlots.any((s) => s.sId == slot.sId)) {
//           selectedSlots.add(slot);
//         }
//       }
//     }
//   }
//
//   void _removeConsecutiveSlots(String courtId, String startSlotId, String dateString, int slotsNeeded) {
//     final courtData = slots.value?.data?.first;
//     if (courtData?.slots == null) return;
//
//     final allSlots = courtData!.slots!;
//     final startIndex = allSlots.indexWhere((s) => s.sId == startSlotId);
//     if (startIndex == -1) return;
//
//     // For 90min, remove both the main slot and the half slot
//     if (selectedDuration.value == '90 min') {
//       final slot = allSlots[startIndex];
//       final key = '${dateString}_${courtId}_${slot.sId}';
//       multiDateSelections.remove(key);
//       selectedSlots.removeWhere((s) => s.sId == slot.sId);
//
//       // Also remove the half slot if it exists
//       if (startIndex + 1 < allSlots.length) {
//         final nextSlot = allSlots[startIndex + 1];
//         final halfKey = '${dateString}_${courtId}_${nextSlot.sId}_half';
//         multiDateSelections.remove(halfKey);
//       }
//     } else {
//         // Remove all consecutive slots for other durations
//         for (int i = 0; i < slotsNeeded && startIndex + i < allSlots.length; i++) {
//           final slot = allSlots[startIndex + i];
//           final key = '${dateString}_${courtId}_${slot.sId}';
//           multiDateSelections.remove(key);
//           selectedSlots.removeWhere((s) => s.sId == slot.sId);
//         }
//     }
//   }
//
//   bool _isConsecutiveSelectionAllowed(String courtId, String slotId, String dateString) {
//     // Get all existing selections for the same date
//     final List<Map<String, dynamic>> existingSelections = [];
//     multiDateSelections.forEach((key, selection) {
//       if (selection['date'] == dateString) {
//         existingSelections.add(selection);
//       }
//     });
//
//     // If no existing selections, allow first selection
//     if (existingSelections.isEmpty) return true;
//
//     // Get the candidate slot details
//     final candidateSlot = _getSlotById(courtId, slotId);
//     if (candidateSlot == null) return false;
//
//     // Create a list of all slot times (existing + candidate)
//     final List<String> allTimes = [];
//     for (final selection in existingSelections) {
//       final slot = selection['slot'] as Slots;
//       if (slot.time != null) allTimes.add(slot.time!);
//     }
//     if (candidateSlot.time != null) allTimes.add(candidateSlot.time!);
//
//     // Convert times to comparable format and sort
//     final List<int> timeMinutes = [];
//     for (final timeStr in allTimes) {
//       final minutes = _convertTimeToMinutes(timeStr);
//       if (minutes != null) timeMinutes.add(minutes);
//     }
//
//     if (timeMinutes.length != allTimes.length) return false; // Some times couldn't be parsed
//
//     timeMinutes.sort();
//
//     // Check if all times are consecutive (assuming 1-hour slots)
//     for (int i = 1; i < timeMinutes.length; i++) {
//       if (timeMinutes[i] - timeMinutes[i - 1] != 60) {
//         return false; // Gap found
//       }
//     }
//
//     return true;
//   }
//
//   // Helper method to get slot by ID from a specific court
//   Slots? _getSlotById(String courtId, String slotId) {
//     final courts = slots.value?.data ?? [];
//     for (final court in courts) {
//       if (court.sId == courtId) {
//         final courtSlots = _originalSlotsCache[courtId] ?? court.slots ?? [];
//         for (final slot in courtSlots) {
//           if (slot.sId == slotId) return slot;
//         }
//       }
//     }
//     return null;
//   }
//
//   // Helper method to convert time string to minutes since midnight
//   int? _convertTimeToMinutes(String timeStr) {
//     try {
//       final cleanTime = timeStr.trim().toLowerCase();
//
//       // Try parsing with DateFormat first
//       DateTime? parsed;
//       for (final pattern in const ['h:mm a', 'h a', 'HH:mm', 'H:mm']) {
//         try {
//           parsed = DateFormat(pattern).parseStrict(cleanTime);
//           break;
//         } catch (_) {}
//       }
//
//       if (parsed != null) {
//         return parsed.hour * 60 + parsed.minute;
//       }
//
//       // Fallback manual parsing
//       final parts = cleanTime.split(' ');
//       String timePart = parts[0];
//       String? meridiem = parts.length > 1 ? parts[1] : null;
//
//       final timePieces = timePart.split(':');
//       int hour = int.tryParse(timePieces[0]) ?? 0;
//       int minute = timePieces.length > 1 ? int.tryParse(timePieces[1]) ?? 0 : 0;
//
//       if (meridiem == 'pm' && hour != 12) hour += 12;
//       if (meridiem == 'am' && hour == 12) hour = 0;
//
//       return hour * 60 + minute;
//     } catch (_) {
//       return null;
//     }
//   }
//
//   void _recalculateTotalAmount() {
//     int total = 0;
//     multiDateSelections.forEach((key, selection) {
//       if (selection.containsKey('amount')) {
//         total += selection['amount'] as int;
//       } else {
//         final slot = selection['slot'] as Slots;
//         total += slot.amount ?? 0;
//       }
//     });
//     totalAmount.value = total;
//   }
//
//   void recalculateRealCourtTotalAmount() {
//     int total = 0;
//     realCourtSelections.forEach((key, selection) {
//       if (selection.containsKey('amount')) {
//         total += selection['amount'] as int;
//       } else {
//         final slot = selection['slot'] as Slots;
//         total += slot.amount ?? 0;
//       }
//     });
//     totalAmount.value = total;
//   }
//
//   bool isPastAndUnavailable(Slots slot) {
//     // Treat booked or explicitly unavailable statuses as unavailable
//     final status = _normalizeStatus(slot.status);
//     if (status == 'booked') return true;
//     if (status.isNotEmpty && status != 'available') return true;
//
//     // If time is missing or malformed, don't mark as past (avoid crashes)
//     final rawTime = slot.time;
//     if (rawTime == null || rawTime.trim().isEmpty) {
//       return false;
//     }
//
//     final now = DateTime.now();
//     final selected = selectedDate.value ?? now;
//
//     try {
//       final timeString = rawTime.toLowerCase().trim();
//
//       // Try common formats first
//       DateTime? parsed;
//       for (final pattern in const ['h:mm a', 'h a', 'HH:mm', 'H:mm', 'HH']) {
//         try {
//           parsed = DateFormat(pattern).parseStrict(timeString);
//           break;
//         } catch (_) {}
//       }
//
//       int hour;
//       int minute;
//       if (parsed != null) {
//         hour = parsed.hour;
//         minute = parsed.minute;
//       } else {
//         // Fallback manual parse: supports "10", "10:30", with optional am/pm
//         String t = timeString;
//         String meridiem = '';
//         final parts = t.split(' ');
//         if (parts.length == 2) {
//           t = parts[0];
//           meridiem = parts[1];
//         }
//         final timePieces = t.split(':');
//         hour = int.tryParse(timePieces[0]) ?? 0;
//         minute = timePieces.length > 1 ? int.tryParse(timePieces[1]) ?? 0 : 0;
//         if (meridiem == 'pm' && hour != 12) hour += 12;
//         if (meridiem == 'am' && hour == 12) hour = 0;
//       }
//
//       final slotDateTime = DateTime(
//         selected.year,
//         selected.month,
//         selected.day,
//         hour,
//         minute,
//       );
//
//       final isToday = selected.year == now.year &&
//           selected.month == now.month &&
//           selected.day == now.day;
//
//       if (isToday && now.isAfter(slotDateTime)) {
//         return true;
//       }
//     } catch (_) {
//       // On any parsing error, consider it not past to be safe
//       return false;
//     }
//     return false;
//   }
//
//   bool _isUnavailableSlot(Slots slot) {
//     final availability = _normalizeStatus(slot.availabilityStatus);
//     final isBlocked = availability == "maintenance" ||
//         availability == "weather conditions" ||
//         availability == "staff unavailability";
//     final isBooked = (_normalizeStatus(slot.status) == 'booked');
//     final isPast = isPastAndUnavailable(slot);
//     return isPast || isBlocked || isBooked;
//   }
//
//   bool _isAvailableSlot(Slots slot) {
//     final status = _normalizeStatus(slot.status);
//     return !_isUnavailableSlot(slot) && (status == 'available' || status.isEmpty);
//   }
//
//   String _normalizeStatus(String? value) {
//     return (value ?? '').trim().toLowerCase();
//   }
//
//   bool isSlotSelected(Slots slot, String courtId) {
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//
//     if (selectedDuration.value == '30 min') {
//       // For 30 min, check if either half is selected
//       final leftKey = '${dateString}_${courtId}_${slot.sId}_left';
//       final rightKey = '${dateString}_${courtId}_${slot.sId}_right';
//       return multiDateSelections.containsKey(leftKey) || multiDateSelections.containsKey(rightKey);
//     } else {
//       // For other durations, check the main slot key
//       final multiDateKey = '${dateString}_${courtId}_${slot.sId}';
//       return multiDateSelections.containsKey(multiDateKey);
//     }
//   }
//
//   bool isRealCourtSlotSelected(Slots slot, String courtId) {
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//
//     if (selectedDuration.value == '30 min') {
//       // For 30 min, check if either half is selected
//       final leftKey = '${dateString}_${courtId}_${slot.sId}_left';
//       final rightKey = '${dateString}_${courtId}_${slot.sId}_right';
//       return realCourtSelections.containsKey(leftKey) || realCourtSelections.containsKey(rightKey);
//     } else if (selectedDuration.value == '90 min') {
//       // For 90 min, check full slot selection
//       final realCourtKey = '${dateString}_${courtId}_${slot.sId}';
//       return realCourtSelections.containsKey(realCourtKey);
//     } else if (selectedDuration.value == '120 min') {
//       // For 120 min, check if this slot or the previous slot is selected (since 120min spans 2 slots)
//       final realCourtKey = '${dateString}_${courtId}_${slot.sId}';
//       final secondSlotKey = '${realCourtKey}_second';
//       return realCourtSelections.containsKey(realCourtKey) || realCourtSelections.containsKey(secondSlotKey);
//     } else {
//       // For other durations, check full slot selection
//       final realCourtKey = '${dateString}_${courtId}_${slot.sId}';
//       return realCourtSelections.containsKey(realCourtKey);
//     }
//   }
//
//   /// Check if this slot should show as second slot in 90min selection for real courts
//   bool isSecondSlotIn90MinForRealCourt(dynamic slot, String courtId, List<dynamic>? availableSlots) {
//     if (selectedDuration.value != '90 min' || availableSlots == null) return false;
//
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//
//     final currentSlotIndex = availableSlots.indexWhere((s) => s.sId == slot.sId);
//     if (currentSlotIndex <= 0) return false;
//
//     final previousSlot = availableSlots[currentSlotIndex - 1];
//     final previousSlotKey = '${dateString}_${courtId}_${previousSlot.sId}';
//
//     // Only return true if the previous slot is selected AND this is the immediate next slot
//     final isPreviousSelected = realCourtSelections.containsKey(previousSlotKey);
//     final isImmediateNext = currentSlotIndex == availableSlots.indexWhere((s) => s.sId == previousSlot.sId) + 1;
//
//     return isPreviousSelected && isImmediateNext;
//   }
//
//   /// Check if this slot should show as second slot in 120min selection for real courts
//   bool isSecondSlotIn120MinForRealCourt(dynamic slot, String courtId, List<dynamic>? availableSlots) {
//     if (selectedDuration.value != '120 min' || availableSlots == null) return false;
//
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//
//     final currentSlotIndex = availableSlots.indexWhere((s) => s.sId == slot.sId);
//     if (currentSlotIndex <= 0) return false;
//
//     final previousSlot = availableSlots[currentSlotIndex - 1];
//     final previousSlotKey = '${dateString}_${courtId}_${previousSlot.sId}';
//
//     // Check if the previous slot is selected for 120min
//     return realCourtSelections.containsKey(previousSlotKey);
//   }
//
//   bool isBothHalvesSelectedInRealCourt(dynamic slot, String courtId) {
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//     final leftKey = '${dateString}_${courtId}_${slot.sId}_left';
//     final rightKey = '${dateString}_${courtId}_${slot.sId}_right';
//     return realCourtSelections.containsKey(leftKey) && realCourtSelections.containsKey(rightKey);
//   }
//
//   bool isLeftHalfSelectedInRealCourt(dynamic slot, String courtId) {
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//     final leftKey = '${dateString}_${courtId}_${slot.sId}_left';
//     return realCourtSelections.containsKey(leftKey);
//   }
//
//   bool _isTimeSlotSelectedInOtherCourtsForRealCourt(String? slotTime, String currentCourtId) {
//     if (slotTime == null) return false;
//
//     for (var entry in realCourtSelections.entries) {
//       final selection = entry.value;
//       final courtId = selection['courtId'] as String;
//       final slot = selection['slot'] as Slots;
//
//       // Skip if same court
//       if (courtId == currentCourtId) continue;
//
//       // Check if time matches
//       if (slot.time == slotTime) {
//         return true;
//       }
//     }
//
//     return false;
//   }
//
//   bool _isConsecutiveSelectionAllowedForCourts(String courtId, String slotId, String dateString) {
//     // Get all existing selections for the same court and date
//     final List<Map<String, dynamic>> existingSelections = [];
//     realCourtSelections.forEach((key, selection) {
//       if (selection['date'] == dateString && selection['courtId'] == courtId) {
//         existingSelections.add(selection);
//       }
//     });
//
//     // If no existing selections, allow first selection
//     if (existingSelections.isEmpty) return true;
//
//     // Get the candidate slot details
//     final candidateSlot = _getSlotById(courtId, slotId);
//     if (candidateSlot == null) return false;
//
//     // Create a list of all slot times (existing + candidate)
//     final List<String> allTimes = [];
//     for (final selection in existingSelections) {
//       final slot = selection['slot'] as Slots;
//       if (slot.time != null) allTimes.add(slot.time!);
//     }
//     if (candidateSlot.time != null) allTimes.add(candidateSlot.time!);
//
//     // Convert times to comparable format and sort
//     final List<int> timeMinutes = [];
//     for (final timeStr in allTimes) {
//       final minutes = _convertTimeToMinutes(timeStr);
//       if (minutes != null) timeMinutes.add(minutes);
//     }
//
//     if (timeMinutes.length != allTimes.length) return false; // Some times couldn't be parsed
//
//     timeMinutes.sort();
//
//     // Check if all times are consecutive (assuming 1-hour slots)
//     for (int i = 1; i < timeMinutes.length; i++) {
//       if (timeMinutes[i] - timeMinutes[i - 1] != 60) {
//         return false; // Gap found
//       }
//     }
//
//     return true;
//   }
//
//   /// Get next hour time for 90min half slot display
//   String _getNextHourTime(String currentTime) {
//     try {
//       final hour = parseHour24(currentTime);
//       if (hour != null) {
//         final nextHour = (hour + 1) % 24;
//         final period = nextHour >= 12 ? 'pm' : 'am';
//         final displayHour = nextHour == 0 ? 12 : (nextHour > 12 ? nextHour - 12 : nextHour);
//         return '$displayHour $period';
//       }
//     } catch (e) {
//       // Fallback
//     }
//     return currentTime;
//   }
//
//   ///Fetch All Slot Prices------------------------------------------------------
//   Future<void> fetchAllSlotPrices(String clubId, {String? selectedTimes}) async {
//     try {
//       isSlotPricesLoading.value = true;
//
//       final selectedDurationMinutes = int.tryParse(selectedDuration.value.replaceAll(' min', '')) ?? 60;
//
//       final result = await repository.getAllSlotPricesOfCourt(
//         registerClubId: clubId,
//         duration: selectedDurationMinutes.toString(), // Send selected duration
//         day: '', // Get all days
//         timePeriod: '', // Send selected times or empty for all
//       );
//
//       allSlotPricesResponse.value = result;
//
//       // Clear existing data
//       slotPricesData.clear();
//       originalSlotPricesData.clear();
//
//       // Parse and store the data
//       if (result.data?.isNotEmpty ?? false) {
//         for (final item in result.data!) {
//           final day = item.day;
//           final duration = item.duration?.toString();
//           final price = item.price ?? 0;
//
//           if (day != null && duration != null) {
//             slotPricesData[day] ??= {};
//             slotPricesData[day]![duration] = price;
//
//             // Store original prices
//             originalSlotPricesData[day] ??= {};
//             originalSlotPricesData[day]![duration] = price;
//           }
//         }
//       }
//
//       CustomLogger.logMessage(
//         msg: "Fetched slot prices for selected times: $selectedTimes, data: $slotPricesData",
//         level: LogLevel.info,
//       );
//
//     } catch (e, st) {
//       CustomLogger.logMessage(
//         msg: "Error fetching slot prices: ${e.toString()}",
//         level: LogLevel.error,
//         st: st,
//       );
//     } finally {
//       isSlotPricesLoading.value = false;
//     }
//   }
//
//   /// Find price for a specific slot time from fetchAllSlotPrices data
//   int? findPriceForSlot(String slotTime, String day, int duration) {
//     final slotPrices = allSlotPricesResponse.value?.data;
//     if (slotPrices == null) return null;
//
//     // Parse slot time to 24-hour format
//     final slotHour = parseHour24(slotTime);
//     if (slotHour == null) return null;
//
//     // Find matching price entry
//     for (final priceEntry in slotPrices) {
//       if (priceEntry.day != day || priceEntry.duration != duration) continue;
//
//       final slotTimeRange = priceEntry.slotTime;
//       if (slotTimeRange == null) continue;
//
//       // Check if slot time falls within the price range
//       if (isTimeInRange(slotHour, slotTimeRange)) {
//         return priceEntry.price;
//       }
//     }
//
//     return null;
//   }
//
//   /// Check if a time falls within a time range (e.g., "6:00 AM - 11:00 AM")
//   bool isTimeInRange(int slotHour, String timeRange) {
//     try {
//       final parts = timeRange.split(' - ');
//       if (parts.length != 2) return false;
//
//       final startHour = parseHour24(parts[0].trim());
//       final endHour = parseHour24(parts[1].trim());
//
//       if (startHour == null || endHour == null) return false;
//
//       // Handle cases where end time is inclusive (e.g., 6 AM - 11 AM includes 11 AM)
//       return slotHour >= startHour && slotHour <= endHour;
//     } catch (e) {
//       return false;
//     }
//   }
//
//   /// Parse time string to 24-hour format
//   int? parseHour24(String? timeStr) {
//     if (timeStr == null || timeStr.isEmpty) return null;
//     final t = timeStr.trim().toLowerCase();
//     try {
//       final dt = DateFormat('h:mm a').parseStrict(t);
//       return dt.hour;
//     } catch (_) {
//       try {
//         final dt = DateFormat('h a').parseStrict(t);
//         return dt.hour;
//       } catch (_) {
//         final parts = t.split(' ');
//         if (parts.length == 2) {
//           final isPm = parts[1] == 'pm';
//           final hm = parts[0].split(':');
//           final h = int.tryParse(hm[0]);
//           if (h == null) return null;
//           var hour = h % 12;
//           if (isPm) hour += 12;
//           return hour;
//         }
//         return null;
//       }
//     }
//   }
//
//   String getWeekday(int weekday) {
//     switch (weekday) {
//       case 1: return 'Monday';
//       case 2: return 'Tuesday';
//       case 3: return 'Wednesday';
//       case 4: return 'Thursday';
//       case 5: return 'Friday';
//       case 6: return 'Saturday';
//       case 7: return 'Sunday';
//       default: return '';
//     }
//   }
//
//   // Fetch courts by duration when all required data is available
//   void fetchCourtsIfReady() {
//     if (selectedDate.value != null && selectedDuration.value.isNotEmpty && selectedTimeSlot.value.isNotEmpty) {
//       fetchCourtsByDuration();
//     }
//   }
//
//   // Convert time format from "7:00 PM" to "7 pm"
//   String _formatTimeForAPI(String time) {
//     if (time.isEmpty) return time;
//
//     try {
//       // Parse the time string
//       final timeString = time.trim();
//
//       // Try to parse with common formats
//       DateTime? parsedTime;
//       for (final pattern in ['h:mm a', 'h a', 'HH:mm', 'H:mm']) {
//         try {
//           parsedTime = DateFormat(pattern).parse(timeString);
//           break;
//         } catch (_) {}
//       }
//
//       if (parsedTime != null) {
//         int hour = parsedTime.hour;
//         String period = hour >= 12 ? 'pm' : 'am';
//
//         // Convert to 12-hour format
//         if (hour == 0) {
//           hour = 12;
//         } else if (hour > 12) {
//           hour = hour - 12;
//         }
//
//         return '$hour $period';
//       }
//
//       // Fallback: manual parsing
//       final parts = timeString.split(' ');
//       String timePart = parts[0];
//       String? period = parts.length > 1 ? parts[1].toLowerCase() : null;
//
//       // Remove minutes (everything after colon)
//       if (timePart.contains(':')) {
//         timePart = timePart.split(':')[0];
//       }
//
//       int? hour = int.tryParse(timePart);
//       if (hour != null) {
//         // Determine period if not provided
//         if (period == null) {
//           period = hour >= 12 ? 'pm' : 'am';
//         } else {
//           period = period.toLowerCase();
//         }
//
//         // Convert to 12-hour format if needed
//         if (hour == 0) {
//           hour = 12;
//         } else if (hour > 12) {
//           hour = hour - 12;
//           period = 'pm';
//         } else if (hour == 12 && period == 'am') {
//           hour = 12;
//         }
//
//         return '$hour $period';
//       }
//     } catch (e) {
//       log('Error formatting time: $e');
//     }
//
//     // Return original if parsing fails
//     return time;
//   }
//
//   // Fetch courts by duration from API
//   Future<void> fetchCourtsByDuration() async {
//     try {
//       isLoadingCourtsByDuration.value = true;
//
//       final dateString = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
//       final duration = selectedDuration.value.replaceAll(' min', ''); // Remove 'min' suffix
//
//       // Convert time format from "7:00 PM" to "7 pm"
//       String formattedTime = _formatTimeForAPI(selectedTimeSlot.value);
//
//       final response = await repository.getCourtsByDuration(
//         duration: duration,
//         date: dateString,
//         time: formattedTime,
//       );
//
//       courtsByDuration.value = response;
//
//       // Collect all selected slot times for fetchAllSlotPrices API
//       String selectedTimes = '';
//       if (multiDateSelections.isNotEmpty) {
//         final selectedSlotTimes = <String>{};
//         multiDateSelections.forEach((key, selection) {
//           final slot = selection['slot'] as Slots;
//           if (slot.time != null && slot.time!.isNotEmpty) {
//             selectedSlotTimes.add(_formatTimeForAPI(slot.time!));
//           }
//         });
//         selectedTimes = selectedSlotTimes.join(',');
//       }
//
//       // Fetch slot prices for each court data
//       if (response.data != null) {
//         for (var courtData in response.data!) {
//           if (courtData.registerClub?.id != null) {
//             await fetchAllSlotPrices(courtData.registerClub!.id!, selectedTimes: selectedTimes);
//             updateSlotPricesForCourts();
//           }
//         }
//       }
//
//   bool _isTimeSlotSelectedInOtherCourtsForRealCourt(String? slotTime, String currentCourtId) {
//     if (slotTime == null || slotTime.isEmpty) return false;
//
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//
//     for (final entry in realCourtSelections.entries) {
//       final selection = entry.value;
//       final existingDate = selection['date'] as String;
//       final existingCourtId = selection['courtId'] as String;
//       final existingSlot = selection['slot'] as Slots;
//
//       // Check if same date, different court, and same time
//       if (existingDate == dateString &&
//           existingCourtId != currentCourtId &&
//           existingSlot.time == slotTime) {
//         return true;
//       }
//     }
//     return false;
//   }
//
//   bool isTimeSlotSelectedInOtherCourts(String? slotTime, String currentCourtId) {
//     if (slotTime == null || slotTime.isEmpty) return false;
//
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//
//     for (final entry in multiDateSelections.entries) {
//       final selection = entry.value;
//       final existingDate = selection['date'] as String;
//       final existingCourtId = selection['courtId'] as String;
//       final existingSlot = selection['slot'] as Slots;
//
//       // Check if same date, different court, and same time
//       if (existingDate == dateString &&
//           existingCourtId != currentCourtId &&
//           existingSlot.time == slotTime) {
//         return true;
//       }
//     }
//     return false;
//   }
//
//   List<Slots> getThreeConsecutiveSlots(Slots firstSlot) {
//     final courtData = slots.value?.data?.first;
//     if (courtData?.slots == null) return [];
//
//     final allSlots = courtData!.slots!;
//     final startIndex = allSlots.indexWhere((s) => s.sId == firstSlot.sId);
//     if (startIndex == -1 || startIndex + 2 >= allSlots.length) return [];
//
//     return [
//       allSlots[startIndex],
//       allSlots[startIndex + 1],
//       allSlots[startIndex + 2],
//     ];
//   }
//
//   int getTotalSelectionsCount() {
//     return multiDateSelections.length;
//   }
//
//   Map<String, List<Map<String, dynamic>>> getSelectionsByDate() {
//     final Map<String, List<Map<String, dynamic>>> result = {};
//     multiDateSelections.forEach((key, selection) {
//       final dateString = selection['date'] as String;
//       if (!result.containsKey(dateString)) {
//         result[dateString] = [];
//       }
//       result[dateString]!.add(selection);
//     });
//     return result;
//   }
//
//   void clearAllSelections() {
//     multiDateSelections.clear();
//     realCourtSelections.clear();
//     selectedSlots.clear();
//     totalAmount.value = 0;
//     // Clear courts by duration when selections are cleared
//     courtsByDuration.value = null;
//     selectedTimeSlot.value = ''; // Clear selected time slot
//     // Clear search slot selection and expand
//     selectedSearchSlotId.value = null;
//     isSlotsCollapsed.value = false;
//   }
//
//   // Fetch courts by duration when all required data is available
//   void fetchCourtsIfReady() {
//     if (selectedDate.value != null && selectedDuration.value.isNotEmpty && selectedTimeSlot.value.isNotEmpty) {
//       fetchCourtsByDuration();
//     }
//   }
//
//   // Fetch courts by duration from API
//   Future<void> fetchCourtsByDuration() async {
//     try {
//       isLoadingCourtsByDuration.value = true;
//
//       final dateString = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
//       final duration = selectedDuration.value.replaceAll(' min', ''); // Remove 'min' suffix
//
//       // Convert time format from "7:00 PM" to "7 pm"
//       String formattedTime = _formatTimeForAPI(selectedTimeSlot.value);
//
//       final response = await _homeRepository.getCourtsByDuration(
//         duration: duration,
//         date: dateString,
//         time: formattedTime,
//       );
//
//       courtsByDuration.value = response;
//
//       // Debug: Print the entire response structure
//       print("Debug - courtsByDuration API response: ${response.toJson()}");
//       if (response.data != null) {
//         for (var club in response.data!) {
//           print("Debug - Club: ${club.clubId}, businessHours available: ${club.businessHours != null}");
//           if (club.businessHours != null) {
//             print("Debug - businessHours count: ${club.businessHours!.length}");
//             for (var bh in club.businessHours!) {
//               print("Debug - businessHour: ${bh.toJson()}");
//             }
//           }
//         }
//       }
//
//       // Collect all selected slot times for fetchAllSlotPrices API
//       String selectedTimes = '';
//       if (multiDateSelections.isNotEmpty) {
//         final selectedSlotTimes = <String>{};
//         multiDateSelections.forEach((key, selection) {
//           final slot = selection['slot'] as Slots;
//           if (slot.time != null && slot.time!.isNotEmpty) {
//             selectedSlotTimes.add(_formatTimeForAPI(slot.time!));
//           }
//         });
//         selectedTimes = selectedSlotTimes.join(',');
//       }
//
//       // Fetch slot prices for each court data
//       if (response.data != null) {
//         for (var courtData in response.data!) {
//           if (courtData.registerClub?.id != null) {
//             await fetchAllSlotPrices(courtData.registerClub!.id!, selectedTimes: selectedTimes);
//             updateSlotPricesForCourts();
//           }
//         }
//       }
//
//     } catch (e, stackTrace) {
//       log("Error fetching courts by duration: $e");
//       log("Stack trace: $stackTrace");
//       courtsByDuration.value = null;
//
//       Get.snackbar(
//         "Error",
//         "Failed to load courts. Please try again.",
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.TOP,
//       );
//     } finally {
//       isLoadingCourtsByDuration.value = false;
//     }
//   }
//
//   // Convert time format from "7:00 PM" to "7 pm"
//   String _formatTimeForAPI(String time) {
//     if (time.isEmpty) return time;
//
//     try {
//       // Parse the time string
//       final timeString = time.trim();
//
//       // Try to parse with common formats
//       DateTime? parsedTime;
//       for (final pattern in ['h:mm a', 'h a', 'HH:mm', 'H:mm']) {
//         try {
//           parsedTime = DateFormat(pattern).parse(timeString);
//           break;
//         } catch (_) {}
//       }
//
//       if (parsedTime != null) {
//         int hour = parsedTime.hour;
//         String period = hour >= 12 ? 'pm' : 'am';
//
//         // Convert to 12-hour format
//         if (hour == 0) {
//           hour = 12;
//         } else if (hour > 12) {
//           hour = hour - 12;
//         }
//
//         return '$hour $period';
//       }
//
//       // Fallback: manual parsing
//       final parts = timeString.split(' ');
//       String timePart = parts[0];
//       String? period = parts.length > 1 ? parts[1].toLowerCase() : null;
//
//       // Remove minutes (everything after colon)
//       if (timePart.contains(':')) {
//         timePart = timePart.split(':')[0];
//       }
//
//       int? hour = int.tryParse(timePart);
//       if (hour != null) {
//         // Determine period if not provided
//         if (period == null) {
//           period = hour >= 12 ? 'pm' : 'am';
//         } else {
//           period = period.toLowerCase();
//         }
//
//         // Convert to 12-hour format if needed
//         if (hour == 0) {
//           hour = 12;
//         } else if (hour > 12) {
//           hour = hour - 12;
//           period = 'pm';
//         } else if (hour == 12 && period == 'am') {
//           hour = 12;
//         }
//
//         return '$hour $period';
//       }
//     } catch (e) {
//       log('Error formatting time: $e');
//     }
//
//     // Return original if parsing fails
//     return time;
//   }
//
//   ///Fetch All Slot Prices------------------------------------------------------
//   Future<void> fetchAllSlotPrices(String clubId, {String? selectedTimes}) async {
//     try {
//       isSlotPricesLoading.value = true;
//
//       final selectedDurationMinutes = int.tryParse(selectedDuration.value.replaceAll(' min', '')) ?? 60;
//
//       final result = await _homeRepository.getAllSlotPricesOfCourt(
//         registerClubId: clubId,
//         duration: selectedDurationMinutes.toString(), // Send selected duration
//         day: '', // Get all days
//         timePeriod: '', // Send selected times or empty for all
//       );
//
//       allSlotPricesResponse.value = result;
//
//       // Clear existing data
//       slotPricesData.clear();
//       originalSlotPricesData.clear();
//
//       // Parse and store the data
//       if (result.data?.isNotEmpty ?? false) {
//         for (final item in result.data!) {
//           final day = item.day;
//           final duration = item.duration?.toString();
//           final price = item.price ?? 0;
//
//           if (day != null && duration != null) {
//             slotPricesData[day] ??= {};
//             slotPricesData[day]![duration] = price;
//
//             // Store original prices
//             originalSlotPricesData[day] ??= {};
//             originalSlotPricesData[day]![duration] = price;
//           }
//         }
//       }
//
//       CustomLogger.logMessage(
//         msg: "Fetched slot prices for selected times: $selectedTimes, data: $slotPricesData",
//         level: LogLevel.info,
//       );
//
//     } catch (e, st) {
//       CustomLogger.logMessage(
//         msg: "Error fetching slot prices: ${e.toString()}",
//         level: LogLevel.error,
//         st: st,
//       );
//     } finally {
//       isSlotPricesLoading.value = false;
//     }
//   }
//
//   /// Update slot prices from fetchAllSlotPrices API
//   void updateSlotPricesForCourts() {
//     final courtDataList = courtsByDuration.value?.data;
//     if (courtDataList == null) return;
//
//     final selectedDurationMinutes = int.tryParse(selectedDuration.value.replaceAll(' min', '')) ?? 60;
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dayName = getWeekday(currentDate.weekday);
//
//     for (var courtData in courtDataList) {
//       if (courtData.slots == null) continue;
//
//       for (var slot in courtData.slots!) {
//         final slotTime = slot.time;
//         if (slotTime == null) continue;
//
//         int? slotPrice;
//
//         if (selectedDurationMinutes == 90) {
//           // For 90min display: show only 60min price
//           slotPrice = findPriceForSlot(slotTime, dayName, 60);
//         } else {
//           // For other durations, use the duration price directly
//           final duration = selectedDurationMinutes == 120 ? 60 : selectedDurationMinutes;
//           slotPrice = findPriceForSlot(slotTime, dayName, duration);
//         }
//
//         if (slotPrice != null) {
//           slot.amount = slotPrice;
//         }
//       }
//     }
//   }
//
//   /// Find price for a specific slot time from fetchAllSlotPrices data
//   int? findPriceForSlot(String slotTime, String day, int duration) {
//     final slotPrices = allSlotPricesResponse.value?.data;
//     if (slotPrices == null) return null;
//
//     // Parse slot time to 24-hour format
//     final slotHour = parseHour24(slotTime);
//     if (slotHour == null) return null;
//
//     // Find matching price entry
//     for (final priceEntry in slotPrices) {
//       if (priceEntry.day != day || priceEntry.duration != duration) continue;
//
//       final slotTimeRange = priceEntry.slotTime;
//       if (slotTimeRange == null) continue;
//
//       // Check if slot time falls within the price range
//       if (isTimeInRange(slotHour, slotTimeRange)) {
//         return priceEntry.price;
//       }
//     }
//
//     return null;
//   }
//
//   /// Check if a time falls within a time range (e.g., "6:00 AM - 11:00 AM")
//   bool isTimeInRange(int slotHour, String timeRange) {
//     try {
//       final parts = timeRange.split(' - ');
//       if (parts.length != 2) return false;
//
//       final startHour = parseHour24(parts[0].trim());
//       final endHour = parseHour24(parts[1].trim());
//
//       if (startHour == null || endHour == null) return false;
//
//       // Handle cases where end time is inclusive (e.g., 6 AM - 11 AM includes 11 AM)
//       return slotHour >= startHour && slotHour <= endHour;
//     } catch (e) {
//       return false;
//     }
//   }
//
//   /// Parse time string to 24-hour format
//   int? parseHour24(String? timeStr) {
//     if (timeStr == null || timeStr.isEmpty) return null;
//     final t = timeStr.trim().toLowerCase();
//     try {
//       final dt = DateFormat('h:mm a').parseStrict(t);
//       return dt.hour;
//     } catch (_) {
//       try {
//         final dt = DateFormat('h a').parseStrict(t);
//         return dt.hour;
//       } catch (_) {
//         final parts = t.split(' ');
//         if (parts.length == 2) {
//           final isPm = parts[1] == 'pm';
//           final hm = parts[0].split(':');
//           final h = int.tryParse(hm[0]);
//           if (h == null) return null;
//           var hour = h % 12;
//           if (isPm) hour += 12;
//           return hour;
//         }
//         return null;
//       }
//     }
//   }
//
//   String getWeekday(int weekday) {
//     switch (weekday) {
//       case 1: return 'Monday';
//       case 2: return 'Tuesday';
//       case 3: return 'Wednesday';
//       case 4: return 'Thursday';
//       case 5: return 'Friday';
//       case 6: return 'Saturday';
//       case 7: return 'Sunday';
//       default: return '';
//     }
//   }
//
//   // Helper method to check if slot is already selected
//   bool _isSlotAlreadySelected(String slotId, Map<String, Map<String, dynamic>> selections) {
//     return selections.values.any((selection) {
//       final slot = selection['slot'] as Slots;
//       return slot.sId == slotId;
//     });
//   }
//
//   // Helper method to check consecutive selection for court rows
//   bool _isConsecutiveSelectionAllowedForCourts(String courtId, String slotId, String dateString) {
//     if (realCourtSelections.isEmpty) return true;
//
//     // Get all selected slot times across ALL courts for the same date
//     final selectedTimes = <String>[];
//     realCourtSelections.forEach((key, selection) {
//       if (selection['date'] == dateString) {
//         final slot = selection['slot'] as Slots;
//         if (slot.time != null) selectedTimes.add(slot.time!);
//       }
//     });
//
//     // Get the candidate slot time
//     final candidateSlot = _getSlotFromCourts(slotId);
//     final candidateTime = candidateSlot?.time;
//     if (candidateTime == null) return false;
//
//     selectedTimes.add(candidateTime);
//
//     // Check if all times are consecutive across all courts
//     return _areTimesConsecutive(selectedTimes);
//   }
//
//   // Helper method to get slot from courts data
//   dynamic _getSlotFromCourts(String slotId) {
//     if (courtsByDuration.value?.data != null) {
//       for (var club in courtsByDuration.value!.data!) {
//         if (club.courts != null) {
//           for (var court in club.courts!) {
//             if (court.availabilityByTime != null) {
//               for (var availability in court.availabilityByTime!) {
//                 if (availability.slots != null) {
//                   for (var slot in availability.slots!) {
//                     if (slot.sId == slotId) return slot;
//                   }
//                 }
//               }
//             }
//           }
//         }
//       }
//     }
//     return null;
//   }
//
//   // Helper method to check if times are consecutive
//   bool _areTimesConsecutive(List<String> times) {
//     if (times.length <= 1) return true;
//
//     final timeMinutes = <int>[];
//     for (final timeStr in times) {
//       final minutes = _convertTimeToMinutes(timeStr);
//       if (minutes != null) timeMinutes.add(minutes);
//     }
//
//     if (timeMinutes.length != times.length) return false;
//
//     timeMinutes.sort();
//
//     for (int i = 1; i < timeMinutes.length; i++) {
//       if (timeMinutes[i] - timeMinutes[i - 1] != 60) {
//         return false;
//       }
//     }
//
//     return true;
//   }
//
//   bool isBothHalvesSelected(dynamic slot, String courtId) {
//     return isLeftHalfSelected(slot, courtId) && isRightHalfSelected(slot, courtId);
//   }
//
//   bool isBothHalvesSelectedInRealCourt(dynamic slot, String courtId) {
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//     final leftKey = '${dateString}_${courtId}_${slot.sId}_left';
//     final rightKey = '${dateString}_${courtId}_${slot.sId}_right';
//     return realCourtSelections.containsKey(leftKey) && realCourtSelections.containsKey(rightKey);
//   }
//
//   bool isLeftHalfSelected(dynamic slot, String courtId) {
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//     final leftKey = '${dateString}_${courtId}_${slot.sId}_left';
//     return multiDateSelections.containsKey(leftKey);
//   }
//
//   bool isRightHalfSelected(dynamic slot, String courtId) {
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//     final rightKey = '${dateString}_${courtId}_${slot.sId}_right';
//     return multiDateSelections.containsKey(rightKey);
//   }
//
//   // Helper methods for real court half selections
//   bool isLeftHalfSelectedInRealCourt(dynamic slot, String courtId) {
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//     final leftKey = '${dateString}_${courtId}_${slot.sId}_left';
//     return realCourtSelections.containsKey(leftKey);
//   }
//
//   bool isRightHalfSelectedInRealCourt(dynamic slot, String courtId) {
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//     final rightKey = '${dateString}_${courtId}_${slot.sId}_right';
//     return realCourtSelections.containsKey(rightKey);
//   }
//
//   /// Check if this slot should show as second slot in 90min selection for real courts
//   bool isSecondSlotIn90MinForRealCourt(dynamic slot, String courtId, List<dynamic>? availableSlots) {
//     if (selectedDuration.value != '90 min' || availableSlots == null) return false;
//
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//
//     final currentSlotIndex = availableSlots.indexWhere((s) => s.sId == slot.sId);
//     if (currentSlotIndex <= 0) return false;
//
//     final previousSlot = availableSlots[currentSlotIndex - 1];
//     final previousSlotKey = '${dateString}_${courtId}_${previousSlot.sId}';
//
//     // Only return true if the previous slot is selected AND this is the immediate next slot
//     final isPreviousSelected = realCourtSelections.containsKey(previousSlotKey);
//     final isImmediateNext = currentSlotIndex == availableSlots.indexWhere((s) => s.sId == previousSlot.sId) + 1;
//
//     return isPreviousSelected && isImmediateNext;
//   }
//
//   /// Check if this slot should show as second slot in 120min selection for real courts
//   bool isSecondSlotIn120MinForRealCourt(dynamic slot, String courtId, List<dynamic>? availableSlots) {
//     if (selectedDuration.value != '120 min' || availableSlots == null) return false;
//
//     final currentDate = selectedDate.value ?? DateTime.now();
//     final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
//
//     final currentSlotIndex = availableSlots.indexWhere((s) => s.sId == slot.sId);
//     if (currentSlotIndex <= 0) return false;
//
//     final previousSlot = availableSlots[currentSlotIndex - 1];
//     final previousSlotKey = '${dateString}_${courtId}_${previousSlot.sId}';
//
//     // Check if the previous slot is selected for 120min
//     return realCourtSelections.containsKey(previousSlotKey);
//   }
//
//   /// Format time from "7pm" to "7:00 pm" for UI display
//   String formatTimeForDisplay(String? time) {
//     if (time == null || time.isEmpty) return '';
//
//     final timeStr = time.trim().toLowerCase();
//
//     // If already in correct format, return as is
//     if (timeStr.contains(':')) {
//       return time;
//     }
//
//     // Parse time like "7pm" or "7am"
//     final match = RegExp(r'(\d+)\s*(am|pm)').firstMatch(timeStr);
//     if (match != null) {
//       final hour = match.group(1);
//       final period = match.group(2);
//       return '$hour:00 $period';
//     }
//
//     return time; // Return original if parsing fails
//   }
//
//   /// Get next hour time for 90min half slot display
//   String _getNextHourTime(String currentTime) {
//     try {
//       final hour = parseHour24(currentTime);
//       if (hour != null) {
//         final nextHour = (hour + 1) % 24;
//         final period = nextHour >= 12 ? 'pm' : 'am';
//         final displayHour = nextHour == 0 ? 12 : (nextHour > 12 ? nextHour - 12 : nextHour);
//         return '$displayHour $period';
//       }
//     } catch (e) {
//       // Fallback
//     }
//     return currentTime;
//   }
// }
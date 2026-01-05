import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/core/network/dio_client.dart';
import 'package:padel_mobile/data/response_models/get_all_slot_prices_of_court_model.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import '../../../../data/request_models/home_models/get_available_court.dart';
import '../../../../data/request_models/home_models/get_club_name_model.dart';
import '../../../../repositories/cart/cart_repository.dart';
import '../../../../repositories/home_repository/home_repository.dart';
import '../../../cart/cart_controller.dart';
import '../../../../configs/routes/routes_name.dart';
import '../../../booking/details_page/details_page_controller.dart';
import '../questions_bottomsheet/questions_bottomsheet_controller.dart';
import '../questions_bottomsheet/questions_bottomsheet_screen.dart';

class CreateOpenMatchesController extends GetxController {
  // Booking limits
  static const int maxSlots = 3; // Limit for open matches
  static const int maxDays = 1; // Single day for open matches
  final focusedMonth = DateTime.now().obs;
  
  final selectedDate = Rxn<DateTime>();
  final selectedDuration = '60 min'.obs;

  Courts argument = Courts();
  RxBool showUnavailableSlots = false.obs;
  RxInt currentPage = 0.obs;
  var selectedTimeOfDay = 0.obs;
  var isManualTabSelection = false.obs;

  var morningCount = 0.obs;
  var noonCount = 0.obs;
  var nightCount = 0.obs;

  // Date formatter for consistency
  static final _dateFormatter = DateFormat('yyyy-MM-dd');

  void select(String value) async {
    selectedDuration.value = value;
    // Clear all selections when duration changes
    multiDateSelections.clear();
    selectedSlots.clear();
    selectedSlotsWithCourtInfo.clear();
    totalAmount.value = 0;
    // Refetch courts with updated prices when duration changes
    if (slots.value != null) {
      await getAvailableCourtsById(argument.id!, showUnavailable: true);
    }
  }

  // Cache base slot lists (after unavailable/available toggle applied)
  final Map<String, List<Slots>> _originalSlotsCache = {};
  final Map<String, List<Slots>> _allSlotsCache = {}; // Combined slots cache

  PageController pageController = PageController();

  // OLD: Single date selections
  RxList<Slots> selectedSlots = <Slots>[].obs;

  // NEW: Multi-date selections - key format: "date_courtId_slotId"
  RxMap<String, Map<String, dynamic>> multiDateSelections = <String, Map<String, dynamic>>{}.obs;

  RxInt totalAmount = 0.obs;
  final HomeRepository repository = HomeRepository();
  Rx<GetAllActiveCourtsForSlotWiseModel?> slots = Rx<GetAllActiveCourtsForSlotWiseModel?>(null);
  RxBool isLoadingCourts = false.obs;
  CartRepository cartRepository = CartRepository();

  // Keep existing for backward compatibility
  RxMap<String, Map<String, dynamic>> selectedSlotsWithCourtInfo = <String, Map<String, dynamic>>{}.obs;
  RxBool isBottomSheetOpen = false.obs;
  @override
  void onInit() {
    super.onInit();
    argument = Get.arguments['id'];
    selectedDate.value = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchAllSlotPrices();
      await getAvailableCourtsById(argument.id!, showUnavailable: true);
    });
  }

  @override
  void onClose() {
    selectedSlots.clear();
    selectedSlotsWithCourtInfo.clear();
    multiDateSelections.clear();
    totalAmount.value = 0;
    pageController.dispose();
    super.onClose();
  }



  void onNext() {
    log("Slots -> $selectedSlots");

    if (multiDateSelections.isEmpty) {
      SnackBarUtils.showInfoSnackBar("Please select at least one slot to continue.");
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

    detailsController.localMatchData.update("clubName", (value) => slots.value!.data![0].clubName ?? "");
    detailsController.localMatchData.update("address", (value) => slots.value!.data![0].registerClubId?.address ?? "");
    detailsController.localMatchData.update("clubId", (v) => slots.value!.data![0].registerClubId!.sId ?? "");
    // ✅ Store ownerId from registerClubId for booking payload (use direct assignment to avoid missing-key issues)
    detailsController.localMatchData["ownerId"] =
        slots.value!.data![0].registerClubId?.ownerId?.sId ?? "";
    detailsController.localMatchData.update("matchDate", (v) => selectedDate.value ?? "");
    detailsController.localMatchData.update("clubImage", (v)=> slots.value!.data![0].registerClubId?.courtImage ??[]);
    detailsController.localMatchData.update(
      "matchTime",
          (v) => selectedSlots.map((s) => s.time).toList(),
    );    detailsController.localMatchData.update("price", (v) => totalAmount.toString());
    // Get court types for all selected courts
    final courtTypes = slots.value!.data![0].registerClubId!.courtType ?? [];
    final courts = slots.value?.data ?? [];
    List<String> selectedCourtTypes = [];
    
    // Get court type for each selected court
    for (String courtId in courtIds) {
      int courtIndex = -1;
      for (int i = 0; i < courts.length; i++) {
        if (courts[i].sId == courtId) {
          courtIndex = i;
          break;
        }
      }
      
      if (courtIndex >= 0 && courtIndex < courtTypes.length) {
        selectedCourtTypes.add(courtTypes[courtIndex]);
      } else if (courtTypes.isNotEmpty) {
        selectedCourtTypes.add(courtTypes.first); // fallback
      }
    }
    
    // If single court, send string; if multiple courts, send list
    final courtTypeValue = selectedCourtTypes.length == 1 
        ? selectedCourtTypes.first 
        : selectedCourtTypes;
    
    detailsController.localMatchData.update("courtType", (v) => courtTypeValue);
    // Update slot data with duration, totalTime, and bookingTime from selections
    List<Slots> updatedSlots = [];
    Map<String, Slots> consolidatedSlots = {}; // To merge both halves of 30min slots
    
    for (Slots slot in selectedSlots) {
      // Find the selection data for this slot
      Map<String, dynamic>? leftHalfSelection;
      Map<String, dynamic>? rightHalfSelection;
      
      multiDateSelections.forEach((key, selection) {
        final selectionSlot = selection['slot'] as Slots;
        if (selectionSlot.sId == slot.sId) {
          if (key.endsWith('_L')) {
            leftHalfSelection = selection;
          } else if (key.endsWith('_R')) {
            rightHalfSelection = selection;
          } else {
            // Non-30min selection
            leftHalfSelection = selection;
          }
        }
      });
      
      final selectedDurationMinutes = int.tryParse(selectedDuration.value.replaceAll(' min', '')) ?? 60;
      
      if (selectedDurationMinutes == 30 && leftHalfSelection != null && rightHalfSelection != null) {
        // Both halves selected - treat as one full slot with 60min duration
        if (!consolidatedSlots.containsKey(slot.sId)) {
          consolidatedSlots[slot.sId!] = Slots(
            sId: slot.sId,
            time: slot.time,
            amount: slot.amount,
            businessHours: slot.businessHours,
            status: slot.status,
            availabilityStatus: slot.availabilityStatus,
            duration: 60, // Full slot duration
            bookingTime: slot.time ?? '', // Use original time for full slot
          );
        }
      } else {
        // Single half or non-30min selection
        final selectionData = leftHalfSelection ?? rightHalfSelection;
        Slots updatedSlot = Slots(
          sId: slot.sId,
          time: slot.time,
          amount: slot.amount,
          businessHours: slot.businessHours,
          status: slot.status,
          availabilityStatus: slot.availabilityStatus,
          duration: selectedDurationMinutes,
          bookingTime: selectionData?['bookingTime'] ?? slot.time ?? '',
        );
        updatedSlots.add(updatedSlot);
      }
    }
    
    // Add consolidated full slots
    updatedSlots.addAll(consolidatedSlots.values);
    
    detailsController.localMatchData.update("slot", (v) => updatedSlots);
    
    // Use direct assignment for new keys instead of update
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
  void _autoSelectTab() {
    // Don't auto-select if user has manually selected a tab
    if (isManualTabSelection.value) return;
    
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 6 && hour <= 11 && morningCount.value > 0) {
      selectedTimeOfDay.value = 0; // Morning
    } else if (hour >= 12 && hour <= 17 && noonCount.value > 0) {
      selectedTimeOfDay.value = 1; // Noon
    } else if (hour >= 18 && hour <= 23 && nightCount.value > 0) {
      selectedTimeOfDay.value = 2; // Night
    } else {
      // Fallback: pick first tab that has slots
      if (morningCount.value > 0) {
        selectedTimeOfDay.value = 0;
      } else if (noonCount.value > 0) {
        selectedTimeOfDay.value = 1;
      } else if (nightCount.value > 0) {
        selectedTimeOfDay.value = 2;
      } else {
        selectedTimeOfDay.value = 0; // default
      }
    }

    filterSlotsByTimeOfDay();
  }
  void filterSlotsByTimeOfDay() {
    final tab = selectedTimeOfDay.value;
    final courts = slots.value?.data ?? [];
    for (final court in courts) {
      final courtId = court.sId ?? '';
      final baseList = _originalSlotsCache[courtId] ?? List<Slots>.from(court.slots ?? []);
      court.slots = baseList.where((s) {
        final hour = _parseHour24(s.time);
        if (hour == null) return false;
        if (tab == 0) return hour >= 6 && hour <= 11; // Morning 6-11 am
        if (tab == 1) return hour >= 12 && hour <= 17; // Noon 12-5 pm
        return hour >= 18 && hour <= 23; // Night 6-11 pm
      }).toList();
    }
    _recalculateTimeOfDayCounts();
    slots.refresh();
  }
  void _recalculateTimeOfDayCounts() {
    morningCount.value = 0;
    noonCount.value = 0;
    nightCount.value = 0;
    _originalSlotsCache.forEach((_, list) {
      for (final s in list) {
        final hour = _parseHour24(s.time);
        if (hour == null) continue;
        if (hour >= 6 && hour <= 11) {
          morningCount.value++;
        } else if (hour >= 12 && hour <= 17) {
          noonCount.value++;
        } else if (hour >= 18 && hour <= 23) {
          nightCount.value++;
        }
      }
    });
  }
  int? _parseHour24(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;
    final t = timeStr.trim().toLowerCase();
    try {
      // Try h:mm a first
      final dt = DateFormat('h:mm a').parseStrict(t);
      return dt.hour;
    } catch (_) {
      try {
        final dt = DateFormat('h a').parseStrict(t);
        return dt.hour;
      } catch (_) {
        // Fallback manual parse: "10:30 am" or "10 am"
        final parts = t.split(' ');
        if (parts.length == 2) {
          final isPm = parts[1] == 'pm';
          final hm = parts[0].split(':');
          final h = int.tryParse(hm[0]);
          if (h == null) return null;
          var hour = h % 12;
          if (isPm) hour += 12;
          return hour;
        }
        return null;
      }
    }
  }
  void toggleSlotSelection(Slots slot, {String? courtId, String? courtName, bool? isLeftHalf}) {
    // Resolve court info
    Map<String, String>? resolvedCourtInfo;
    if (courtId != null && courtId.isNotEmpty) {
      final resolvedName = (courtName != null && courtName.isNotEmpty)
          ? courtName
          : _getCourtNameById(courtId);
      resolvedCourtInfo = {
        'courtId': courtId,
        'courtName': resolvedName ?? '',
      };
    } else {
      resolvedCourtInfo = _findCourtInfoForSlot(slot);
    }
    if (resolvedCourtInfo == null) return;

    final slotId = slot.sId ?? '';
    final resolvedCourtId = resolvedCourtInfo['courtId'] ?? '';
    final resolvedCourtName = resolvedCourtInfo['courtName'] ?? '';
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
    final selectedDurationMinutes = int.tryParse(selectedDuration.value.replaceAll(' min', '')) ?? 60;

    // Multi-date key format: "date_courtId_slotId_half" for 30min slots
    final multiDateKey = selectedDurationMinutes == 30 && isLeftHalf != null 
        ? '${dateString}_${resolvedCourtId}_${slotId}_${isLeftHalf ? 'L' : 'R'}'
        : '${dateString}_${resolvedCourtId}_$slotId';

    // Legacy key for current date compatibility
    final compositeKey = '${resolvedCourtId}_$slotId';

    if (multiDateSelections.containsKey(multiDateKey)) {
      // Remove selection group
      _removeSlotGroup(slot, resolvedCourtId, dateString);
    } else {
      // Check limits before adding
      if (!_canAddSlot()) {
        return;
      }

      // CHECK: Prevent multi-date selection
      if (multiDateSelections.isNotEmpty) {
        final firstSelectionDate = multiDateSelections.values.first['date'] as String;
        if (firstSelectionDate != dateString) {
          Get.snackbar(
            "Single Date Selection Only",
            "Please select slots from only one date. Clear current selections to choose a different date.",
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );
          return;
        }
      }

      // CHECK: Prevent same time slot selection across different courts
      final slotTime = slot.time;
      final isTimeConflict = _hasTimeConflictAcrossCourts(slotTime, resolvedCourtId, dateString);
      if (isTimeConflict) {
        SnackBarUtils.showErrorSnackBar("This time slot is already selected in another court");
        return;
      }

      // Add selection group based on duration
      _addSlotGroup(slot, resolvedCourtId, resolvedCourtName, dateString, currentDate, isLeftHalf);
    }

    // Recalculate total amount from all dates
    _recalculateTotalAmount();

    log("Selected ${multiDateSelections.length} slots for date: $dateString, Total: ₹${totalAmount.value}");
  }
  /// Check if adding a new slot would violate limits
  bool _canAddSlot() {
    final currentCount = multiDateSelections.length;
    if (currentCount >= maxSlots) {
      SnackBarUtils.showErrorSnackBar("Booking Limit Reached\nYou can select a maximum of $maxSlots slots.");
      return false;
    }

    // For open matches, we only allow single day selection, so skip the day limit check
    // since we already enforce single date selection in toggleSlotSelection
    return true;
  }

  /// Get unique dates from selections
  Set<String> _getUniqueDates() {
    final Set<String> dates = {};
    multiDateSelections.forEach((key, selection) {
      final dateString = selection['date'] as String;
      dates.add(dateString);
    });
    return dates;
  }

  void _addSlotGroup(Slots primarySlot, String courtId, String courtName, String dateString, DateTime currentDate, bool? isLeftHalf) {
    final selectedDurationMinutes = int.tryParse(selectedDuration.value.replaceAll(' min', '')) ?? 60;
    final slotsToSelect = <Slots>[];
    
    // Find all slots for this court
    final courtData = slots.value?.data?.firstWhere((court) => court.sId == courtId);
    if (courtData?.slots == null) return;
    
    final allSlots = courtData!.slots!;
    final primarySlotIndex = allSlots.indexWhere((s) => s.sId == primarySlot.sId);
    if (primarySlotIndex == -1) return;
    
    // Calculate how many slots to select based on duration
    int slotsNeeded;
    switch (selectedDurationMinutes) {
      case 30:
        slotsNeeded = 1; // Half slot (30 minutes)
        break;
      case 60:
        slotsNeeded = 1; // Full slot (60 minutes) - select only 1 slot
        break;
      case 90:
        slotsNeeded = 2; // 1.5 slots (90 minutes) - select 2 slots
        break;
      case 120:
        slotsNeeded = 2; // 2 full slots (120 minutes) - select 2 slots
        break;
      default:
        slotsNeeded = 1;
    }
    
    // For 30 and 60 min, select only the clicked slot or consecutive slots
    if (selectedDurationMinutes == 30 || selectedDurationMinutes == 60) {
      slotsToSelect.add(primarySlot);
    } else {
      // For 90 and 120 min, select consecutive slots
      for (int i = 0; i < slotsNeeded; i++) {
      final slotIndex = primarySlotIndex + i;
      if (slotIndex >= allSlots.length) {
        Get.snackbar(
          "Selection Error",
          "Not enough consecutive slots available for ${selectedDuration.value} duration.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
      
      final slotToCheck = allSlots[slotIndex];
      if (_isUnavailableSlot(slotToCheck)) {
        Get.snackbar(
          "Selection Error",
          "Some required slots are unavailable for ${selectedDuration.value} duration.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
      
        slotsToSelect.add(slotToCheck);
      }
    }
    
    // Check limits before adding
    if (multiDateSelections.length + slotsToSelect.length > maxSlots) {
      SnackBarUtils.showErrorSnackBar("Booking Limit Reached\nYou can select a maximum of $maxSlots slots.");
      return;
    }
    
    // Add all slots in the group
    for (int i = 0; i < slotsToSelect.length; i++) {
      final slotToAdd = slotsToSelect[i];
      final slotKey = selectedDurationMinutes == 30 && isLeftHalf != null 
          ? '${dateString}_${courtId}_${slotToAdd.sId}_${isLeftHalf ? 'L' : 'R'}'
          : '${dateString}_${courtId}_${slotToAdd.sId}';
      final compositeKey = '${courtId}_${slotToAdd.sId}';
      
      // Calculate booking time for 30-minute slots
      String bookingTime = slotToAdd.time ?? '';
      if (selectedDurationMinutes == 30 && isLeftHalf != null) {
        if (isLeftHalf) {
          // Left half: use original time (e.g., 3:00 PM)
          bookingTime = slotToAdd.time ?? '';
          log('Left half selected - bookingTime: $bookingTime');
        } else {
          // Right half: add 30 minutes (e.g., 3:30 PM)
          final originalTime = slotToAdd.time ?? '';
          bookingTime = _addMinutesToTime(originalTime, 30);
          log('Right half selected - original: $originalTime, calculated bookingTime: $bookingTime');
        }
      }
      
      // For 90-minute selections, adjust the pricing distribution
      int adjustedAmount = slotToAdd.amount ?? 0;
      bool? isLeftHalfFor90Min; // Track if this is a half-slot for 90min
      
      if (selectedDurationMinutes == 90) {
        if (i == 0) {
          // First slot gets 60min price (full slot)
          final price60 = _findPriceForSlotByDate(slotToAdd.time ?? '', dateString, 60);
          adjustedAmount = price60 ?? adjustedAmount;
        } else if (i == 1) {
          // Second slot gets 30min price (left half only)
          final price30 = _findPriceForSlotByDate(slotToAdd.time ?? '', dateString, 30);
          adjustedAmount = price30 ?? (adjustedAmount / 2).round();
          isLeftHalfFor90Min = true; // Mark as left half for visual representation
        }
        log('90min slot $i - adjusted price: $adjustedAmount, isLeftHalf: $isLeftHalfFor90Min');
      }
      
      multiDateSelections[slotKey] = {
        'slot': slotToAdd,
        'courtId': courtId,
        'courtName': courtName,
        'date': dateString,
        'dateTime': currentDate,
        'bookingTime': bookingTime,
        'isLeftHalf': selectedDurationMinutes == 30 ? isLeftHalf : (selectedDurationMinutes == 90 && i == 1 ? true : null),
        'adjustedAmount': adjustedAmount, // Store adjusted amount
      };
      
      if (!selectedSlots.any((s) => s.sId == slotToAdd.sId)) {
        selectedSlots.add(slotToAdd);
      }
      selectedSlotsWithCourtInfo[compositeKey] = {
        'slot': slotToAdd,
        'courtId': courtId,
        'courtName': courtName,
        'bookingTime': bookingTime,
        'adjustedAmount': adjustedAmount, // Store adjusted amount
      };
    }
  }
  
  void _removeSlotGroup(Slots primarySlot, String courtId, String dateString) {
    final selectedDurationMinutes = int.tryParse(selectedDuration.value.replaceAll(' min', '')) ?? 60;
    
    // Find all slots for this court
    final courtData = slots.value?.data?.firstWhere((court) => court.sId == courtId);
    if (courtData?.slots == null) return;
    
    final allSlots = courtData!.slots!;
    final primarySlotIndex = allSlots.indexWhere((s) => s.sId == primarySlot.sId);
    if (primarySlotIndex == -1) return;
    
    // Calculate how many slots to remove based on duration
    int slotsToRemove;
    switch (selectedDurationMinutes) {
      case 30:
        slotsToRemove = 1;
        break;
      case 60:
        slotsToRemove = 1; // Fixed: 60min should remove only 1 slot
        break;
      case 90:
        slotsToRemove = 2; // Fixed: 90min should remove 2 slots
        break;
      case 120:
        slotsToRemove = 2; // Fixed: 120min should remove 2 slots
        break;
      default:
        slotsToRemove = 1;
    }
    
    // Remove all slots in the group
    for (int i = 0; i < slotsToRemove; i++) {
      final slotIndex = primarySlotIndex + i;
      if (slotIndex >= allSlots.length) break;
      
      final slotToRemove = allSlots[slotIndex];
      final compositeKey = '${courtId}_${slotToRemove.sId}';
      
      if (selectedDurationMinutes == 30) {
        // For 30min slots, remove both left and right half keys
        final leftKey = '${dateString}_${courtId}_${slotToRemove.sId}_L';
        final rightKey = '${dateString}_${courtId}_${slotToRemove.sId}_R';
        multiDateSelections.remove(leftKey);
        multiDateSelections.remove(rightKey);
      } else {
        // For other durations, use the standard key
        final slotKey = '${dateString}_${courtId}_${slotToRemove.sId}';
        multiDateSelections.remove(slotKey);
      }
      
      selectedSlots.removeWhere((s) => s.sId == slotToRemove.sId);
      selectedSlotsWithCourtInfo.remove(compositeKey);
    }
  }
  // Check if the same time slot is already selected in a different court
  bool _hasTimeConflictAcrossCourts(String? slotTime, String currentCourtId, String dateString) {
    if (slotTime == null || slotTime.isEmpty) return false;
    
    for (final entry in multiDateSelections.entries) {
      final selection = entry.value;
      final existingDate = selection['date'] as String;
      final existingCourtId = selection['courtId'] as String;
      final existingSlot = selection['slot'] as Slots;
      
      // Check if same date, different court, and same time
      if (existingDate == dateString && 
          existingCourtId != currentCourtId && 
          existingSlot.time == slotTime) {
        return true;
      }
    }
    return false;
  }

  // Validate that all selected slots across ALL courts form one continuous time block
  bool _isConsecutiveSelectionAllowed(String courtId, String slotId, String dateString) {
    // Get all existing selections for the same date (across all courts)
    final List<Map<String, dynamic>> existingSelections = [];
    multiDateSelections.forEach((key, selection) {
      if (selection['date'] == dateString) {
        existingSelections.add(selection);
      }
    });

    // If no existing selections, allow first selection
    if (existingSelections.isEmpty) return true;

    // Get the candidate slot details
    final candidateSlot = _getSlotById(courtId, slotId);
    if (candidateSlot == null) return false;

    // Create a list of all slot times (existing + candidate)
    final List<String> allTimes = [];
    for (final selection in existingSelections) {
      final slot = selection['slot'] as Slots;
      if (slot.time != null) allTimes.add(slot.time!);
    }
    if (candidateSlot.time != null) allTimes.add(candidateSlot.time!);

    // Convert times to comparable format and sort
    final List<int> timeMinutes = [];
    for (final timeStr in allTimes) {
      final minutes = _convertTimeToMinutes(timeStr);
      if (minutes != null) timeMinutes.add(minutes);
    }
    
    if (timeMinutes.length != allTimes.length) return false; // Some times couldn't be parsed
    
    timeMinutes.sort();

    // Check if all times are consecutive (assuming 1-hour slots)
    for (int i = 1; i < timeMinutes.length; i++) {
      if (timeMinutes[i] - timeMinutes[i - 1] != 60) {
        return false; // Gap found
      }
    }
    
    return true;
  }

  // Helper method to get slot by ID from a specific court
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

  // Helper method to convert time string to minutes since midnight
  int? _convertTimeToMinutes(String timeStr) {
    try {
      final cleanTime = timeStr.trim().toLowerCase();
      
      // Try parsing with DateFormat first
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
      
      // Fallback manual parsing
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

  // Get the index of a slot within the base slot list for a court
  int _getSlotIndexInCourt(String courtId, String slotId) {
    final List<Slots> baseList = _originalSlotsCache[courtId] ?? [];
    for (int i = 0; i < baseList.length; i++) {
      if (baseList[i].sId == slotId) return i;
    }
    // As a fallback, try the currently shown (possibly time-filtered) slots list
    final data = slots.value?.data ?? [];
    final court = data.firstWhereOrNull((c) => c.sId == courtId);
    final currentList = court?.slots ?? [];
    for (int i = 0; i < currentList.length; i++) {
      if (currentList[i].sId == slotId) return i;
    }
    return -1;
  }

// Replace your existing _clearCurrentDateSelections method with this:
  void clearCurrentDateSelections() {
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

    // Remove selections for current date only
    multiDateSelections.removeWhere((key, value) => key.startsWith(dateString));

    // Rebuild legacy collections based on currently selected date
    selectedSlots.clear();
    selectedSlotsWithCourtInfo.clear();

    // Only add back slots that belong to the current date
    multiDateSelections.forEach((key, selection) {
      if (key.startsWith(dateString)) {
        final slot = selection['slot'] as Slots;
        final courtId = selection['courtId'] as String;
        final courtName = selection['courtName'] as String;
        final compositeKey = '${courtId}_${slot.sId}';

        if (!selectedSlots.any((s) => s.sId == slot.sId)) {
          selectedSlots.add(slot);
        }
        selectedSlotsWithCourtInfo[compositeKey] = {
          'slot': slot,
          'courtId': courtId,
          'courtName': courtName,
        };
      }
    });
  }

// NEW: Method to sync the legacy collections with current date selections
  void _syncLegacyCollectionsWithCurrentDate() {
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

    // Clear legacy collections
    selectedSlots.clear();
    selectedSlotsWithCourtInfo.clear();

    // Populate them with current date's selections only
    multiDateSelections.forEach((key, selection) {
      if (key.startsWith(dateString)) {
        final slot = selection['slot'] as Slots;
        final courtId = selection['courtId'] as String;
        final courtName = selection['courtName'] as String;
        final compositeKey = '${courtId}_${slot.sId}';

        if (!selectedSlots.any((s) => s.sId == slot.sId)) {
          selectedSlots.add(slot);
        }
        selectedSlotsWithCourtInfo[compositeKey] = {
          'slot': slot,
          'courtId': courtId,
          'courtName': courtName,
        };
      }
    });

    // Recalculate total for current view
    _recalculateTotalAmount();
  }

  Future<void> getAvailableCourtsById(String clubId, {bool showUnavailable = false}) async {
    log("=== DEBUG API CALL ===");
    log("Fetching courts for club: $clubId");
    log("Selected date: ${selectedDate.value}");
    log("Show unavailable: $showUnavailable");

    isLoadingCourts.value = true;

    try {
      final date = selectedDate.value ?? DateTime.now();
      final formattedDay = _getWeekday(date.weekday);
      final formattedDate = _dateFormatter.format(date);

      log("Formatted day: $formattedDay");
      log("Formatted date: $formattedDate");
      log("Club ID: $clubId");

      final result = await repository.fetchAvailableCourtsSlotWise(
        day: formattedDay,
        registerClubId: clubId,
        date: formattedDate,
      );

      // Debug: Log booking times from API
      log("=== DEBUG BOOKING TIMES ===");
      for (var court in result.data ?? []) {
        for (var slot in court.slots ?? []) {
          if (slot.bookingTime != null && slot.bookingTime!.isNotEmpty) {
            log("Slot time: '${slot.time}', bookingTime: '${slot.bookingTime}'");
            log("Normalized slot time: '${_normalizeTime(slot.time ?? '')}'");
            log("Normalized booking time: '${_normalizeTime(slot.bookingTime!)}'");
            log("Left half booked: ${isLeftHalfBooked(slot)}");
            log("Right half booked: ${isRightHalfBooked(slot)}");
            log("Status: ${slot.status}");
            log("---");
          }
        }
      }

      // Update slot prices from fetchAllSlotPrices API
      _updateSlotPrices(result, formattedDay);

      // Store ALL slots (both available and unavailable)
      _allSlotsCache.clear();
      for (var court in result.data ?? []) {
        _allSlotsCache[court.sId ?? ''] = List<Slots>.from(court.slots ?? []);
      }

      // Apply filtering based on toggle
      for (var court in result.data ?? []) {
        final base = _allSlotsCache[court.sId ?? ''] ?? [];
        if (showUnavailable) {
          // Show BOTH available and unavailable
          court.slots = List<Slots>.from(base);
        } else {
          // Show only available
          court.slots = base.where((s) => _isAvailableSlot(s)).toList();
        }
      }

      slots.value = result;

      // Build original cache from filtered slots for time-of-day filtering
      _originalSlotsCache.clear();
      final courts = slots.value?.data ?? [];
      for (final court in courts) {
        _originalSlotsCache[court.sId ?? ''] = List<Slots>.from(court.slots ?? []);
      }
      _recalculateTimeOfDayCounts();

      filterSlotsByTimeOfDay();
      _autoSelectTab();

    } catch (e, stackTrace) {
      log("Error occurred: $e");
      log("Stack trace: $stackTrace");
      slots.value = null;

      Get.snackbar(
        "Error",
        "Failed to load courts. Please try again.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingCourts.value = false;
    }
  }

  void _recalculateTotalAmount() {
    int total = 0;
    multiDateSelections.forEach((key, selection) {
      // Use adjusted amount if available, otherwise use original slot amount
      final adjustedAmount = selection['adjustedAmount'] as int?;
      if (adjustedAmount != null) {
        total += adjustedAmount;
      } else {
        final slot = selection['slot'] as Slots;
        total += slot.amount ?? 0;
      }
    });
    totalAmount.value = total;
  }

  /// Find court information for a given slot
  Map<String, String>? _findCourtInfoForSlot(Slots targetSlot) {
    final data = slots.value?.data ?? [];

    for (var courtData in data) {
      final slotsList = courtData.slots ?? [];
      final hasSlot = slotsList.any((s) => s.sId == targetSlot.sId);

      if (hasSlot) {
        return {
          'courtId': courtData.sId ?? '',
          'courtName': courtData.courtName ?? '',
        };
      }
    }
    return null;
  }

  String? _getCourtNameById(String courtId) {
    final data = slots.value?.data ?? [];
    for (var courtData in data) {
      if (courtData.sId == courtId) {
        return courtData.courtName ?? '';
      }
    }
    return null;
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
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

  // Helper: determine if a slot should be considered unavailable (past, booked, or blocked)
  bool _isUnavailableSlot(Slots slot) {
    final availability = _normalizeStatus(slot.availabilityStatus);
    final isBlocked = availability == "maintenance" ||
        availability == "weather conditions" ||
        availability == "staff unavailability";
    final isBooked = (_normalizeStatus(slot.status) == 'booked');
    final isPast = isPastAndUnavailable(slot);
    return isPast || isBlocked || isBooked;
  }

  // Helper: available when not unavailable and status is available/empty
  bool _isAvailableSlot(Slots slot) {
    final status = _normalizeStatus(slot.status);
    return !_isUnavailableSlot(slot) && (status == 'available' || status.isEmpty);
  }

  // Normalize status/availability strings to avoid case and whitespace issues
  String _normalizeStatus(String? value) {
    return (value ?? '').trim().toLowerCase();
  }

  var cartLoader = false.obs;

  void addToCart() async {
    try {
      if (cartLoader.value) return;
      cartLoader.value = true;

      if (multiDateSelections.isEmpty) {
        Get.snackbar(
          "No Slots Selected",
          "Please select at least one slot before adding to cart.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // Group by date and club
      final Map<String, Map<String, dynamic>> groupedByDate = {};

      multiDateSelections.forEach((key, selection) {
        final slot = selection['slot'] as Slots;
        final courtId = selection['courtId'] as String;
        final courtName = selection['courtName'] as String;
        final dateString = selection['date'] as String;
        final dateTime = selection['dateTime'] as DateTime;
        final clubId = argument.id!;

        // Create date-specific key
        final dateKey = '${dateString}_$clubId';

        if (!groupedByDate.containsKey(dateKey)) {
          groupedByDate[dateKey] = {
            "slot": [],
            "register_club_id": clubId,
            "date": dateString,
            "dateTime": dateTime,
          };
        }

        final slotEntry = {
          "businessHours": slot.businessHours
              ?.map((bh) => {
            "time": bh.time,
            "day": bh.day,
          })
              .toList(),
          "slotTimes": [
            {
              "time": slot.time,
              "amount": slot.amount,
              "slotId": slot.sId,
            },
            {
              "bookingDate": dateString,
            },
            {
              "courtId": courtId,
            },
            {
              "courtName": courtName,
            }
          ]
        };

        (groupedByDate[dateKey]!["slot"] as List).add(slotEntry);
      });

      // Convert to final payload format (grouped by date)
      final List<Map<String, dynamic>> cartPayload = groupedByDate.values
          .map((dateGroup) => {
        "slot": dateGroup["slot"],
        "register_club_id": dateGroup["register_club_id"],
      })
          .toList();

      log("Multi-Date Cart Payload: $cartPayload");

      await cartRepository.addCartItems(data: cartPayload).then((v) async {
        final CartController controller = Get.find<CartController>();
        await controller.getCartItems();

        Get.to(() => CartScreen(buttonType: "true"))?.then((_) async {
          // Clear all selections
          multiDateSelections.clear();
          selectedSlots.clear();
          selectedSlotsWithCourtInfo.clear();
          totalAmount.value = 0;
          await getAvailableCourtsById(argument.id!);
        });
      });
    } on DioException catch (e) {
      final dynamic data = e.response?.data;
      final serverMessage =
      (data is Map && data['message'] is String) ? data['message'] as String : null;
      final detailed = serverMessage ?? e.message ?? 'Something went wrong.';
      log("Add to cart failed (Dio): status=${e.response?.statusCode}, data=${e.response?.data}");
      Get.snackbar(
        "Error",
        detailed,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      log("Error adding to cart: $e");
      Get.snackbar(
        "Error",
        "Failed to add slots to cart. Please try again.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      cartLoader.value = false;
    }
  }

  List<dynamic> getAllCourts() {
    return slots.value?.data ?? [];
  }

  bool isSlotSelected(Slots slot, String courtId) {
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = _dateFormatter.format(currentDate);
    final selectedDurationMinutes = int.tryParse(selectedDuration.value.replaceAll(' min', '')) ?? 60;
    
    if (selectedDurationMinutes == 30) {
      // For 30min slots, check both left and right half selections
      final leftKey = '${dateString}_${courtId}_${slot.sId}_L';
      final rightKey = '${dateString}_${courtId}_${slot.sId}_R';
      return multiDateSelections.containsKey(leftKey) || multiDateSelections.containsKey(rightKey);
    } else {
      final multiDateKey = '${dateString}_${courtId}_${slot.sId}';
      return multiDateSelections.containsKey(multiDateKey);
    }
  }

  bool isPartOfSelectedGroup(Slots slot, String courtId) {
    final selectedDurationMinutes = int.tryParse(selectedDuration.value.replaceAll(' min', '')) ?? 60;
    if (selectedDurationMinutes <= 60) return false; // No group selection for 30 and 60 min
    
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = _dateFormatter.format(currentDate);
    final currentSlotKey = '${dateString}_${courtId}_${slot.sId}';
    
    // If this slot is already selected, check if it's part of a group
    if (multiDateSelections.containsKey(currentSlotKey)) {
      return true;
    }
    
    return false;
  }

  bool isSlotDisabled(Slots slot, String courtId) {
    // If slot is already selected, it's not disabled
    if (isSlotSelected(slot, courtId)) return false;
    
    // If 3 slots are already selected, disable all other slots
    return multiDateSelections.length >= 3;
  }

  int getSelectedSlotsCountForCourt(String courtId) {
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = _dateFormatter.format(currentDate);

    return multiDateSelections.keys.where((key) =>
    key.startsWith(dateString) && key.contains('_${courtId}_')
    ).length;
  }

  int getTotalAmountForCourt(String courtId) {
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = _dateFormatter.format(currentDate);

    int total = 0;
    multiDateSelections.forEach((key, selection) {
      if (key.startsWith(dateString) && key.contains('_${courtId}_')) {
        final slot = selection['slot'] as Slots;
        total += slot.amount ?? 0;
      }
    });
    return total;
  }

  // NEW: Get total selections across all dates
  int getTotalSelectionsCount() {
    return multiDateSelections.length;
  }

  // NEW: Get selections grouped by date
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

  // NEW: Clear all selections (useful for reset functionality)
  void clearAllSelections() {
    multiDateSelections.clear();
    selectedSlots.clear();
    selectedSlotsWithCourtInfo.clear();
    totalAmount.value = 0;
  }

  /// Check if left half of a 30-minute slot is booked
  bool isLeftHalfBooked(Slots slot) {
    if (slot.bookingTime == null || slot.bookingTime!.isEmpty) return false;
    
    final originalTime = slot.time ?? '';
    final bookingTime = slot.bookingTime!;
    
    // Check duration from API - if 60, whole slot is booked
    if (slot.duration == 60) return true;
    
    // If duration is 30, check booking time to determine which half
    if (slot.duration == 30) {
      // If booking time equals original time (e.g., both are "5:00 PM"), left half is booked
      return _normalizeTime(bookingTime) == _normalizeTime(originalTime);
    }
    
    // Fallback to original logic
    return _normalizeTime(bookingTime) == _normalizeTime(originalTime);
  }

  /// Check if right half of a 30-minute slot is booked
  bool isRightHalfBooked(Slots slot) {
    if (slot.bookingTime == null || slot.bookingTime!.isEmpty) return false;
    
    final originalTime = slot.time ?? '';
    final bookingTime = slot.bookingTime!;
    
    // Check duration from API - if 60, whole slot is booked
    if (slot.duration == 60) return true;
    
    // If duration is 30, check booking time to determine which half
    if (slot.duration == 30) {
      // If booking time is 30 minutes after original time (e.g., "5:30 PM" vs "5:00 PM"), right half is booked
      final expectedRightTime = _addMinutesToTime(originalTime, 30);
      return _normalizeTime(bookingTime) == _normalizeTime(expectedRightTime);
    }
    
    // Fallback to original logic
    final expectedRightTime = _addMinutesToTime(originalTime, 30);
    return _normalizeTime(bookingTime) == _normalizeTime(expectedRightTime);
  }

  /// Check if both halves of a 30-minute slot are selected
  bool isBothHalvesSelected(Slots slot, String courtId) {
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = _dateFormatter.format(currentDate);
    final leftKey = '${dateString}_${courtId}_${slot.sId}_L';
    final rightKey = '${dateString}_${courtId}_${slot.sId}_R';
    return multiDateSelections.containsKey(leftKey) && multiDateSelections.containsKey(rightKey);
  }

  /// Normalize time format for comparison (convert to consistent format)
  String _normalizeTime(String timeString) {
    try {
      // Try parsing and reformatting to ensure consistent format
      final upperTime = timeString.trim().toUpperCase();
      final time = DateFormat('h a').parseStrict(upperTime);
      return DateFormat('h:mm a').format(time);
    } catch (_) {
      try {
        final time = DateFormat('h:mm a').parseStrict(timeString.trim());
        return DateFormat('h:mm a').format(time);
      } catch (_) {
        return timeString.trim().toUpperCase();
      }
    }
  }

  /// Add minutes to a time string (e.g., "3:00 PM" + 30 minutes = "3:30 PM")
  String _addMinutesToTime(String timeString, int minutesToAdd) {
    log('_addMinutesToTime: input="$timeString", adding $minutesToAdd minutes');
    try {
      final cleanTime = timeString.trim();
      DateTime? parsedTime;
      
      // Try different parsing formats
      final formats = ['h:mm a', 'h a', 'H:mm', 'HH:mm'];
      
      for (final format in formats) {
        try {
          parsedTime = DateFormat(format).parseStrict(cleanTime);
          log('_addMinutesToTime: successfully parsed with format "$format"');
          break;
        } catch (_) {
          // Try with case-insensitive parsing
          try {
            parsedTime = DateFormat(format).parseStrict(cleanTime.toUpperCase());
            log('_addMinutesToTime: successfully parsed with uppercase format "$format"');
            break;
          } catch (_) {
            continue;
          }
        }
      }
      
      if (parsedTime != null) {
        final newTime = parsedTime.add(Duration(minutes: minutesToAdd));
        final result = DateFormat('h:mm a').format(newTime);
        log('_addMinutesToTime: final result="$result"');
        return result;
      }
      
      log('_addMinutesToTime: all parsing failed, returning original');
      return timeString;
    } catch (e) {
      log('_addMinutesToTime: error occurred: $e, returning original');
      return timeString;
    }
  }

  // Variables to store fetched slot prices
  var allSlotPricesResponse = Rxn<GetAllSlotPricesOfCourtModel>();
  var isSlotPricesLoading = false.obs;
  final Map<String, Map<String, int>> slotPricesData = {}; // day -> {duration -> price}
  final Map<String, Map<String, int>> originalSlotPricesData = {}; // Track original prices
  
  ///Fetch All Slot Prices------------------------------------------------------
  Future<void> fetchAllSlotPrices() async {
    try {
      isSlotPricesLoading.value = true;

      final result = await repository.getAllSlotPricesOfCourt(
        registerClubId: argument.id!,
        duration: '', // Get all durations
        day: '', // Get all days
        timePeriod: '', // Get all time periods
      );

      allSlotPricesResponse.value = result;

      // Clear existing data
      slotPricesData.clear();
      originalSlotPricesData.clear();

      // Parse and store the data
      if (result.data?.isNotEmpty ?? false) {
        for (final item in result.data!) {
          final day = item.day;
          final duration = item.duration?.toString();
          final price = item.price ?? 0;

          if (day != null && duration != null) {
            slotPricesData[day] ??= {};
            slotPricesData[day]![duration] = price;

            // Store original prices
            originalSlotPricesData[day] ??= {};
            originalSlotPricesData[day]![duration] = price;
          }
        }
      }

      CustomLogger.logMessage(
        msg: "Fetched slot prices for all periods: $slotPricesData",
        level: LogLevel.info,
      );

    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Error fetching slot prices: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
    } finally {
      isSlotPricesLoading.value = false;
    }
  }

  /// Update slot prices from fetchAllSlotPrices API
  void _updateSlotPrices(GetAllActiveCourtsForSlotWiseModel result, String day) {
    if (result.data == null) return;
    
    final selectedDurationMinutes = int.tryParse(selectedDuration.value.replaceAll(' min', '')) ?? 60;
    
    for (var court in result.data!) {
      if (court.slots == null) continue;
      
      for (var slot in court.slots!) {
        final slotTime = slot.time;
        if (slotTime == null) continue;
        
        int? slotPrice;
        
        if (selectedDurationMinutes == 90) {
          // For 90min: get 60min price + 30min price
          final price60 = _findPriceForSlot(slotTime, day, 60);
          final price30 = _findPriceForSlot(slotTime, day, 30);
          if (price60 != null && price30 != null) {
            slotPrice = price60 + price30;
          }
        } else {
          // For other durations, use the duration price directly
          final duration = selectedDurationMinutes == 120 ? 60 : selectedDurationMinutes;
          slotPrice = _findPriceForSlot(slotTime, day, duration);
        }
        
        if (slotPrice != null) {
          slot.amount = slotPrice;
        }
      }
    }
  }
  
  /// Find price for a specific slot time from fetchAllSlotPrices data
  int? _findPriceForSlot(String slotTime, String day, int duration) {
    final slotPrices = allSlotPricesResponse.value?.data;
    if (slotPrices == null) return null;
    
    // Parse slot time to 24-hour format
    final slotHour = _parseHour24(slotTime);
    if (slotHour == null) return null;
    
    // Find matching price entry
    for (final priceEntry in slotPrices) {
      if (priceEntry.day != day || priceEntry.duration != duration) continue;
      
      final slotTimeRange = priceEntry.slotTime;
      if (slotTimeRange == null) continue;
      
      // Check if slot time falls within the price range
      if (_isTimeInRange(slotHour, slotTimeRange)) {
        return priceEntry.price;
      }
    }
    
    return null;
  }
  
  /// Find price by date string (converts date string to day name)
  int? _findPriceForSlotByDate(String slotTime, String dateString, int duration) {
    try {
      final date = DateTime.parse(dateString);
      final dayName = _getWeekday(date.weekday);
      return _findPriceForSlot(slotTime, dayName, duration);
    } catch (e) {
      return null;
    }
  }
  
  /// Check if a time falls within a time range (e.g., "6:00 AM - 11:00 AM")
  bool _isTimeInRange(int slotHour, String timeRange) {
    try {
      final parts = timeRange.split(' - ');
      if (parts.length != 2) return false;
      
      final startHour = _parseHour24(parts[0].trim());
      final endHour = _parseHour24(parts[1].trim());
      
      if (startHour == null || endHour == null) return false;
      
      // Handle cases where end time is inclusive (e.g., 6 AM - 11 AM includes 11 AM)
      return slotHour >= startHour && slotHour <= endHour;
    } catch (e) {
      return false;
    }
  }

  /// Helper methods for left/right half selection
  bool isLeftHalfSelected(Slots slot, String courtId) {
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = _dateFormatter.format(currentDate);
    final leftKey = '${dateString}_${courtId}_${slot.sId}_L';
    return multiDateSelections.containsKey(leftKey);
  }

  bool isRightHalfSelected(Slots slot, String courtId) {
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = _dateFormatter.format(currentDate);
    final rightKey = '${dateString}_${courtId}_${slot.sId}_R';
    return multiDateSelections.containsKey(rightKey);
  }

  /// Check if this slot is the second slot in a 90-minute selection (should show left half only)
  bool isSecondSlotIn90MinSelection(Slots slot, String courtId) {
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = _dateFormatter.format(currentDate);
    final slotKey = '${dateString}_${courtId}_${slot.sId}';
    
    final selection = multiDateSelections[slotKey];
    if (selection == null) return false;
    
    // Check if this selection is marked as left half for 90min duration
    final isLeftHalf = selection['isLeftHalf'] as bool?;
    return isLeftHalf == true && selectedDuration.value == '90 min';
  }
}
import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:padel_mobile/presentations/booking/details_page/details_page_controller.dart';

import '../../../../configs/routes/routes_name.dart';
import '../../../../data/request_models/home_models/get_available_court.dart';
import '../../../../data/request_models/home_models/get_club_name_model.dart';
import '../../../../repositories/cart/cart_repository.dart';
import '../../../../repositories/home_repository/home_repository.dart';
import '../../../cart/cart_controller.dart';
import '../../../cart/cart_screen.dart';

class CreateOpenMatchesController extends GetxController {
  final selectedDate = Rxn<DateTime>();
  Courts argument = Courts();
  RxBool showUnavailableSlots = false.obs;
  RxInt currentPage = 0.obs;
  var selectedTimeOfDay = 0.obs; // 0 = Morning, 1 = Noon, 2 = Night

  var morningCount = 0.obs;
  var noonCount = 0.obs;
  var nightCount = 0.obs;

  // Cache base slot lists (after unavailable/available toggle applied)
  final Map<String, List<Slots>> _originalSlotsCache = {};

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
  DetailsController detailsController=Get.put(DetailsController());
  @override
  void onInit() {
    super.onInit();
    argument = Get.arguments['id'];
    selectedDate.value = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAvailableCourtsById(argument.id!);
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



 void onNext(){
   log("Slots -> $selectedSlots");
   detailsController.localMatchData.update("clubName", (value) => slots.value!.data![0].clubName??"");
   detailsController.localMatchData.update("clubId", (v)=>slots.value!.data![0].registerClubId!.sId??"");
   detailsController.localMatchData.update("matchDate", (v)=>selectedDate.value??"");
   detailsController.localMatchData.update("matchTime", (v)=>selectedSlots.value.first.time??"");
   detailsController.localMatchData.update("price", (v)=>totalAmount.toString()??"");

   detailsController.localMatchData.update("courtType", (v)=>slots.value!.data![0].registerClubId!.courtType??"");
   detailsController.localMatchData.update("slot", (v)=>selectedSlots.value);
   detailsController.localMatchData.update("courtName", (v)=>slots.value!.data![0].courtName??"");
   // detailsController.localMatchData.update("courtType", (v)=>slots.value!.data![0].registerClubId!.courtType??"");
   Get.toNamed(RoutesName.createQuestions);
 }
  void _autoSelectTab() {
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
  // Future<void> getAvailableCourtsById(String clubId, {bool showUnavailable = false}) async {
  //   log("=== DEBUG API CALL ===");
  //   log("Fetching courts for club: $clubId");
  //   log("Selected date: ${selectedDate.value}");
  //   log("Show unavailable: $showUnavailable");
  //
  //   isLoadingCourts.value = true;
  //
  //   // Clear current date selections only, keep other dates
  //   _clearCurrentDateSelections();
  //
  //   try {
  //     final date = selectedDate.value ?? DateTime.now();
  //     final formattedDay = _getWeekday(date.weekday);
  //
  //     log("Formatted day: $formattedDay");
  //     log("Club ID: $clubId");
  //
  //     final result = await repository.fetchAvailableCourtsSlotWise(
  //       day: formattedDay,
  //       registerClubId: clubId,
  //       date: selectedDate.value.toString()
  //     );
  //
  //     if (result != null) {
  //       // Apply filtering based on toggle first
  //       for (var court in result.data ?? []) {
  //         final base = court.slots ?? [];
  //         if (showUnavailable) {
  //           court.slots = base.where((s) => _isUnavailableSlot(s)).toList();
  //         } else {
  //           court.slots = base.where((s) => _isAvailableSlot(s)).toList();
  //         }
  //       }
  //     }
  //
  //     slots.value = result;
  //     // Build base cache and counts, then apply current time-of-day filter
  //     _originalSlotsCache.clear();
  //     final courts = slots.value?.data ?? [];
  //     for (final court in courts) {
  //       _originalSlotsCache[court.sId ?? ''] = List<Slots>.from(court.slots ?? []);
  //     }
  //     _recalculateTimeOfDayCounts();
  //     filterSlotsByTimeOfDay();
  //     _autoSelectTab();
  //     slots.refresh();
  //
  //   } catch (e, stackTrace) {
  //     log("Error occurred: $e");
  //     log("Stack trace: $stackTrace");
  //     slots.value = null;
  //   } finally {
  //     isLoadingCourts.value = false;
  //   }
  // }
  void toggleSlotSelection(Slots slot, {String? courtId, String? courtName}) {
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

    // Multi-date key format: "date_courtId_slotId"
    final multiDateKey = '${dateString}_${resolvedCourtId}_$slotId';

    // Legacy key for current date compatibility
    final compositeKey = '${resolvedCourtId}_$slotId';

    if (multiDateSelections.containsKey(multiDateKey)) {
      // Remove selection
      multiDateSelections.remove(multiDateKey);
      selectedSlots.removeWhere((s) => s.sId == slotId);
      selectedSlotsWithCourtInfo.remove(compositeKey);
    } else {
      // CHECK: Prevent multi-date selection
      // If there are existing selections, check if they're from a different date
      if (multiDateSelections.isNotEmpty) {
        // Get the first existing selection's date
        final firstSelectionDate = multiDateSelections.values.first['date'] as String;

        // If trying to select from a different date, show error and return
        if (firstSelectionDate != dateString) {
          Get.snackbar(
            "Single Date Selection Only",
            "Please select slots from only one date. Clear current selections to choose a different date.",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );
          return;
        }
      }

      // Enforce consecutiveness for selections within the same date and court
      final isAllowed = _isConsecutiveSelectionAllowed(
        resolvedCourtId,
        slotId,
        dateString,
      );
      if (!isAllowed) {
        Get.snackbar(
          "Please Select Consecutive Slots",
          "",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // Add selection
      multiDateSelections[multiDateKey] = {
        'slot': slot,
        'courtId': resolvedCourtId,
        'courtName': resolvedCourtName,
        'date': dateString,
        'dateTime': currentDate,
      };

      // Maintain backward compatibility
      if (!selectedSlots.any((s) => s.sId == slotId)) {
        selectedSlots.add(slot);
      }
      selectedSlotsWithCourtInfo[compositeKey] = {
        'slot': slot,
        'courtId': resolvedCourtId,
        'courtName': resolvedCourtName,
      };
    }

    // Recalculate total amount from all dates
    _recalculateTotalAmount();

    log("Selected ${multiDateSelections.length} slots for date: $dateString, Total: ₹${totalAmount.value}");
  }
  // Validate that with the candidate slot included, all selected slots
  // for a given (date, court) form a contiguous block in the court's
  // base slot list (post availability filtering but pre time-of-day filter).
  bool _isConsecutiveSelectionAllowed(String courtId, String slotId, String dateString) {
    // Gather existing selections for same date and court
    final List<String> existingSlotIds = [];
    multiDateSelections.forEach((key, selection) {
      final sameDate = selection['date'] == dateString;
      final sameCourt = selection['courtId'] == courtId;
      if (sameDate && sameCourt) {
        final Slots s = selection['slot'] as Slots;
        if (s.sId != null) existingSlotIds.add(s.sId!);
      }
    });

    // If none selected yet for this court/date, always allow
    if (existingSlotIds.isEmpty) return true;

    // Build index list from the base cache
    final List<int> indices = [];
    for (final id in existingSlotIds) {
      final idx = _getSlotIndexInCourt(courtId, id);
      if (idx == -1) {
        // If we cannot resolve index, fail open (allow) to avoid blocking due to data inconsistencies
        return true;
      }
      indices.add(idx);
    }
    // Add candidate index
    final candidateIdx = _getSlotIndexInCourt(courtId, slotId);
    if (candidateIdx == -1) return true; // fail open

    indices.add(candidateIdx);
    indices.sort();

    // Check contiguity: no gaps between sorted indices
    for (int i = 1; i < indices.length; i++) {
      if (indices[i] != indices[i - 1] + 1) {
        return false;
      }
    }
    return true;
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
  void _clearCurrentDateSelections() {
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

// Updated getAvailableCourtsById - doesn't clear selections
  Future<void> getAvailableCourtsById(String clubId, {bool showUnavailable = false}) async {
    log("=== DEBUG API CALL ===");
    log("Fetching courts for club: $clubId");
    log("Selected date: ${selectedDate.value}");
    log("Show unavailable: $showUnavailable");

    isLoadingCourts.value = true;

    // Sync legacy collections with current date instead of clearing
    _syncLegacyCollectionsWithCurrentDate();

    try {
      final date = selectedDate.value ?? DateTime.now();
      final formattedDay = _getWeekday(date.weekday);

      log("Formatted day: $formattedDay");
      log("Club ID: $clubId");

      final result = await repository.fetchAvailableCourtsSlotWise(
          day: formattedDay,
          registerClubId: clubId,
          date: selectedDate.value.toString()
      );

      if (result != null) {
        // Apply filtering based on toggle first
        for (var court in result.data ?? []) {
          final base = court.slots ?? [];
          if (showUnavailable) {
            court.slots = base.where((s) => _isUnavailableSlot(s)).toList();
          } else {
            court.slots = base.where((s) => _isAvailableSlot(s)).toList();
          }
        }
      }

      slots.value = result;

      // Build base cache and counts, then apply current time-of-day filter
      _originalSlotsCache.clear();
      final courts = slots.value?.data ?? [];
      for (final court in courts) {
        _originalSlotsCache[court.sId ?? ''] = List<Slots>.from(court.slots ?? []);
      }
      _recalculateTimeOfDayCounts();
      filterSlotsByTimeOfDay();
      _autoSelectTab();
      slots.refresh();

    } catch (e, stackTrace) {
      log("Error occurred: $e");
      log("Stack trace: $stackTrace");
      slots.value = null;
    } finally {
      isLoadingCourts.value = false;
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
    final status = slot.status?.toLowerCase() ?? '';
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
    final availability = slot.availabilityStatus?.toLowerCase();
    final isBlocked = availability == "maintenance" ||
        availability == "weather conditions" ||
        availability == "staff unavailability";
    final isBooked = (slot.status?.toLowerCase() == 'booked');
    final isPast = isPastAndUnavailable(slot);
    return isPast || isBlocked || isBooked;
  }

  // Helper: available when not unavailable and status is available/empty
  bool _isAvailableSlot(Slots slot) {
    final status = slot.status?.toLowerCase() ?? '';
    return !_isUnavailableSlot(slot) && (status == 'available' || status.isEmpty);
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
    final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
    final multiDateKey = '${dateString}_${courtId}_${slot.sId}';

    return multiDateSelections.containsKey(multiDateKey);
  }

  int getSelectedSlotsCountForCourt(String courtId) {
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

    return multiDateSelections.keys.where((key) =>
    key.startsWith(dateString) && key.contains('_${courtId}_')
    ).length;
  }

  int getTotalAmountForCourt(String courtId) {
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

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
}
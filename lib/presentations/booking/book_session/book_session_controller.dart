import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import '../../../data/request_models/home_models/get_available_court.dart';
import '../../../data/request_models/home_models/get_club_name_model.dart';
import '../../../repositories/cart/cart_repository.dart';
import '../../../repositories/home_repository/home_repository.dart';
import '../../cart/cart_controller.dart';

class BookSessionController extends GetxController {
  final selectedDate = Rxn<DateTime>();
  Courts argument = Courts();
  RxBool showUnavailableSlots = false.obs;

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

  @override
  void onInit() {
    super.onInit();
    argument = Get.arguments['data'];
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
    super.onClose();
  }

  Future<void> getAvailableCourtsById(String clubId) async {
    log("=== DEBUG API CALL ===");
    log("Fetching courts for club: $clubId");
    log("Selected date: ${selectedDate.value}");

    isLoadingCourts.value = true;

    // Clear current date selections only, keep other dates
    _clearCurrentDateSelections();

    try {
      final date = selectedDate.value ?? DateTime.now();
      final formattedDay = _getWeekday(date.weekday);

      log("Formatted day: $formattedDay");
      log("Club ID: $clubId");

      final result = await repository.fetchAvailableCourtsSlotWise(
        day: formattedDay,
        registerClubId: clubId,
      );

      slots.value = result;
      slots.refresh();

    } catch (e, stackTrace) {
      log("Error occurred: $e");
      log("Stack trace: $stackTrace");
      slots.value = null;
    } finally {
      isLoadingCourts.value = false;
    }
  }

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

    log("Selected ${multiDateSelections.length} slots across multiple dates, Total: ₹${totalAmount.value}");
  }

  void _clearCurrentDateSelections() {
    final currentDate = selectedDate.value ?? DateTime.now();
    final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

    // Remove selections for current date only
    multiDateSelections.removeWhere((key, value) => key.startsWith(dateString));

    // Clear legacy collections (they represent current date only)
    selectedSlots.clear();
    selectedSlotsWithCourtInfo.clear();
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
    if (slot.status == "booked") return true;
    if (slot.status != "available") return true;

    final now = DateTime.now();
    final selected = selectedDate.value ?? now;

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
      return true;
    }

    return false;
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
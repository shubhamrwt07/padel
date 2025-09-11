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

  RxList<Slots> selectedSlots = <Slots>[].obs;
  RxInt totalAmount = 0.obs;
  final HomeRepository repository = HomeRepository();
  Rx<GetAllActiveCourtsForSlotWiseModel?> slots = Rx<GetAllActiveCourtsForSlotWiseModel?>(null);
  RxBool isLoadingCourts = false.obs;
  CartRepository cartRepository = CartRepository();

  // Track selected slots with their court info
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
    totalAmount.value = 0;
    super.onClose();
  }

  Future<void> getAvailableCourtsById(String clubId) async {
    log("=== DEBUG API CALL ===");
    log("Fetching courts for club: $clubId");
    log("Selected date: ${selectedDate.value}");

    isLoadingCourts.value = true;
    selectedSlots.clear();
    selectedSlotsWithCourtInfo.clear();
    totalAmount.value = 0;

    try {
      final date = selectedDate.value ?? DateTime.now();
      final formattedDay = _getWeekday(date.weekday);

      log("Formatted day: $formattedDay");
      log("Club ID: $clubId");
      log("About to call repository.fetchAvailableCourtsSlotWise...");

      final result = await repository.fetchAvailableCourtsSlotWise(
        day: formattedDay,
        registerClubId: clubId,
      );

      log("API Result received: $result");
      log("Result type: ${result.runtimeType}");

      log("Result data: ${result.data}");
      log("Result data length: ${result.data?.length}");

      slots.value = result;
      log("slots.value set to: ${slots.value}");

      // Force UI refresh
      slots.refresh();
      log("slots refreshed");

    } catch (e, stackTrace) {
      log("Error occurred: $e");
      log("Stack trace: $stackTrace");

      // Set slots to null on error
      slots.value = null;
    } finally {
      isLoadingCourts.value = false;
      log("isLoadingCourts set to false");
      log("Final slots.value: ${slots.value}");
    }
  }
  void toggleSlotSelection(Slots slot, {String? courtId, String? courtName}) {
    // Resolve court info for this specific slot to build a unique key per court+slot
    Map<String, String>? resolvedCourtInfo;
    if (courtId != null && courtId.isNotEmpty) {
      // If courtName is empty, resolve it from loaded courts by courtId
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
    if (resolvedCourtInfo == null) {
      return;
    }

    final slotId = slot.sId ?? '';
    final resolvedCourtId = resolvedCourtInfo['courtId'] ?? '';
    final resolvedCourtName = resolvedCourtInfo['courtName'] ?? '';
    final compositeKey = '${resolvedCourtId}_$slotId';

    if (selectedSlotsWithCourtInfo.containsKey(compositeKey)) {
      // Remove only this exact slot instance
      selectedSlots.remove(slot);
      selectedSlotsWithCourtInfo.remove(compositeKey);
    } else {
      // Add slot with its court context
      selectedSlots.add(slot);
      selectedSlotsWithCourtInfo[compositeKey] = {
        'slot': slot,
        'courtId': resolvedCourtId,
        'courtName': resolvedCourtName,
      };
    }

    // Recalculate total amount
    totalAmount.value = selectedSlots.fold(
      0,
          (sum, s) => sum + (s.amount ?? 0),
    );

    log("Selected ${selectedSlots.length} slots, Total: ₹${totalAmount.value}");
  }

  /// Find court information for a given slot
  Map<String, String>? _findCourtInfoForSlot(Slots targetSlot) {
    final data = slots.value?.data ?? [];

    for (var courtData in data) {
      final slotsList = courtData.slots ?? [];

      // Check if this slot belongs to this court
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

  /// Resolve court name by its id from the currently loaded slots data
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
  bool isPastAndUnavailable(Slots slot) {
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

  var cartLoader = false.obs;

  void addToCart() async {
    try {
      if (cartLoader.value) return;
      cartLoader.value = true;

      if (selectedSlots.isEmpty) {
        Get.snackbar(
          "No Slots Selected",
          "Please select at least one slot before adding to cart.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final selectedDateStr =
          "${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}";

      final Map<String, dynamic> groupedPayload = {};

      selectedSlotsWithCourtInfo.forEach((compositeKey, slotInfo) {
        final courtId = slotInfo['courtId'] as String;
        final courtName = slotInfo['courtName'] as String;
        final slot = slotInfo['slot'] as Slots;

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
              "bookingDate": selectedDateStr,
            },
            {
              "courtId": courtId,
            },
            {
              "courtName": courtName,
            }
          ]
        };

        // Group by register_club_id
        final key = argument.id!;
        if (!groupedPayload.containsKey(key)) {
          groupedPayload[key] = {
            "slot": [],
            "register_club_id": key,
          };
        }

        (groupedPayload[key]["slot"] as List).add(slotEntry);
      });

      final List<Map<String, dynamic>> cartPayload =
      groupedPayload.values.cast<Map<String, dynamic>>().toList();



      log("Cart Data Payload: $cartPayload");

      await cartRepository.addCartItems(data: cartPayload).then((v) async {
        final CartController controller = Get.find<CartController>();
        await controller.getCartItems();

        Get.to(() => CartScreen(buttonType: "true"))?.then((_) async {
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

  /// Get all courts data
  List<dynamic> getAllCourts() {
    return slots.value?.data ?? [];
  }


  /// Check if a slot is selected
  bool isSlotSelected(Slots slot) {
    return selectedSlots.any((s) => s.sId == slot.sId);
  }

  /// Get selected slots count for a specific court
  int getSelectedSlotsCountForCourt(String courtId) {
    int count = 0;
    selectedSlotsWithCourtInfo.forEach((slotId, slotInfo) {
      if (slotInfo['courtId'] == courtId) {
        count++;
      }
    });
    return count;
  }

  /// Get total amount for a specific court
  int getTotalAmountForCourt(String courtId) {
    int total = 0;
    selectedSlotsWithCourtInfo.forEach((slotId, slotInfo) {
      if (slotInfo['courtId'] == courtId) {
        final slot = slotInfo['slot'] as Slots;
        total += slot.amount ?? 0;
      }
    });
    return total;
  }
}
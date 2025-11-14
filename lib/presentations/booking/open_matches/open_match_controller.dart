import 'package:intl/intl.dart';
import '../../../data/request_models/home_models/get_club_name_model.dart';
import '../../../data/response_models/openmatch_model/open_match_model.dart';
import '../../../presentations/booking/widgets/booking_exports.dart';

class OpenMatchesController extends GetxController {
  Rx<bool> viewUnavailableSlots = false.obs;
  RxList<String> selectedSlots = <String>[].obs;
  RxString selectedTimeFilter = 'morning'.obs; // New: for tab selection

  String? selectedTime;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxBool isLoading = false.obs;
  Rx<OpenMatchModel?> createdMatch = Rx<OpenMatchModel?>(null);
  Rx<AllOpenMatches?> matchesBySelection = Rx<AllOpenMatches?>(null);
  RxString errorMessage = ''.obs;

  final List<String> timeSlots = [
    "6:00 am",
    "7:00 am",
    "8:00 am",
    "9:00 am",
    "10:00 am",
    "11:00 am",
    "12:00 pm",
    "1:00 pm",
    "2:00 pm",
    "3:00 pm",
    "4:00 pm",
    "5:00 pm",
    "6:00 pm",
    "7:00 pm",
    "8:00 pm",
    "9:00 pm",
    "10:00 pm",
    "11:00 pm",
  ];

  String getDay(String? ymd) {
    if (ymd == null || ymd.isEmpty) return '';
    try {
      final parsed = DateFormat('yyyy-MM-dd').parse(ymd);
      return DateFormat('EEEE').format(parsed);
    } catch (_) {
      return ymd;
    }
  }

  String getDate(String? ymd) {
    if (ymd == null || ymd.isEmpty) return '';
    try {
      final parsed = DateFormat('yyyy-MM-dd').parse(ymd);
      return DateFormat('dd MMMM').format(parsed);
    } catch (_) {
      return ymd;
    }
  }

  Courts argument = Courts();
  Rx<DateTime> focusedDate = DateTime.now().obs; // Add this new line

  @override
  void onInit() {
    super.onInit();
    focusedDate.value = selectedDate.value; // Add this line
    argument = Get.arguments["data"];
    if (timeSlots.isNotEmpty) {
      final firstAvail = firstAvailableSlot();
      if (firstAvail != null) {
        selectedSlots
          ..clear()
          ..add(firstAvail);
        selectedTime = firstAvail;
      } else {
        selectedSlots.clear();
        selectedTime = null;
      }
      fetchMatchesForSelection();
    }
  }

  /// Get time period (morning, noon, night) for a given time slot
  String getTimePeriod(String timeSlot) {
    try {
      final cleaned = timeSlot.replaceAll(' ', '').toUpperCase();
      DateTime? parsed;

      try {
        parsed = DateFormat('h:mma').parse(cleaned);
      } catch (_) {
        try {
          parsed = DateFormat('hha').parse(cleaned);
        } catch (_) {
          try {
            parsed = DateFormat('ha').parse(cleaned);
          } catch (_) {
            return 'morning'; // default fallback
          }
        }
      }

      final hour = parsed.hour;

      if (hour >= 6 && hour < 12) {
        return 'morning'; // 6 AM - 11:59 AM
      } else if (hour >= 12 && hour < 18) {
        return 'noon'; // 12 PM - 5:59 PM
      } else {
        return 'night'; // 6 PM - 5:59 AM
      }
    } catch (_) {
      return 'morning';
    }
  }

  /// Filter slots by selected time period
  List<String> filterSlotsByPeriod(List<String> slots) {
    final filter = selectedTimeFilter.value;
    return slots.where((slot) => getTimePeriod(slot) == filter).toList();
  }

  /// Filtered available slots based on tab selection
  List<String> get filteredAvailableSlots {
    return filterSlotsByPeriod(availableSlots);
  }

  /// Filtered unavailable slots based on tab selection
  List<String> get filteredUnavailableSlots {
    return filterSlotsByPeriod(unavailableSlots);
  }

  /// Function to create match
  Future<void> createOpenMatch() async {
    try {
      isLoading.value = true;

      if (selectedTime == null) {
        Get.snackbar("Error", "Please select a time slot");
        return;
      }

      String formattedDate = DateFormat("yyyy-MM-dd").format(selectedDate.value);

      final data = {
        "matchDate": formattedDate,
        "matchTime": selectedTime,
        "slots": selectedSlots,
      };

      final repo = OpenMatchRepository();
      final response = await repo.createMatch(data: data);

      createdMatch.value = response;

      Get.snackbar("Success", "Match created successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch matches for selected date and first chosen time slot
  Future<void> fetchMatchesForSelection() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      _ensureValidSelection();
      if (selectedTime == null) {
        matchesBySelection.value = null;
        return;
      }
      final formattedDate = DateFormat("yyyy-MM-dd").format(selectedDate.value);

      final formattedTime = _formatTimeForApi(selectedTime!);

      final repo = OpenMatchRepository();
      final response = await repo.getMatchesByDateTime(
        matchDate: formattedDate,
        matchTime: formattedTime,
        cubId: argument.id ?? "",
      );
      matchesBySelection.value = response;
    } catch (e) {
      errorMessage.value = e.toString();
      CustomLogger.logMessage(msg: "Error -> ${errorMessage.value}", level: LogLevel.error);
    } finally {
      isLoading.value = false;
    }
  }

  String _formatTimeForApi(String raw) {
    final cleaned = raw.replaceAll(' ', '').toUpperCase();
    DateTime? parsed;
    try {
      parsed = DateFormat('h:mma').parse(cleaned);
    } catch (_) {
      try {
        parsed = DateFormat('hha').parse(cleaned);
      } catch (_) {
        try {
          parsed = DateFormat('ha').parse(cleaned);
        } catch (_) {
          parsed = null;
        }
      }
    }
    if (parsed == null) {
      return raw;
    }
    return DateFormat('h a').format(parsed).toLowerCase();
  }

  bool isPastTime(String slotLabel) {
    try {
      final targetDate = selectedDate.value;
      final now = DateTime.now();

      if (DateTime(targetDate.year, targetDate.month, targetDate.day)
          .isAfter(DateTime(now.year, now.month, now.day))) {
        return false;
      }

      if (DateTime(targetDate.year, targetDate.month, targetDate.day)
          .isBefore(DateTime(now.year, now.month, now.day))) {
        return true;
      }

      final cleaned = slotLabel.replaceAll(' ', '').toUpperCase();
      final parsed = DateFormat('ha').parse(cleaned);
      final slotDateTime = DateTime(targetDate.year, targetDate.month, targetDate.day, parsed.hour, 0);
      return slotDateTime.isBefore(now);
    } catch (_) {
      return false;
    }
  }

  String? firstAvailableSlot() {
    for (final t in timeSlots) {
      if (!isPastTime(t)) return t;
    }
    return null;
  }

  List<String> get availableSlots => timeSlots.where((t) => !isPastTime(t)).toList();
  List<String> get unavailableSlots => timeSlots.where((t) => isPastTime(t)).toList();

  void _ensureValidSelection() {
    if (selectedTime == null || isPastTime(selectedTime!)) {
      final nextSlot = firstAvailableSlot();
      if (nextSlot != null) {
        selectedTime = nextSlot;
        selectedSlots
          ..clear()
          ..add(nextSlot);
      } else {
        selectedSlots.clear();
        selectedTime = null;
      }
    }
  }
}
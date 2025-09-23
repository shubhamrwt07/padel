import 'package:intl/intl.dart';
import '../../../data/request_models/home_models/get_club_name_model.dart';
import '../../../data/response_models/openmatch_model/open_match_model.dart';
import '../../../presentations/booking/widgets/booking_exports.dart';
class OpenMatchesController extends GetxController {
  Rx<bool> viewUnavailableSlots = false.obs;
  RxList<String> selectedSlots = <String>[].obs;

  String? selectedTime;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxBool isLoading = false.obs;
  Rx<OpenMatchModel?> createdMatch = Rx<OpenMatchModel?>(null);
  Rx<AllOpenMatches?> matchesBySelection = Rx<AllOpenMatches?>(null);
  RxString errorMessage = ''.obs;

  final List<String> timeSlots = [
    "8 am",
    "9 am",
    "10 am",
    "11 am",
    "12 am",
    "1 pm",
    "2 pm",
    "3 pm",
    "4 pm",
    "5 pm",
    "6 pm",
    "7 pm",
    "8 pm",
    "9 pm",
    "10 pm",
    "11 pm",
  ];

  String getDay(String? ymd) {
    if (ymd == null || ymd.isEmpty) return '';
    try {
      final parsed = DateFormat('yyyy-MM-dd').parse(ymd);
      return DateFormat('EEEE').format(parsed); // e.g. Monday
    } catch (_) {
      return ymd;
    }
  }

  String getDate(String? ymd) {
    if (ymd == null || ymd.isEmpty) return '';
    try {
      final parsed = DateFormat('yyyy-MM-dd').parse(ymd);
      return DateFormat('dd MMMM').format(parsed); // e.g. 16 September
    } catch (_) {
      return ymd;
    }
  }

  Courts argument = Courts();

  @override
  void onInit() {
    super.onInit();
    argument =Get.arguments["data"];
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

  /// Function to create match
  Future<void> createOpenMatch() async {
    try {
      isLoading.value = true;

      if (selectedTime == null) {
        Get.snackbar("Error", "Please select a time slot");
        return;
      }

      // Format date
      String formattedDate = DateFormat("yyyy-MM-dd").format(selectedDate.value);

      // Prepare request data (adjust keys as per your API requirement)
      final data = {
        "matchDate": formattedDate,
        "matchTime": selectedTime,
        "slots": selectedSlots, // optional, if required
      };

      final repo = OpenMatchRepository(); // your repo class instance
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

      // keep raw formatted time like "7 pm"
      final formattedTime = _formatTimeForApi(selectedTime!);

      final repo = OpenMatchRepository();
      final response = await repo.getMatchesByDateTime(
        matchDate: formattedDate,
        matchTime: formattedTime,
        cubId: argument.id??"",
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
    // Normalize input like "7:00pm" or "7 pm" to a consistent DateTime
    final cleaned = raw.replaceAll(' ', '').toUpperCase(); // e.g., 7:00PM
    DateTime? parsed;
    try {
      parsed = DateFormat('h:mma').parse(cleaned);
    } catch (_) {
      try {
        parsed = DateFormat('hha').parse(cleaned); // e.g., 07PM
      } catch (_) {
        try {
          parsed = DateFormat('ha').parse(cleaned); // e.g., 7PM
        } catch (_) {
          parsed = null;
        }
      }
    }
    if (parsed == null) {
      return raw; // fallback
    }
    return DateFormat('h a').format(parsed).toLowerCase();
  }

  // Returns true if the provided slot (e.g., "7 pm") is in the past for the selected date
  bool isPastTime(String slotLabel) {
    try {
      final targetDate = selectedDate.value;
      final now = DateTime.now();
      // If selected date is after today, nothing is past
      if (DateTime(targetDate.year, targetDate.month, targetDate.day)
          .isAfter(DateTime(now.year, now.month, now.day))) {
        return false;
      }
      // If selected date is before today, everything is past (but our picker doesn't allow that)
      if (DateTime(targetDate.year, targetDate.month, targetDate.day)
          .isBefore(DateTime(now.year, now.month, now.day))) {
        return true;
      }

      final cleaned = slotLabel.replaceAll(' ', '').toUpperCase();
      final parsed = DateFormat('ha').parse(cleaned); // hour only
      final slotDateTime = DateTime(targetDate.year, targetDate.month, targetDate.day, parsed.hour, 0);
      return slotDateTime.isBefore(now);
    } catch (_) {
      return false;
    }
  }

  // First future or current time slot for the selected date
  String? firstAvailableSlot() {
    for (final t in timeSlots) {
      if (!isPastTime(t)) return t;
    }
    return null;
  }

  // Expose filtered slots
  List<String> get availableSlots => timeSlots.where((t) => !isPastTime(t)).toList();
  List<String> get unavailableSlots => timeSlots.where((t) => isPastTime(t)).toList();

  // Keep selection valid whenever called
  void _ensureValidSelection() {
    // If current selection is past or null, choose first available
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

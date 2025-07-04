import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import 'package:get/get.dart';

class BookSessionController extends GetxController {
  Rx<bool> viewUnavailableSlots = false.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  // Change from String? to List<String>
  RxList<String> selectedTimes = <String>[].obs;

  final List<String> timeSlots = [
    "8:00am",
    "8:10am",
    "8:30am",
    "8:40am",
    "9:00am",
    "9:20am",
    "9:40am",
    "10:00am",
    "10:20am",
  ];

  // Helper method to toggle selection
  void toggleTimeSlot(String time) {
    if (selectedTimes.contains(time)) {
      selectedTimes.remove(time);
    } else {
      selectedTimes.add(time);
    }
  }
}
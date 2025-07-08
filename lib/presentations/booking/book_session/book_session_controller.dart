import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';
import 'package:get/get.dart';

class BookSessionController extends GetxController {
  Rx<bool> viewUnavailableSlots = false.obs;
  RxList<String> selectedTimes = <String>[].obs;
  final selectedDate = Rxn<DateTime>();

  final List<String> timeSlots = List.generate(19, (index) {
    final hour = 6 + index;
    if (hour == 24) return '12:00am';

    final period = hour >= 12 ? 'pm' : 'am';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    return '${formattedHour == 0 ? 12 : formattedHour}:00$period';
  });


  // Helper method to toggle selection
  void toggleTimeSlot(String time) {
    if (selectedTimes.contains(time)) {
      selectedTimes.remove(time);
    } else {
      selectedTimes.add(time);
    }
  }
}
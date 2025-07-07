import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class OpenMatchesController extends GetxController {
  Rx<bool> viewUnavailableSlots = false.obs;
  RxList<String> selectedTimes = <String>[].obs;
  var selectedDates = <DateTime>[].obs;

  final List<String> timeSlots = List.generate(19, (index) {
    final hour = 6 + index;
    if (hour == 24) return '12:00am';

    final period = hour >= 12 ? 'pm' : 'am';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    return '${formattedHour == 0 ? 12 : formattedHour}:00$period';
  });
}
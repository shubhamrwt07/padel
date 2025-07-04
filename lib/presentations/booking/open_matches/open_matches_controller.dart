import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class OpenMatchesController extends GetxController {
  Rx<bool> viewUnavailableSlots = false.obs;
  RxList<String> selectedTimes = <String>[].obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;

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
}
import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

class OpenMatchesController extends GetxController{
  Rx<bool> viewUnavailableSlots = false.obs;
  String? selectedTime;
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
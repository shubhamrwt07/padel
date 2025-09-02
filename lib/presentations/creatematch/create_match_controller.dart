import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
class CreateOpenMatchesController extends GetxController{
  Rx<bool> viewUnavailableSlots = false.obs;
  RxList<String> selectedTimes = <String>[].obs;
  final selectedDate = Rxn<DateTime>();
  final List<String> timeSlots = List.generate(18, (index) {
    final hour = 6 + index;
    final period = hour >= 12 ? 'pm' : 'am';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    return '${formattedHour == 0 ? 12 : formattedHour}:00$period';
  });
  void toggleTimeSlot(String time) {
    if (selectedTimes.contains(time)) {
      selectedTimes.remove(time);
    } else {
      selectedTimes.add(time);
    }
  }
  final EasyDatePickerController dateTimelineController = EasyDatePickerController();
  Future<void> openDatePicker(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade800,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate.value = picked;
      selectedTimes.clear();
      dateTimelineController.animateToDate(picked);
    }
  }

  //Dummy Images----------------------------------------------------------------
  RxList<String> images = [
    "https://i.pravatar.cc/150?img=1",
    "https://i.pravatar.cc/150?img=2",
    "https://i.pravatar.cc/150?img=3",
  ].obs;
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  // Reactive variable for selected date
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  // Function to show date picker
  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
///
    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
      // Optional: You can update UI or do something with the date here
      Get.snackbar("Selected Date", "${selectedDate.value}");
    }
  }
}
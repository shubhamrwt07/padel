import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{
  final RxList<String> selectedLocations = <String>[].obs;
  final List<String> dummyLocations = [
    'Delhi',
    'Mumbai',
    'Bangalore',
    'Hyderabad',
    'Chennai',
    'Pune',
    'Kolkata',
    'Jaipur',
    'Ahmedabad',
    'Chandigarh',
  ];
  //DATE------------------------------------------------------------------------
  var selectedDate = DateTime.now().obs;

  Future<void> selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: const TextTheme(
              // Customize as needed
              titleLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              bodyLarge: TextStyle(fontSize: 14),
              bodyMedium: TextStyle(fontSize: 12),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      selectedDate.value = pickedDate;
    }
  }


}
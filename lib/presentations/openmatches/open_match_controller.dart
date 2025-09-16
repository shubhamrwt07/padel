import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../data/response_models/openmatch_model/all_open_matches.dart';
import '../../data/response_models/openmatch_model/open_match_model.dart';
import '../../repositories/openmatches/open_match_repository.dart';

class OpenMatchController extends GetxController {
  final OpenMatchRepository repository = OpenMatchRepository();

  Rx<AllOpenMatches?> matches = Rx<AllOpenMatches?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  RxString selectedSlot = 'Morning'.obs;
  RxBool showFilter = false.obs;
  final List<String> slots = ['Morning', 'Afternoon', 'Evening'];
  final RxString selectedCategory = 'Select Category'.obs;

  // SELECT CATEGORY
  final List<String> categories = ['Level A', 'Level B', 'Level C'];
  final GlobalKey dropdownKey = GlobalKey();

  void selectSlot(String slot) {
    selectedSlot.value = slot;
  }

  // DATE
  var selectedDate = DateTime.now().obs;

  Future<void> selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      selectedDate.value = pickedDate;
    }
  }

  // FETCH OPEN MATCHES
  // Future<void> fetchOpenMatches() async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //     final response = await repository.getAllOpenMatches();
  //     matches.value = response;
  //   } catch (e) {
  //     errorMessage.value = e.toString();
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  @override
  void onInit() {

    super.onInit();
    // fetchOpenMatches();
  }
}

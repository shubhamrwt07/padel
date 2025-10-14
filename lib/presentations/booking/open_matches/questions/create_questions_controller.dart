import 'dart:developer';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/components/snack_bars.dart';
import 'package:padel_mobile/presentations/booking/details_page/details_page.dart';
import 'package:padel_mobile/presentations/booking/details_page/details_page_controller.dart';

class CreateQuestionsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  // ✅ Access the existing DetailsController
  DetailsController detailsController = Get.isRegistered<DetailsController>()
      ? Get.find<DetailsController>()
      : Get.put(DetailsController());

  /// ============================
  /// Reactive Variables
  /// ============================
  var currentStep = 1.obs;

  var selectedLevel = ''.obs;

  /// ✅ Multi-select list for sports
  var selectedSports = <String>[].obs;

  var selectedTraining = ''.obs;
  var selectedAgeGroup = ''.obs;
  var selectedVolley = ''.obs;
  var selectedWallRebound = ''.obs;
  var selectPlayerLevel = ''.obs;

  /// ============================
  /// Navigation Logic
  /// ============================

  void goNext() {
    switch (currentStep.value) {
      case 1:
        if (selectedLevel.value.isEmpty) {
          SnackBarUtils.showWarningSnackBar(
              "Required\nPlease select a level before proceeding");
          return;
        }
        break;

      case 2:
      // ✅ Check for at least one selected sport
        if (selectedSports.isEmpty) {
          SnackBarUtils.showWarningSnackBar(
              "Required\nPlease select at least one sport before proceeding");
          return;
        }
        break;

      case 3:
        if (selectedTraining.value.isEmpty) {
          SnackBarUtils.showWarningSnackBar(
              "Required\nPlease select training before proceeding");
          return;
        }
        break;

      case 4:
        if (selectedAgeGroup.value.isEmpty) {
          SnackBarUtils.showWarningSnackBar(
              "Required\nPlease select an age group before proceeding");
          return;
        }
        break;

      case 5:
        if (selectedVolley.value.isEmpty) {
          SnackBarUtils.showWarningSnackBar(
              "Required\nPlease select volley option before proceeding");
          return;
        }
        break;

      case 6:
        if (selectPlayerLevel.value.isEmpty) {
          SnackBarUtils.showWarningSnackBar(
              "Required\nPlease select player level");
          return;
        }
        break;

      case 7:
        if (selectedWallRebound.value.isEmpty) {
          SnackBarUtils.showWarningSnackBar(
              "Required\nPlease select wall rebound before submitting");
          return;
        }
        break;
    }

    // ✅ Move to next step
    if (currentStep.value < 7) {
      currentStep.value++;
    }
  }

  void goBack() {
    if (currentStep.value > 1) currentStep.value--;
  }

  void closeDialog() {
    currentStep.value = 1;
    Get.back();
  }

  /// ============================
  /// Final Submission
  /// ============================
  void onSubmit() {
    // ✅ Update local data map with user selections
    detailsController.localMatchData.update("skillLevel", (v) => selectedLevel.value);
    detailsController.localMatchData.update("playerLevel", (v) => selectPlayerLevel.value);

    detailsController.localMatchData.update("skillDetails", (v) => [
      selectedSports.join(', '), // ✅ Join multiple sports
      selectedTraining.value,
      selectedAgeGroup.value,
      selectedVolley.value,
      selectedWallRebound.value,
      selectPlayerLevel.value,
    ]);

    // ✅ Update player level shown in details page
    if (detailsController.teamA.isNotEmpty) {
      final current = Map<String, dynamic>.from(detailsController.teamA.first);
      current['levelLabel'] = selectPlayerLevel.value; // e.g. "A – Top Player"
      final shortCode = selectPlayerLevel.value.split(' ').first.trim();
      current['level'] = shortCode;
      detailsController.teamA[0] = current;
      detailsController.teamA.refresh();
      detailsController.update();
    }

    log("Selected answers: "
        "Level: ${selectedLevel.value}, "
        "Sports: ${selectedSports.join(', ')}, "
        "Training: ${selectedTraining.value}, "
        "Age: ${selectedAgeGroup.value}, "
        "Volley: ${selectedVolley.value}, "
        "Wall: ${selectedWallRebound.value}, "
        "Player Level: ${selectPlayerLevel.value}");

    Get.to(() => DetailsScreen());
  }
}

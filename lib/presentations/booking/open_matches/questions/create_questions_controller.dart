import 'dart:developer';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/components/snack_bars.dart';
import 'package:padel_mobile/presentations/booking/details_page/details_model.dart';
import 'package:padel_mobile/presentations/booking/details_page/details_page.dart';

class CreateQuestionsController extends GetxController{

    @override
  void onInit() {

    super.onInit();
  }

  var currentStep = 1.obs;
  var selectedLevel = ''.obs;
  var selectedSport = ''.obs;

    void goNext() {
      switch (currentStep.value) {
        case 1:
          if (selectedLevel.value.isEmpty) {
            SnackBarUtils.showWarningSnackBar("Required\nPlease select a level before proceeding");
            return;
          }
          break;
        case 2:
          if (selectedSport.value.isEmpty) {
            SnackBarUtils.showWarningSnackBar("Required\nPlease select a sport before proceeding");

            return;
          }
          break;
        case 3:
          if (selectedTraining.value.isEmpty) {
            SnackBarUtils.showWarningSnackBar("Required\nPlease select training before proceeding");
            return;
          }
          break;
        case 4:
          if (selectedAgeGroup.value.isEmpty) {
            SnackBarUtils.showWarningSnackBar("Required\nPlease select an age group before proceeding");
            return;
          }
          break;
        case 5:
          if (selectedVolley.value.isEmpty) {
            SnackBarUtils.showWarningSnackBar("Required\nPlease select volley option before proceeding");
            return;
          }
          break;
        case 6:
          if (selectedWallRebound.value.isEmpty) {
            SnackBarUtils.showWarningSnackBar("Required\nPlease select wall rebound before submitting");
            return;
          }
          break;
      }

      if (currentStep.value < 6) {
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
  //
  var selectedTraining = ''.obs;
  var selectedAgeGroup = ''.obs;
  //
  var selectedVolley = ''.obs;
  var selectedWallRebound = ''.obs;
  onSubmit(){
    log("Selected answers ${selectedLevel.value} ${selectedSport.value} ${selectedTraining.value} ${selectedAgeGroup.value} ${selectedVolley.value} ${selectedWallRebound.value}");
    Get.to(()=>DetailsScreen (),);

  }
}
import 'package:get/get.dart';

class CreateQuestionsController extends GetxController{
  var currentStep = 1.obs;

  var selectedLevel = ''.obs;
  var selectedSport = ''.obs;

  void goNext() {
    if (currentStep.value < 6) currentStep.value++;
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
}
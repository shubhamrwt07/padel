import 'dart:developer';
import 'package:get/get.dart';
import 'package:padel_mobile/presentations/booking/details_page/details_model.dart';
import '../booking/details_page/details_page.dart';

class CreateQuestionsController extends GetxController{

    @override
  void onInit() {

    super.onInit();
  }

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
  onSubmit(){
    Get.to(()=>DetailsScreen (),);
  }
}
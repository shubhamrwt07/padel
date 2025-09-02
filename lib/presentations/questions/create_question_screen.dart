import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../configs/app_colors.dart';
import '../../configs/components/primary_button.dart';
import '../../configs/components/primary_text_feild.dart';
import '../../configs/routes/routes_name.dart';
import 'create_questions_controller.dart';
class CreateQuestionsScreen extends GetView<CreateQuestionsController> {
  const CreateQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateQuestionsController());

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.2),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.textFieldColor,
              borderRadius: BorderRadius.circular(10)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          margin: EdgeInsets.symmetric(horizontal: Get.width*0.03,vertical: Get.width*0.03),
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildProgressBar(),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.currentStep.value == 1) _buildLevelSelection(),
                      if (controller.currentStep.value == 2) _buildSportSelection(),
                      if (controller.currentStep.value == 3) _buildTrainingSelection(controller),
                      if (controller.currentStep.value == 4) _buildAgeSelection(controller),
                      if (controller.currentStep.value == 5) _buildVolleySelection(controller),
                      if (controller.currentStep.value == 6) _buildWallReboundSelection(controller),
                    ],
                  ),
                ),
              ),

              _buildNavigationButtons(context),
            ],
          )),
        ),
      ),
    );
  }


  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Create More Step", style: Get.textTheme.headlineMedium!.copyWith(color: AppColors.primaryColor)),
        GestureDetector(
          onTap: controller.closeDialog,
          child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent
              ),
              child: Icon(Icons.close, color: AppColors.textColor)),
        ),
      ],
    );
  }
  Widget _buildProgressBar() {
    return Row(
      children: List.generate(6, (index) {
        bool isActive = controller.currentStep.value > index;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 5,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryColor : Color(0xFFCBD6FF),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
  Widget _buildLevelSelection() {
    final levels = ['Benninger', 'Intermediate', 'Advanced', 'Professional'];
    final style = Get.textTheme.headlineMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("On the following scale, where would you place yourself?", style: style),
        const SizedBox(height: 16),
        ...levels.map((level) => Obx(() => _buildOption(
          title: level,
          isSelected: controller.selectedLevel.value == level,
          onTap: () => controller.selectedLevel.value = level,
        ))),
      ],
    );
  }
  Widget _buildSportSelection() {
    final sports = ['Tennis', 'Badminton', 'Squash', 'Others'];
    final style = Get.textTheme.headlineMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select the racket sport you have played before ?",  style:style),
        const SizedBox(height: 16),
        ...sports.map((sport) => Obx(() => _buildOption(
          title: sport,
          isSelected: controller.selectedSport.value == sport,
          onTap: () => controller.selectedSport.value = sport,
        ))),
      ],
    );
  }
  Widget _buildTrainingSelection(CreateQuestionsController controller) {
    final options = ['No', 'Yes, in the past', 'Yes, currently'];
    final style = Get.textTheme.headlineMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Have you received or are you receiving training in padel?",
            style: style),
        const SizedBox(height: 16),
        ...options.map((option) => Obx(() => _buildOption(
          title: option,
          isSelected: controller.selectedTraining.value == option,
          onTap: () => controller.selectedTraining.value = option,
        ))),
      ],
    );
  }
  Widget _buildAgeSelection(CreateQuestionsController controller) {
    final options = [
      'Between 18 and 30 years',
      'Between 31 and 40 years',
      'Between 41 and 50 years',
      'Over 50'
    ];
    final style = Get.textTheme.headlineMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("How old are you?",
            style: style),
        const SizedBox(height: 16),
        ...options.map((option) => Obx(() => _buildOption(
          title: option,
          isSelected: controller.selectedAgeGroup.value == option,
          onTap: () => controller.selectedAgeGroup.value = option,
        ))),
      ],
    );
  }
  Widget _buildVolleySelection(CreateQuestionsController controller) {
    final options = [
      'I hardly go to the net',
      'I don’t feel safe at the net, i make too many mistake',
      'I can volley forehand and backhand with some difficulties',
      'I have good positioning at the net and I volley confidently',
      'I don’t know'
    ];
    final style = Get.textTheme.headlineMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Volley / Net Positioning", style: style),
        const SizedBox(height: 16),
        ...options.map((option) => Obx(() => _buildOption(
          title: option,
          isSelected: controller.selectedVolley.value == option,
          onTap: () => controller.selectedVolley.value = option,
        ))),
      ],
    );
  }
  Widget _buildWallReboundSelection(CreateQuestionsController controller) {
    final options = [
      'I don’t know how to read the rebounds, I hit before it rebounds',
      'I try, with difficulty, to hit the rebounds on the back wall',
      'I return rebounds on the back wall, it is difficult for me to return the double-wall ones',
      'I return double-wall rebounds and reach for quick rebounds',
      'I perform powerful wall descent shots with forehand and backhand',
      'I don’t know'
    ];
    final style = Get.textTheme.headlineMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Wall Rebound Skills", style: style),
        const SizedBox(height: 16),
        ...options.map((option) => Obx(() => _buildOption(
          title: option,
          isSelected: controller.selectedWallRebound.value == option,
          onTap: () => controller.selectedWallRebound.value = option,
        ))),
      ],
    );
  }




  Widget _buildOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Get.textTheme.labelLarge!.copyWith(color: AppColors.labelBlackColor),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildNavigationButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (controller.currentStep.value > 1)
          TextButton.icon(
            onPressed: controller.goBack,
            icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
            label: Text("Back", style: Get.textTheme.labelLarge!.copyWith(
                color: AppColors.primaryColor)),
          ),
        const Spacer(),

        Obx(() =>
        controller.currentStep.value == 6 ?
        PrimaryButton(
            width: Get.width*0.35,
            height: 40,
            onTap: ()=>_showAddQuestionDialog(context), text: "Submit") :
        ElevatedButton(
          onPressed: controller.goNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
          ),
          child: const Icon(
            Icons.arrow_forward, color: Colors.white, size: 22,),
        )
        )
      ],
    );
  }
  void _showAddQuestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: AppColors.textFieldColor,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child:  GestureDetector(
                      onTap: ()=>Get.back(),
                      child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent
                          ),
                          child: Icon(Icons.close, color: AppColors.textColor)),
                    ),
                  ),
                  Text('Question', style: Get.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  PrimaryTextField(
                      color: AppColors.whiteColor,
                      hintText: "Enter Question"),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Options', style: Get.textTheme.headlineMedium),
                      Text('+ Add', style: Get.textTheme.headlineLarge!.copyWith(color: AppColors.primaryColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  PrimaryTextField(
                      color: AppColors.whiteColor,
                      hintText: "Enter Option"),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(
                        width: Get.width*0.3,
                        height: 40,
                        onTap: ()=>Get.toNamed(RoutesName.bottomNav), text: "Submit"),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/components/primary_button.dart';
import 'create_questions_controller.dart';
class CreateQuestionsScreen extends GetView<CreateQuestionsController> {
  const CreateQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateQuestionsController());

    return Scaffold(
      backgroundColor: Colors.grey.withValues(alpha: 0.4),
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
                      if (controller.currentStep.value == 2) _buildPlayerLevel(controller),
                      if (controller.currentStep.value == 3) _buildSportSelection(),
                      if (controller.currentStep.value == 4) _buildTrainingSelection(controller),
                      if (controller.currentStep.value == 5) _buildAgeSelection(controller),
                      if (controller.currentStep.value == 6) _buildVolleySelection(controller),
                      if (controller.currentStep.value == 7) _buildWallReboundSelection(controller),
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
      children: List.generate(7, (index) {
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
    final levels = ['Beginner', 'Intermediate', 'Advanced', 'Professional'];
    final style = Get.textTheme.headlineMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("On the following scale, where would you place yourself?", style: style),
        const SizedBox(height: 16),
        ...levels.map((level) => Obx(() => _buildOption(
          title: level,
          isSelected: controller.selectedLevel.value == level,
          onTap: () {
            controller.selectedLevel.value = level;
            controller.fetchPlayerLevels();
          },
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
        Text(
          "Select the racket sport(s) you have played before ?",
          style: style,
        ),
        const SizedBox(height: 16),

        // Multi-select options
        ...sports.map((sport) => Obx(() {
          final isSelected = controller.selectedSports.contains(sport);
          return GestureDetector(
            onTap: () {
              if (isSelected) {
                controller.selectedSports.remove(sport);
              } else {
                controller.selectedSports.add(sport);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ✅ Circular "radio-like" visual indicator
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: AppColors.primaryColor,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      sport,
                      style: Get.textTheme.labelLarge!.copyWith(
                        color: AppColors.labelBlackColor,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        })),
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
          isSelected: controller.selectedReboundSkill.value == option,
          onTap: () => controller.selectedReboundSkill.value = option,
        ))),
      ],
    );
  }
  Widget _buildPlayerLevel(CreateQuestionsController controller)  {
    final style = Get.textTheme.headlineMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Which padel player are you?", style: style),
        const SizedBox(height: 16),
        Obx(() {
          print('Loading: ${controller.isLoading.value}, Levels: ${controller.playerLevels.length}');
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.playerLevels.isEmpty) {
            return Text('Please select a level first', style: Get.textTheme.bodyMedium);
          }
          return Column(
            children: controller.playerLevels.map((level) => _buildOption(
              title: '${level['code']} – ${level['question']}',
              isSelected: controller.selectPlayerLevel.value == '${level['code']} – ${level['question']}',
              onTap: () => controller.selectPlayerLevel.value = '${level['code']} – ${level['question']}',
            )).toList(),
          );
        }),
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
            label: Text(
              "Back",
              style: Get.textTheme.labelLarge!
                  .copyWith(color: AppColors.primaryColor),
            ),
          ),
        const Spacer(),

        Obx(() => controller.currentStep.value == 7
            ? PrimaryButton(
            width: Get.width * 0.35,
            height: 40,
            onTap: (){controller.onSubmit();},
            text: "Submit")
            : ElevatedButton(
          onPressed: controller.goNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
          ),
          child: const Icon(Icons.arrow_forward,
              color: Colors.white, size: 22),
        ))
      ],
    );
  }
}

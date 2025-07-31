import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/presentations/registration/registration_americano_controller.dart';
import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
import '../../configs/components/primary_button.dart';
import '../../configs/components/primary_text_feild.dart';

class RegistrationView extends GetView<RegistrationController> {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar(context),
      appBar: primaryAppBar(
        centerTitle: true,
        title: const Text("Registration"),
        context: context,
      ),
      body: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textFieldWithLabel(
              "First Name",
              action: TextInputAction.next,
              controller.fullNameController,
              context,
            ),
            textFieldWithLabel(
              "Email",
              action: TextInputAction.next,
              controller.emailController,
              context,
            ),
            textFieldWithLabel(
              "Phone Number",
              action: TextInputAction.next,
              controller.phoneController,
              context,
            ),
            Text(
              "Gender",
              style: Get.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.labelBlackColor,
              ),
            ).paddingOnly(top: Get.height * 0.02),
            Obx(
                  () => Row(
                children: ["Female", "Male", "Other"].map((g) {
                  return Expanded(
                    child: RadioListTile<String>(
                      title: Text(
                        g,
                        style: Get.textTheme.headlineSmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      dense: true,
                      value: g,
                      groupValue: controller.gender.value,
                      onChanged: (value) => controller.gender.value = value!,
                      contentPadding: EdgeInsets.zero,
                    ),
                  );
                }).toList(),
              ),
            ),
            Text(
              "Player Level",
              style: Get.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.labelBlackColor,
              ),
            ).paddingOnly(top: Get.height * 0.02, bottom: Get.height * 0.01),
            Obx(
                  () => DropdownButtonFormField<String>(
                value: controller.playerLevel.value,
                isDense: true,
                items: controller.playerLevels.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(level, style: Get.textTheme.labelLarge),
                  );
                }).toList(),
                onChanged: (value) => controller.playerLevel.value = value!,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColors.textFieldColor,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomBar(BuildContext context) {
    return Container(
      height: Get.height * .12,
      padding: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          height: 55,
          width: Get.width * 0.9,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: PrimaryButton(
            height: 50,
            onTap: () {},
            text: "Continue",
          ),
        ).paddingOnly(bottom: Get.height * 0.03),
      ),
    );
  }

  Widget textFieldWithLabel(
      String label,
      TextEditingController? controller,
      BuildContext context, {
        bool readOnly = false,
        TextInputType? keyboardType,
        TextInputAction? action,
        int? maxLength,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.labelBlackColor,
          ),
        ).paddingOnly(top: Get.height * .02),
        PrimaryTextField(
          hintText: "Enter $label",
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          action: action,
          maxLength: maxLength,
        ).paddingOnly(top: 10),
      ],
    );
  }
}

// ✅ FILE: edit_profile_ui.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/components/loader_widgets.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';
import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
import '../../configs/components/primary_button.dart';
import '../../configs/components/primary_text_feild.dart';
import '../../generated/assets.dart';

class EditProfileUi extends GetView<ProfileController> {
  const EditProfileUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      bottomNavigationBar: _bottomBar(context),
      appBar: primaryAppBar(
        showLeading: true,
        centerTitle: true,
        title: Text(" Edit Profile").paddingOnly(left: Get.width * 0.02),
        action: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.check,
              color: AppColors.blueColor,
            ).paddingOnly(right: Get.width * 0.02),
          ),
        ],
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileImage(context),
            _textFieldWithLabel(
              "Full Name",
              controller.nameController,
              context,
            ),
            _textFieldWithLabel("Email", controller.emailController, context),
            _textFieldWithLabel(
              "Phone",
              controller.phoneController,
              context,
              keyboardType: TextInputType.phone,
            ),
            _genderSelection(context),
            _dobField(context),
            _textFieldWithLabel("Location / City", null, context),
          ],
        ).paddingOnly(top: 10, left: Get.width * 0.05, right: Get.width * 0.05),
      ),
    );
  }

  Widget _bottomBar(BuildContext context) {
    return Container(
      height: Get.height * .1,
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
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
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Obx(
            () => PrimaryButton(
              height: 50,
              onTap: () {
                controller.updateProfile();
              },
              text: "Update",
              child: controller.isLoading.value
                  ? AppLoader(size: 30, strokeWidth: 5)
                  : null,
            ),
          ),
        ).paddingOnly(bottom: Get.height * 0.03),
      ),
    );
  }

  Widget _profileImage(BuildContext context) {
    return Center(
      child: Obx(() {
        final imagePath = controller.profileImage.value?.path;
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              height: Get.height * .11,
              width: Get.width * .24,
              decoration: BoxDecoration(
                color: AppColors.tabSelectedColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: imagePath == null
                  ? Icon(
                      Icons.person,
                      size: 90,
                      color: AppColors.labelBlackColor,
                    )
                  : ClipOval(
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                        width: Get.width * .24,
                        height: Get.height * .11,
                      ),
                    ),
            ),
            Positioned(
              bottom: 0,
              right: 8,
              child: GestureDetector(
                onTap: () => controller.showImageSourceActionSheet(context),
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(Assets.imagesIcCamara, scale: 5),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _textFieldWithLabel(
    String label,
    TextEditingController? controller,
    BuildContext context, {
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.labelBlackColor,
          ),
        ).paddingOnly(top: Get.height * .02),
        PrimaryTextField(
          hintText: "Enter $label",
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
        ).paddingOnly(top: 10),
      ],
    );
  }

  Widget _genderSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gender",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.labelBlackColor,
          ),
        ).paddingOnly(top: Get.height * .02),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ["Female", "Male", "Other"].map((gender) {
              return GestureDetector(
                onTap: () => controller.selectedGender.value = gender,
                child: Row(
                  children: [
                    Icon(
                      controller.selectedGender.value == gender
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      size: 15,
                      color: AppColors.labelBlackColor,
                    ),
                    Text(
                      gender,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.copyWith(fontSize: 14),
                    ).paddingOnly(left: 5),
                  ],
                ),
              );
            }).toList(),
          ),
        ).paddingOnly(top: 10),
      ],
    );
  }

  Widget _dobField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date of Birth",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.labelBlackColor,
          ),
        ).paddingOnly(top: Get.height * .02),
        Obx(
          () => PrimaryTextField(
            readOnly: true,
            controller: controller.dobController.value,
            hintText: "Select Date of Birth",
            suffixIcon: IconButton(
              icon: Icon(
                Icons.calendar_month_outlined,
                color: AppColors.iconColor,
              ),
              onPressed: () => controller.selectDate(context),
            ),
          ).paddingOnly(top: 10),
        ),
      ],
    );
  }
}

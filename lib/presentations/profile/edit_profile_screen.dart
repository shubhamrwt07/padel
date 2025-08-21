// ✅ FILE: edit_profile_ui.dart
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        bottomNavigationBar: _bottomBar(context),
        appBar: primaryAppBar(
          showLeading: true,
          centerTitle: true,
          title: Text(" Edit Profile").paddingOnly(left: Get.width * 0.02),
          action: [
            // GestureDetector(
            //   onTap: () => Get.back(),
            //   child: Icon(
            //     Icons.check,
            //     color: AppColors.blueColor,
            //   ).paddingOnly(right: Get.width * 0.02),
            // ),
          ],
          context: context,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileImage(context),
              _textFieldWithLabel(
                "First Name",
                controller.nameController,
                context,
              ),
              _textFieldWithLabel(
                "Last Name",
                controller.lastNameController,
                context,
              ),
              _textFieldWithLabel(
                "Email",
                controller.emailController,
                context,
               ),
              _textFieldWithLabel(
                "Phone",
                controller.phoneController,
                context,
                 keyboardType: TextInputType.phone,
              ),
              _genderSelection(context),
              _dobField(context),
              _textFieldWithLabel("Location / City", controller.locationController, context),
            ],
          ).paddingOnly(top: 10, left: Get.width * 0.05, right: Get.width * 0.05),
        ),
      ),
    );
  }

  Widget _bottomBar(BuildContext context) {
    return Container(
      height: Get.height * .12,
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
        final imageUrl = controller.profileImageUrl.value;

        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onTap: () => controller.showImageSourceActionSheet(context),
              child: Container(
                height: Get.height * .11,
                width: Get.width * .24,
                decoration: BoxDecoration(
                  color: AppColors.tabSelectedColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ClipOval(
                  child: imagePath != null
                      ? Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    width: Get.width * .24,
                    height: Get.height * .11,
                  )
                      : imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: Get.width * .24,
                    height: Get.height * .11,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 90,
                      color: AppColors.labelBlackColor,
                    ),
                  )
                      : Icon(
                    Icons.person,
                    size: 90,
                    color: AppColors.labelBlackColor,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 5,
              child: GestureDetector(
                onTap: () => controller.showImageSourceActionSheet(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(Assets.imagesIcCamara, scale: 4.2),
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
          // scrollPadding: EdgeInsets.only(bottom: Get.height*0.3),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.04,
            vertical: (57) * 0.22,
          ),
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
              () => GestureDetector(
               onTap: ()=>controller.selectDate(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.04,
                vertical: 57 * 0.22,
              ),
              decoration: BoxDecoration(
                color: AppColors.textFieldColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.containerBorderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.selectedDate.value.isEmpty
                        ? "Select Date of Birth"
                        : controller.selectedDate.value,
                    style: TextStyle(
                      color: controller.selectedDate.value.isEmpty
                          ? AppColors.textHintColor
                          : AppColors.textColor,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.iconColor,
                  ),
                ],
              ),
            ).paddingOnly(top: 10),
          ),
        )
      ],
    );
  }

}

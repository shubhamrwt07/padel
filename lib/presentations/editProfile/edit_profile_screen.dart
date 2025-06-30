import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
import '../../configs/components/primary_button.dart';
import '../../configs/components/primary_text_feild.dart';
import 'edit_profile_controller.dart';

class EditProfileUi extends StatelessWidget {
  const EditProfileUi({super.key});

  @override
  Widget build(BuildContext context) {
    EditProfileController controller = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      bottomNavigationBar: Container(
        height: Get.height * .1,
        padding: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
              height: 55,
              width: Get.width * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(Get.context!).primaryColor,
                borderRadius: BorderRadius.circular(30),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: PrimaryButton(
                height: 50,

                onTap: () {
                  Get.back();
                },
                text: "Update",
              )
          ).paddingOnly(bottom: Get.height*0.03),
        ),
      ),
      appBar: primaryAppBar(
        showLeading: true,
        centerTitle: true,
        title: Text(" Edit Profile").paddingOnly(left: Get.width * 0.02),
        action: [
          GestureDetector(
            onTap: ()=>Get.back(),
            child: Icon(Icons.check,color: AppColors.blueColor,).paddingOnly(right: Get.width * 0.02),
          ),
        ],
        context: context,
      ),
      body:
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    // Aligns children to bottom-right by default
                    children: [
                      Container(
                        height: Get.height * .11,
                        width: Get.width * .24,
                        decoration: BoxDecoration(
                          color: AppColors.tabSelectedColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(Icons.person, size: 90,color: AppColors.labelBlackColor,),
                      ),
                      Positioned(
                        bottom: 0, // Adjust spacing from bottom
                        right: 8, // Adjust spacing from right
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Full Name",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(top: Get.height * .02),
                PrimaryTextField(hintText: "Enter Name").paddingOnly(top: 10),
                Text(
                  "Email",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(top: Get.height * .02),
                PrimaryTextField(hintText: " Enter Email",).paddingOnly(top: 10),
                Text(
                  "Phone",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(top: Get.height * .02),
                PrimaryTextField(
                  hintText: "Enter Phone Number",keyboardType: TextInputType.phone,
                ).paddingOnly(top: 10),
                Text(
                  "Gender",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(top: Get.height * .02),
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => controller.selectedGender.value = "Female",
                      child: Row(
                        children: [
                          Icon(
                            controller.selectedGender.value == "Female"
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            size: 15,
                            color: AppColors.labelBlackColor,
                          ),
                          Text(
                            "Female",
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppColors.labelBlackColor,
                            ),
                          ).paddingOnly(left: 5),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.selectedGender.value = "Male",
                      child: Row(
                        children: [
                          Icon(
                            controller.selectedGender.value == "Male"
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            size: 15,
                            color: AppColors.labelBlackColor,
                          ),
                          Text(
                            "Male",
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppColors.labelBlackColor,
                            ),
                          ).paddingOnly(left: 5),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.selectedGender.value = "Other",
                      child: Row(
                        children: [
                          Icon(
                            controller.selectedGender.value == "Other"
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            size: 15,
                            color: AppColors.labelBlackColor,
                          ),
                          Text(
                            "Other",
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppColors.labelBlackColor,
                            ),
                          ).paddingOnly(left: 5),
                        ],
                      ),
                    ),
                  ],
                )).paddingOnly(top: 10),                Text(
                  "Date of Birth",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(top: Get.height * .02),
                GestureDetector(
                  onTap: () => controller.selectDate(context),
                  child: Container(
                    alignment: Alignment.centerRight,
                    height: 50,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.lightBlueColor,
                    ),
                    child: Icon(
                      Icons.calendar_month_outlined,color: AppColors.iconColor,
                    ).paddingOnly(right: 10),
                  ).paddingOnly(top: 10),
                ),
                Text(
                  "Location / City",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(top: Get.height * .02),
                PrimaryTextField(
                  hintText: "Enter your location",
                ).paddingOnly(top: 8),
              ],
            ).paddingOnly(
              top: Get.height * .01,
              left: Get.width * .05,
              right: Get.width * .05,
            ),
          ),
    );
  }
}

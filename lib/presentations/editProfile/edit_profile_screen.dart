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
        height: Get.height * .09,
        padding: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
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
                borderRadius: BorderRadius.circular(40),
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
          ),
        ),
      ),
      appBar: primaryAppBar(
        showLeading: true,
        centerTitle: true,
        title: Text(" Edit Profile").paddingOnly(left: Get.width * 0.02),
        action: [
          GestureDetector(
            onTap: ()=>Get.back(),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 1.4,
                    spreadRadius: 2.2,
                  ),
                ],
              ),
              child: Icon(Icons.check),
            ).paddingOnly(right: Get.width * 0.02),
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
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(top: Get.height * .02),
                PrimaryTextField(hintText: "Enter Name").paddingOnly(top: 8),
                Text(
                  "Email",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(top: Get.height * .02),
                PrimaryTextField(hintText: " Enter Email").paddingOnly(top: 8),
                Text(
                  "Phone",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(top: Get.height * .02),
                PrimaryTextField(
                  hintText: "Enter Phone Number",
                ).paddingOnly(top: 8),
                Text(
                  "Gender",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.labelBlackColor,
                  ),
                ).paddingOnly(top: Get.height * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, // Border Color
                          width: 2.0, // Border Width
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Text(
                      "Female",
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.labelBlackColor,
                      ),
                    ).paddingOnly(left: 5),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, // Border Color
                          width: 2.0, // Border Width
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Text(
                      "Male",
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.labelBlackColor,
                      ),
                    ).paddingOnly(left: 5),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, // Border Color
                          width: 2.0, // Border Width
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                ).paddingOnly(top: 8),
                Text(
                  "Date of Birth",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
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
                      Icons.calendar_month_outlined,
                    ).paddingOnly(right: 10),
                  ),
                ),
                Text(
                  "Location / City",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
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

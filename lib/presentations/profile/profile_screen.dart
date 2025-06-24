import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
import '../../generated/assets.dart';

class ProfileUi extends StatelessWidget {
  const ProfileUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: primaryAppBar(
        centerTitle: true,
        showLeading: false,
        title: Text(
          "Profile",
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
        ).paddingOnly(left: Get.width * 0.02),

        context: context,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                // Aligns children to bottom-right by default
                children: [
                  Container(
                    height: Get.height * .11,
                    width: Get.width * .24,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.person, size: 90),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Jane Cooper",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.labelBlackColor,
                    ),
                  ).paddingOnly(),

                  Text(
                    "jackson.graham@example.com",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.labelBlackColor,
                    ),
                  ).paddingOnly(top: 0),
                  Container(
                    alignment: Alignment.center,
                    height: Get.height * .03,
                    width: Get.width * .22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color(0xFF3DBE64), // #3DBE64 (30%)
                          const Color(0xFF1F41BB), // #1F41BB (70%)
                        ],
                        stops: [
                          0.1,
                          0.9,
                        ], // 30% for first color, rest for second
                      ),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 10,
                      ),
                    ),
                  ).paddingOnly(top: 10),
                ],
              ).paddingOnly(left: 10),
            ],
          ).paddingOnly(left: Get.width * .03, right: Get.width * .03),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 30,
                color: AppColors.labelBlackColor,
              ),
              Text(
                "Booking",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.labelBlackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ).paddingOnly(left: Get.width * .1),
            ],
          ).paddingOnly(top: Get.height * .05),
          Row(
            children: [
              Icon(Icons.payment, size: 30, color: AppColors.labelBlackColor),
              Text(
                "Payments",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.labelBlackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ).paddingOnly(left: Get.width * .1),
            ],
          ).paddingOnly(top: Get.height * .05),
          Row(
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 30,
                color: AppColors.labelBlackColor,
              ),
              Text(
                "Cart",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.labelBlackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ).paddingOnly(left: Get.width * .1),
            ],
          ).paddingOnly(top: Get.height * .05),
          Row(
            children: [
              Icon(
                Icons.headset_mic,
                size: 30,
                color: AppColors.labelBlackColor,
              ),
              Text(
                "Help & Support",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.labelBlackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ).paddingOnly(left: Get.width * .1),
            ],
          ).paddingOnly(top: Get.height * .05),
          Row(
            children: [
              Icon(
                Icons.privacy_tip_outlined,
                size: 30,
                color: AppColors.labelBlackColor,
              ),
              Text(
                "Privacy",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.labelBlackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ).paddingOnly(left: Get.width * .1),
            ],
          ).paddingOnly(top: Get.height * .05),
          Row(
            children: [
              SvgPicture.asset(height: 22,width: 22,
                Assets.imagesIcLogOut,
              ).paddingOnly(left: 5),
              Text(
                "Logout",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ).paddingOnly(left: Get.width * .11),
            ],
          ).paddingOnly(top: Get.height * .05),
        ],
      ).paddingOnly(left: Get.width * .05, right: Get.width * .05),
    );
  }
}

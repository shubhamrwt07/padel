import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';

import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
import '../../generated/assets.dart';

class ProfileUi extends StatelessWidget {
  const ProfileUi({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Are you sure you want to logout?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(RoutesName.login); // Perform logout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 8, // Reduced vertical padding
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    textStyle: TextStyle(fontSize: 14), // Smaller font if needed
                  ),
                  child: Text("Yes",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!

                        .copyWith(fontWeight: FontWeight.w600,color: Colors.white),),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blueColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 8, // Reduced vertical padding
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    textStyle: TextStyle(fontSize: 14), // Smaller font if needed
                  ),
                  child: Text("No", style: Theme.of(context)
                      .textTheme
                      .titleSmall!

                      .copyWith(fontWeight: FontWeight.w600,color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: primaryAppBar(
        centerTitle: true,
        showLeading: false,
        title: Text(
          "Profile",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w600),
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
                children: [
                  Container(
                    height: Get.height * .11,
                    width: Get.width * .24,
                    decoration: BoxDecoration(
                      color: AppColors.tabSelectedColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.person,
                        size: 90, color: AppColors.labelBlackColor),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 8,
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
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.labelBlackColor,
                    ),
                  ).paddingOnly(left: 5),
                  Text(
                    "jackson.graham@example.com",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.labelBlackColor,
                    ),
                  ).paddingOnly(left: 5),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RoutesName.editProfile);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: Get.height * .03,
                      width: Get.width * .22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color(0xFF3DBE64),
                            const Color(0xFF1F41BB),
                          ],
                          stops: [0.1, 0.9],
                        ),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                          color: AppColors.whiteColor,
                          fontSize: 8,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ).paddingOnly(top: 10,left: 5),
                  ),
                ],
              ).paddingOnly(left: 10),
            ],
          ).paddingOnly(left: Get.width * .0, right: Get.width * .0),
          GestureDetector(
            onTap: () {
              Get.toNamed(RoutesName.bookingHistory);
            },
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                  color: AppColors.labelBlackColor,
                ),
                Text(
                  "Booking",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(
                    color: AppColors.labelBlackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ).paddingOnly(left: Get.width * .1),
              ],
            ).paddingOnly(top: Get.height * .05),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(RoutesName.paymentWallet);
            },
            child: Row(
              children: [
                Image.asset(
                  Assets.imagesIcBalanceWallet,
                  scale: 5,
                ),
                Text(
                  "Payments",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(
                    color: AppColors.labelBlackColor,
                    fontWeight: FontWeight.w600,

                  ),
                ).paddingOnly(left: Get.width * .1),
              ],
            ).paddingOnly(top: Get.height * .05),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(RoutesName.cart);
            },
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 20,
                  color: AppColors.labelBlackColor,
                ),
                Text(
                  "Cart",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(
                    color: AppColors.labelBlackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ).paddingOnly(left: Get.width * .1),
              ],
            ).paddingOnly(top: Get.height * .05),
          ),
          GestureDetector(
            onTap: ()=>Get.toNamed(RoutesName.support),
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Icon(
                    Icons.headset_mic_outlined,
                    size: 20,
                    color: AppColors.labelBlackColor,
                  ),
                  Text(
                    "Help & Support",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(
                      color: AppColors.labelBlackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ).paddingOnly(left: Get.width * .1),
                ],
              ).paddingOnly(top: Get.height * .05),
            ),
          ),
          Row(
            children: [
              Image.asset(
                Assets.imagesIcPrivacy,
                scale: 5,
              ),
              Text(
                "Privacy",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(
                  color: AppColors.labelBlackColor,
                  fontWeight: FontWeight.w600,

                ),
              ).paddingOnly(left: Get.width * .1),
            ],
          ).paddingOnly(top: Get.height * .05),
          GestureDetector(
            onTap: () {
              _showLogoutDialog(context);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.imagesIcLogOut,
                  height: 15,
                  width: 17,
                ).paddingOnly(left: 3),
                Text(
                  "Logout",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,

                  ),
                ).paddingOnly(left: Get.width * .11),
              ],
            ).paddingOnly(top: Get.height * .05),
          ),
        ],
      ).paddingOnly(left: Get.width * .05, right: Get.width * .05),
    );
  }
}
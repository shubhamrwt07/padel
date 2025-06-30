import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/presentations/cart/cart_screen.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';

import '../../configs/app_colors.dart';
import '../../configs/components/app_bar.dart';
import '../../generated/assets.dart';

class ProfileUi extends GetView<ProfileController> {
  const ProfileUi({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(RoutesName.editProfile);
                    },
                    child: Container(
                      height: Get.height * .11,
                      width: Get.width * .24,
                      decoration: BoxDecoration(
                        color: AppColors.tabSelectedColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(Icons.person,
                          size: 90, color: AppColors.labelBlackColor),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
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
            child: Container(
              color: Colors.transparent,
              height: 60,
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
              ),
            ).paddingOnly(top: Get.height * .05),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(RoutesName.paymentWallet);
            },
            child: Container(
              height: 60,
              color: Colors.transparent,
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
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Get.toNamed(RoutesName.cart);
              Get.to(()=>CartScreen(buttonType: "true"),transition: Transition.rightToLeft);
            },
            child: Container(
              color: Colors.transparent,
              height: 60,
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
              ),
            ),
          ),
          GestureDetector(
            onTap: ()=>Get.toNamed(RoutesName.support),
            child: Container(
              color: Colors.transparent,
              height: 60,
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
              ),
            ),
          ),
          Container(
            color: Colors.transparent,
            height: 60,
            child: Row(
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
            ),
          ),
          GestureDetector(
            onTap: () {
              _showLogoutDialog(context);
            },
            child: Container(
              color: Colors.transparent,
              height: 60,
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
              ),
            ),
          ),
        ],
      ).paddingOnly(left: Get.width * .05, right: Get.width * .05),
    );
  }
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
              "Are you sure you want to\nlogout?",
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ).paddingOnly(top: Get.height*0.02),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Get.offAllNamed(RoutesName.login);
                  },
                  child: Container(
                    height: Get.height*0.04,
                    width: Get.width*0.22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.textColor,
                        borderRadius: BorderRadius.circular(6)
                    ),
                    child: Text("Yes",style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600,color: AppColors.whiteColor),),
                  ).paddingOnly(right: 10),
                ),
                GestureDetector(
                  onTap: ()=>Get.back(),
                  child: Container(
                    height: Get.height*0.04,
                    width: Get.width*0.22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(6)
                    ),
                    child: Text("No",style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600,color: AppColors.whiteColor),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
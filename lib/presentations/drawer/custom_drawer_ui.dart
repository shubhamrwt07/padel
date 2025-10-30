import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/configs/app_strings.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';
import 'package:padel_mobile/generated/assets.dart';
import 'package:padel_mobile/presentations/cart/cart_screen.dart';
import 'package:padel_mobile/presentations/profile/profile_controller.dart';
import 'package:padel_mobile/presentations/drawer/zoom_drawer_controller.dart';

class CustomDrawerUi extends GetView<ProfileController> {
  const CustomDrawerUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.2,
      decoration: const BoxDecoration(
        color: Colors.white,
        // Removed borderRadius and boxShadow to eliminate line and shadow
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          Expanded(child: _buildMenuItems()),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 👈 All children start-aligned
        children: [
          // Close Button - Top Right
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            ],
          ),
          const SizedBox(height: 16),

          // Profile Picture - Left-Aligned (No Center wrapper)
          Obx(
                () => Container(
              alignment: Alignment.centerLeft, // 👈 Optional: ensures image stays left even if container is wide
              padding: const EdgeInsets.only(left: 16), // 👈 Optional: indent from edge like name/email
              child: Container(
                height: Get.height * 0.1,
                width: Get.height * 0.1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.tabSelectedColor,
                ),
                child: ClipOval(
                  child: (controller.profileModel.value?.response?.profilePic?.isNotEmpty ?? false)
                      ? CachedNetworkImage(
                    imageUrl: controller.profileModel.value?.response?.profilePic ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.labelBlackColor,
                    ),
                  )
                      : Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.labelBlackColor,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Name, Email, Edit Button - Left-Aligned Below Image
          Padding(
            padding: const EdgeInsets.only(left: 16), // 👈 Keep same indent as image
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final profile = controller.profileModel.value?.response;
                  return Text(
                    "${profile?.name ?? 'Unknown'} ${profile?.lastname ?? ""}",
                    style: Get.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.labelBlackColor,
                    ),
                  );
                }),
                const SizedBox(height: 5),
                Obx(() {
                  final profile = controller.profileModel.value?.response;
                  return Text(
                    profile?.email ?? 'unknown@gmail.com',
                    style: Get.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.labelBlackColor,
                    ),
                  );
                }),
                const SizedBox(height: 8),
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
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF3DBE64),
                          Color(0xFF1F41BB),
                        ],
                        stops: [0.1, 0.4],
                      ),
                    ),
                    child: Text(
                      AppStrings.editProfile,
                      style: Get.textTheme.bodyLarge!.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).paddingOnly(top: 30);
  }  Widget _buildMenuItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [

          Obx(
                () => ProfileRow(
              icon: Image.asset(Assets.imagesIcBalanceWallet, scale: 5, color: controller.selectedIndex.value == 3 ? AppColors.primaryColor : AppColors.labelBlackColor),
              title: AppStrings.payments,
              isSelected: controller.selectedIndex.value == 3,
              onTap: () {
                controller.selectedIndex.value = 3;
                Get.toNamed(RoutesName.paymentWallet);
              },
            ),
          ),

          Obx(
                () => ProfileRow(
              icon: Icon(Icons.shopping_cart_outlined, size: 20, color: controller.selectedIndex.value == 5 ? AppColors.primaryColor : AppColors.labelBlackColor),
              title: AppStrings.cart,
              isSelected: controller.selectedIndex.value == 5,
              onTap: () {
                controller.selectedIndex.value = 5;
                Get.to(() => CartScreen(buttonType: "true"), transition: Transition.rightToLeft);
              },
            ),
          ),
          Obx(
                () => ProfileRow(
              icon: SvgPicture.asset(Assets.imagesIcPackages, height: 17, width: 17, color: controller.selectedIndex.value == 6 ? AppColors.primaryColor : AppColors.labelBlackColor),
              title: "Packages",
              isSelected: controller.selectedIndex.value == 6,
              onTap: () {
                controller.selectedIndex.value = 6;
                Get.toNamed(RoutesName.packages);
              },
            ),
          ),
          Obx(
                () => ProfileRow(
              icon: Icon(Icons.headset_mic_outlined, size: 20, color: controller.selectedIndex.value == 7 ? AppColors.primaryColor : AppColors.labelBlackColor),
              title: AppStrings.helpSupport,
              isSelected: controller.selectedIndex.value == 7,
              onTap: () {
                controller.selectedIndex.value = 7;
                Get.toNamed(RoutesName.support);
              },
            ),
          ),
          Obx(
                () => ProfileRow(
              icon: Image.asset(Assets.imagesIcPrivacy, scale: 5, color: controller.selectedIndex.value == 8 ? AppColors.primaryColor : AppColors.labelBlackColor),
              title: AppStrings.privacy,
              isSelected: controller.selectedIndex.value == 8,
              onTap: () {
                controller.selectedIndex.value = 8;
              },
            ),
          ),
          ProfileRow(
            icon: SvgPicture.asset(Assets.imagesIcLogOut, height: 15, width: 17).paddingOnly(left: 3),
            title: AppStrings.logout,
            textColor: Colors.red,
            onTap: () => controller.showLogoutDialog(Get.context!),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Reusable row widget
class ProfileRow extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback? onTap;
  final Color? textColor;
  final bool isSelected;

  const ProfileRow({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.textColor,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = AppColors.labelBlackColor;
    final highlightColor = AppColors.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        color: Colors.transparent,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 40),
            Text(
              title,
              style: Get.textTheme.headlineSmall!.copyWith(
                color: isSelected ? highlightColor : (textColor ?? defaultColor),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

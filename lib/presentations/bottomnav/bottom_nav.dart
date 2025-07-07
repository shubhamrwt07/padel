import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:get/get.dart';

import '../../configs/app_colors.dart';
import '../../generated/assets.dart';
import 'bottom_nav_controller.dart';

class BottomNavUi extends StatelessWidget {
  BottomNavUi({super.key});

  final BottomNavigationController controller = Get.put(BottomNavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.getCurrentPage()),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Container(
          height: 60,
          decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(40),
            color: Colors.white,
            image: DecorationImage(image: AssetImage(Assets.imagesImgBackgroundBottomBar),fit: BoxFit.cover)
          ),
          child: Obx(
                () => GNav(
              tabBackgroundColor: AppColors.tabSelectedColor,
              gap: 8,
              padding: const EdgeInsets.all(12),
              color: Colors.black,
              activeColor: Colors.white,
              selectedIndex: controller.selectedIndex.value,
              onTabChange: (index) {
                controller.updateIndex(index);
              },
              tabs: List.generate(4, (index) {
                final tab = controller.tabs[index];
                final isSelected =
                    controller.selectedIndex.value == index;
                final isSvg = tab['isSvg'] == true;
                final iconSize = tab['size'] ?? 24.0;

                final iconWidget = isSvg
                    ? SvgPicture.asset(
                  tab['icon'],
                  width: iconSize,
                  height: iconSize,
                  color: isSelected ? null : AppColors.labelBlackColor,
                )
                    : Icon(
                  tab['icon'],
                  size: iconSize,
                  color: isSelected ? null : AppColors.labelBlackColor,
                );

                final leadingWidget = isSelected
                    ? ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) =>
                      getGradientShader(bounds),
                  child: isSvg
                      ? SvgPicture.asset(
                    tab['icon'],
                    width: iconSize,
                    height: iconSize,
                  )
                      : Icon(
                    tab['icon'],
                    size: iconSize,
                  ),
                )
                    : null;

                return GButton(
                  haptic: true,
                  gap: 10,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  icon: isSvg ? Icons.circle : tab['icon'],
                  text: tab['label'],
                  iconColor: Colors.black,
                  textColor: Colors.black,
                  leading: leadingWidget ?? iconWidget,
                  textStyle: isSelected
                      ? TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = getGradientShader(
                        Rect.fromLTWH(0, 0, 100, 60),
                      ),
                  )
                      : const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                );
              }),
            ).paddingOnly(left: 5, right: 5),
          ),
        ),
      ).paddingOnly(left: 16,right: 16,bottom: 24),
    );
  }
  Shader getGradientShader(Rect bounds) {
    return const LinearGradient(
      colors: [AppColors.primaryColor, AppColors.secondaryColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds);
  }
}

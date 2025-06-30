import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:get/get.dart';

import '../../configs/app_colors.dart';
import '../../generated/assets.dart';
import 'bottom_nav_controller.dart';

class BottomNavUi extends StatelessWidget {
  BottomNavUi({super.key});

  final BottomNavigationController _controller =
  Get.put(BottomNavigationController());

  Shader getGradientShader(Rect bounds) {
    return const LinearGradient(
      colors: [AppColors.primaryColor, AppColors.secondaryColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _controller.getCurrentPage()),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Obx(
                    () => GNav(
                  tabBackgroundColor: AppColors.tabSelectedColor,
                  gap: 8,
                  padding: const EdgeInsets.all(12),
                  color: Colors.black,
                  activeColor: Colors.white,
                  selectedIndex: _controller.selectedIndex.value,
                  onTabChange: (index) {
                    _controller.updateIndex(index);
                  },
                  tabs: List.generate(4, (index) {
                    final tab = _tabs[index];
                    final isSelected =
                        _controller.selectedIndex.value == index;
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
                            Rect.fromLTWH(0, 0, 100, 20),
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
          ),
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> _tabs = [
    {'icon': Icons.home_outlined, 'label': 'Home', 'size': 28.0},
    {'icon': Assets.imagesIcCap, 'label': 'Coach', 'isSvg': true, 'size': 22.0},
    {'icon': Icons.shopping_cart, 'label': 'Cart', 'size': 24.0},
    {'icon':  Assets.imagesIcProfile, 'label': 'Profile', 'isSvg': true, 'size': 22.0},
  ];
}

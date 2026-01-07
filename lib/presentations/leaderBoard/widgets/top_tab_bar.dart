import 'package:flutter/material.dart';
import 'package:padel_mobile/configs/app_colors.dart';
import 'package:padel_mobile/presentations/leaderBoard/leader_board_controller.dart';
import 'package:get/get.dart';
class TopTabBar extends StatelessWidget {
  final LeaderboardController controller = Get.put(LeaderboardController());
  TopTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = controller.categories.indexOf(controller.selectedCategory.value);
    return DefaultTabController(
      length: controller.categories.length,
      initialIndex: 0, // Always keep Player tab selected
      child: TabBar(
        isScrollable: true,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 2, color: Colors.white),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        dividerHeight: 0.5,
        dividerColor: AppColors.whiteColor,
        labelStyle: Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900),
        indicatorWeight: 1,
        labelPadding: const EdgeInsets.only(left: 0, right: 30),
        unselectedLabelStyle: Get.textTheme.headlineSmall,
        onTap: (index) {
          final selectedTab = controller.categories[index];
          if (selectedTab != 'Player') {
            Get.snackbar(
              'Coming Soon',
              'This feature will be available soon!',
              snackPosition: SnackPosition.TOP,
              backgroundColor: AppColors.whiteColor,
              colorText: AppColors.primaryColor,
              duration: const Duration(seconds: 2),
            );
          }
        },
        tabs: controller.categories
            .map((tab) => Tab(
              child: Opacity(
                opacity: tab == 'Player' ? 1.0 : 0.5,
                child: Text(
                  tab,
                  style: tab == 'Player' 
                    ? Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900, color: Colors.white)
                    : Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900, color: Colors.white38),
                ),
              ),
            ))
            .toList(),
      ),
    );
  }
}
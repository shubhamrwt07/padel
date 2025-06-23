import 'package:flutter/material.dart';
import 'package:padel_mobile/configs/app_colors.dart';
PreferredSizeWidget myTabBar(TabController tabController, BuildContext context,) {
  return TabBar(
    controller: tabController,
    unselectedLabelStyle: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 10,color: AppColors.textColor,fontWeight: FontWeight.w400),
    labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 12,color: AppColors.primaryColor,fontWeight: FontWeight.w500),
    // indicatorSize: TabBarIndicatorSize.tab,
    dividerHeight: 0.5,
    dividerColor: AppColors.textColor.withValues(alpha: 0.1),
    labelPadding: const EdgeInsets.all(2),
    automaticIndicatorColorAdjustment: true,
    // indicator: BoxDecoration(
    //     color: AppColors.whiteColor,
    //     borderRadius: BorderRadius.circular(10)
    // ),
    indicatorWeight: 1,
    tabs: const [
      Tab(
        child: Text("Home"),
      ),
      Tab(
        child: Text("Book"),
      ),
      Tab(
        child: Text("Open Matches"),
      ),
      Tab(
        child: Text("Competitions"),
      ),
    ],
  );
}
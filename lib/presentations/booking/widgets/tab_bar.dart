import 'package:padel_mobile/presentations/booking/widgets/booking_exports.dart';

PreferredSizeWidget myTabBar(TabController tabController, BuildContext context,) {
  return TabBar(
    controller: tabController,
    isScrollable: true,
    unselectedLabelStyle: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 13,color: AppColors.textColor,fontWeight: FontWeight.w600),
    labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13,color: AppColors.primaryColor,fontWeight: FontWeight.w600),
    // indicatorSize: TabBarIndicatorSize.tab,
    dividerHeight: 0.5,
    dividerColor: AppColors.textColor.withValues(alpha: 0.1),
    labelPadding:  EdgeInsets.only(left: 0,right: 30),
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